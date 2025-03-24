package com.dgis.map.providers

import android.content.Context
import android.location.Location
import android.os.HandlerThread
import android.util.Log
import com.huawei.hms.location.*

class HuaweiLocationProvider(private val context: Context) {
    private var client: FusedLocationProviderClient? = null
    private var callback: LocationCallback? = null
    private var thread: HandlerThread? = null

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
                result.locations.lastOrNull()?.let { onLocationUpdate(it) }
            }
        }
        client?.requestLocationUpdates(request, callback, thread.looper)
    }
    fun getLastKnownLocation(): Location? {
        return client?.lastLocation?.result
    }


    fun stopLocationUpdates() {
        callback?.let { client?.removeLocationUpdates(it) }
        Log.d("HuaweiLocationProvider", "Huawei Location updates stopped.")
    }
}