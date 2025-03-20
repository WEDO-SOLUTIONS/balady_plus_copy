package com.dgis.map

import android.annotation.SuppressLint
import android.content.Context
import android.os.HandlerThread
import android.util.Log
import android.location.Location

import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority as GooglePriority

import com.huawei.hms.location.LocationRequest as HuaweiPriority
import com.huawei.hms.common.ApiException
import com.huawei.hms.location.FusedLocationProviderClient as HuaweiFusedLocationProviderClient
import com.huawei.hms.location.LocationCallback as HuaweiLocationCallback
import com.huawei.hms.location.LocationRequest as HuaweiLocationRequest
import com.huawei.hms.location.LocationResult as HuaweiLocationResult
import com.huawei.hms.location.LocationServices as HuaweiLocationServices

import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.coordinates.GeoRect
import ru.dgis.sdk.positioning.DesiredAccuracy
import ru.dgis.sdk.positioning.LocationChangeListener
import ru.dgis.sdk.positioning.LocationSource

class FusedLocationSource(private val context: Context) : LocationSource {
    private var googleClient: FusedLocationProviderClient? = null
    private var huaweiClient: HuaweiFusedLocationProviderClient? = null
    private var listener: LocationChangeListener? = null
    private var accuracy: DesiredAccuracy = DesiredAccuracy.MEDIUM
    private var callback: LocationCallback? = null
    private var hmsCallback: com.huawei.hms.location.LocationCallback? = null
    private var thread: HandlerThread? = null
    private var isAvailable: Boolean = false
    private var isGoogleAvailable: Boolean = false
    private var mockLocation: Boolean? = null

    @Suppress("Unused")
    var lastLocation: Location? = null

    init {
        isGoogleAvailable = isGooglePlayServicesAvailable(context)
        if (isGoogleAvailable) {
            googleClient = LocationServices.getFusedLocationProviderClient(context)
        } else {
            huaweiClient = HuaweiLocationServices.getFusedLocationProviderClient(context)
        }
    }

    @Synchronized
    override fun activate(listener: LocationChangeListener) {
        if (this.listener != null) {
            throw IllegalStateException("This source is already activated")
        }
        this.listener = listener
        updateSource()
    }

    @Synchronized
    override fun deactivate() {
        googleClient = null
        huaweiClient = null
        listener = null
        callback = null
        hmsCallback = null
        thread?.quitSafely()
        thread = null
    }

    @Synchronized
    override fun setDesiredAccuracy(accuracy: DesiredAccuracy) {
        if (accuracy == this.accuracy) return
        this.accuracy = accuracy
        updateSource()
    }

    fun onPermissionGranted() {
        if (isAvailable) return
        isAvailable = true
        updateSource()
    }

    @SuppressLint("MissingPermission")
    private fun updateSource() {
        val listener = this.listener ?: return
        if (isAvailable) {
            try {
                val thread = thread ?: HandlerThread("DgisLocation").also {
                    it.start()
                    this.thread = it
                }


                if (isGoogleAvailable) {
                    var (newPriority, interval) = when (accuracy) {
                        DesiredAccuracy.HIGH -> Pair(GooglePriority.PRIORITY_HIGH_ACCURACY, 100L)
                        DesiredAccuracy.MEDIUM -> Pair(GooglePriority.PRIORITY_HIGH_ACCURACY, 1000L)
                        DesiredAccuracy.LOW -> Pair(GooglePriority.PRIORITY_BALANCED_POWER_ACCURACY, 5000L)
                    }

                    val request = LocationRequest.Builder(newPriority, interval).build()
                    callback = object : LocationCallback() {
                        override fun onLocationResult(result: LocationResult) {
                            processLocationResult(result.locations.toTypedArray())
                        }
                    }
                    googleClient?.requestLocationUpdates(request, callback!!, thread.looper)
                } else {
                    val newPriority: Int = when (accuracy) {
                        DesiredAccuracy.HIGH -> HuaweiPriority.PRIORITY_HIGH_ACCURACY
                        DesiredAccuracy.MEDIUM -> HuaweiPriority.PRIORITY_BALANCED_POWER_ACCURACY
                        DesiredAccuracy.LOW -> HuaweiPriority.PRIORITY_LOW_POWER
                    }
                    val newInterval: Long = when (accuracy) {
                        DesiredAccuracy.HIGH -> 100L
                        DesiredAccuracy.MEDIUM -> 1000L
                        DesiredAccuracy.LOW -> 5000L
                    }

                    val request = HuaweiLocationRequest().apply {
                        priority = newPriority
                        interval = newInterval
                    }

                    hmsCallback = object : com.huawei.hms.location.LocationCallback() {
                        override fun onLocationResult(result: HuaweiLocationResult) {
                            processLocationResult(result.locations.toTypedArray())
                        }
                    }
                    huaweiClient?.requestLocationUpdates(request, hmsCallback, thread.looper)
                }
                listener.onAvailabilityChanged(true)
            } catch (e: Exception) {
                Log.e("2Gis", "Failed to create location source", e)
            }
        } else {
            callback?.let { googleClient?.removeLocationUpdates(it) }
            hmsCallback?.let { huaweiClient?.removeLocationUpdates(it) }
            listener.onAvailabilityChanged(false)
        }
    }

    private fun processLocationResult(locations: Array<Location>) {
        val listener = this.listener ?: return
        if (locations.isEmpty()) {
            listener.onLocationChanged(emptyArray())
            lastLocation = null
        } else {
            val userLocation = locations.last()
            // Use mocked location if user location is outside KSA,
            if (mockLocation == null) {
                mockLocation = !saRect.contains(
                    GeoPoint(userLocation.latitude, userLocation.longitude)
                )
            }
            if (mockLocation!!) {
                userLocation.apply {
                    latitude = 24.712899222459676
                    longitude = 46.631036554650116
                }
            }

            listener.onLocationChanged(arrayOf(userLocation))
            lastLocation = userLocation

            if (googleClient != null) {
                googleClient?.removeLocationUpdates(callback!!)
                Log.d("LocationUpdates", "Google Location updates stopped.")
            } else if (huaweiClient != null) {
                huaweiClient?.removeLocationUpdates(hmsCallback!!)
                Log.d("LocationUpdates", "Huawei Location updates stopped.")
            }
        }
    }

    private fun isGooglePlayServicesAvailable(context: Context): Boolean {
        val googleApiAvailability = GoogleApiAvailability.getInstance()
        val resultCode = googleApiAvailability.isGooglePlayServicesAvailable(context)
        return resultCode == ConnectionResult.SUCCESS
    }

    private companion object {
        val saRect = GeoRect(
            GeoPoint(15.506104, 32.61185), GeoPoint(32.568765, 56.694472)
        )
    }
}
