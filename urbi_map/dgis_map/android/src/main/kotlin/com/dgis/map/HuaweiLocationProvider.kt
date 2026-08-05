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
}