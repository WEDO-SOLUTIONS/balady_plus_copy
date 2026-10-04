package com.dgis.map

import android.content.Context
import android.location.Location
import android.os.HandlerThread
import android.util.Log
import com.huawei.hms.location.FusedLocationProviderClient
import com.huawei.hms.location.LocationCallback
import com.huawei.hms.location.LocationRequest
import com.huawei.hms.location.LocationResult
import com.huawei.hms.location.LocationServices

class HuaweiLocationProvider(private val context: Context) {
    private var client: FusedLocationProviderClient? = null
    private var callback: LocationCallback? = null
    private var thread: HandlerThread? = null
    private var lastLocation: Location? = null

    init {
        client = LocationServices.getFusedLocationProviderClient(context)
    }

    fun requestLocationUpdates(accuracy: Int, interval: Long, onLocationUpdate: (Location) -> Unit) {
        val thread = thread ?: HandlerThread("HuaweiLocationThread").also {
            it.start()
            this.thread = it
        }

        val request = LocationRequest().apply {
            priority = accuracy
            this.interval = interval
        }

        callback = object : LocationCallback() {
            override fun onLocationResult(result: LocationResult) {
                result.locations.lastOrNull()?.let {
                    if (isGpsJitter(it)) return@let
                    lastLocation = it
                    onLocationUpdate(it)
                }
            }
        }
        try {
            client?.requestLocationUpdates(request, callback, thread.looper)
        } catch (e: SecurityException) {
            Log.w("HuaweiLocationProvider", "requestLocationUpdates without location permission", e)
        }
    }

    /**
     * Huawei's fused provider doesn't smooth fixes the way Google's does, so consecutive
     * readings can drift a few meters apart while the device is stationary, making the car
     * marker appear to move at 0 km/h. Drop fixes that look like GPS noise rather than
     * real movement: near-zero reported speed and displacement within the fix's own accuracy.
     */
    private fun isGpsJitter(location: Location): Boolean {
        val previous = lastLocation ?: return false
        val isNearlyStationary = !location.hasSpeed() || location.speed < STATIONARY_SPEED_THRESHOLD_MPS
        if (!isNearlyStationary) return false

        val jitterRadius = maxOf(location.accuracy, MIN_JITTER_RADIUS_METERS)
        return location.distanceTo(previous) < jitterRadius
    }

    fun getLastKnownLocation(onResult: (Location?) -> Unit) {
        lastLocation?.let {
            onResult(it)
            return
        }

        try {
            client?.lastLocation?.addOnSuccessListener { location ->
                lastLocation = location
                onResult(location)
            }?.addOnFailureListener {
                onResult(null)
            }
        } catch (e: SecurityException) {
            Log.w("HuaweiLocationProvider", "lastLocation without location permission", e)
            onResult(null)
        }
    }


    fun stopLocationUpdates() {
        callback?.let { client?.removeLocationUpdates(it) }
        Log.d("HuaweiLocationProvider", "Huawei Location updates stopped.")
    }

    companion object {
        private const val STATIONARY_SPEED_THRESHOLD_MPS = 1.0f
        private const val MIN_JITTER_RADIUS_METERS = 5f
    }
}