package com.dgis.map

import android.content.Context
import android.location.Location
import android.util.Log
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import ru.dgis.sdk.positioning.DesiredAccuracy
import ru.dgis.sdk.positioning.LocationChangeListener
import ru.dgis.sdk.positioning.LocationSource

class FusedLocationSource(private val context: Context) : LocationSource {
    private var locationProvider: Any? = null
    private var listener: LocationChangeListener? = null
    private var accuracy: DesiredAccuracy = DesiredAccuracy.MEDIUM
    private var isAvailable: Boolean = false

    init {
        locationProvider = if (isGooglePlayServicesAvailable(context)) {
            GoogleLocationProvider(context)
        } else {
            HuaweiLocationProvider(context)
        }
    }

    val lastLocation: Location?
        get() {
            var location: Location? = null
            (locationProvider as? GoogleLocationProvider)?.getLastKnownLocation {
                location = it
            } ?: (locationProvider as? HuaweiLocationProvider)?.getLastKnownLocation {
                location = it
            }
            return location
        }

    override fun activate(listener: LocationChangeListener) {
        if (this.listener != null) {
            throw IllegalStateException("This source is already activated")
        }
        this.listener = listener
        updateSource()
    }

    override fun deactivate() {
        when (locationProvider) {
            is GoogleLocationProvider -> (locationProvider as GoogleLocationProvider).stopLocationUpdates()
            is HuaweiLocationProvider -> (locationProvider as HuaweiLocationProvider).stopLocationUpdates()
        }
        listener?.onAvailabilityChanged(false)
        listener = null
    }

    override fun setDesiredAccuracy(accuracy: DesiredAccuracy) {
        if (accuracy == this.accuracy) return
        this.accuracy = accuracy
        updateSource()
    }

    fun onPermissionGranted() {
        isAvailable = true
        updateSource()
    }

    private fun updateSource() {
        val listener = this.listener ?: return
        Log.d("HuaweiLocationProvider", "Huawei Location  isAvailable $isAvailable")

        if (isAvailable) {
            val (priority, interval) = when (accuracy) {
                DesiredAccuracy.HIGH -> Pair(100, 100L)
                DesiredAccuracy.MEDIUM -> Pair(102, 1000L)
                DesiredAccuracy.LOW -> Pair(104, 5000L)
            }

            when (locationProvider) {
                is GoogleLocationProvider -> (locationProvider as GoogleLocationProvider).apply {
                    stopLocationUpdates()
                    requestLocationUpdates(priority, interval) { processLocationResult(it) }
                }

                is HuaweiLocationProvider -> (locationProvider as HuaweiLocationProvider).apply {
                    stopLocationUpdates()
                    requestLocationUpdates(priority, interval) { processLocationResult(it) }
                }
            }
            listener.onAvailabilityChanged(true)
        }
    }

    private fun processLocationResult(userLocation: Location) {
        listener?.onLocationChanged(arrayOf(userLocation))
    }

    private fun isGooglePlayServicesAvailable(context: Context): Boolean {
        val googleApiAvailability = GoogleApiAvailability.getInstance()
        val resultCode = googleApiAvailability.isGooglePlayServicesAvailable(context)
        return resultCode == ConnectionResult.SUCCESS
    }
}
