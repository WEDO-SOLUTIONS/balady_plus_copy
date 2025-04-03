package com.dgis.map.providers

import android.content.Context
import android.location.Location
import android.os.HandlerThread
import android.util.Log
import com.google.android.gms.location.*

class GoogleLocationProvider(private val context: Context) {
    private var client: FusedLocationProviderClient? = null
    private var callback: LocationCallback? = null
    private var thread: HandlerThread? = null

    init {
        client = LocationServices.getFusedLocationProviderClient(context)
    }

    fun requestLocationUpdates(accuracy: Int, interval: Long, onLocationUpdate: (Location) -> Unit) {
        val thread = thread ?: HandlerThread("GoogleLocationThread").also {
            it.start()
            this.thread = it
        }

        val request = LocationRequest.Builder(accuracy, interval).build()
        callback = object : LocationCallback() {
            override fun onLocationResult(result: LocationResult) {
                result.locations.lastOrNull()?.let { onLocationUpdate(it) }
            }
        }
        client?.requestLocationUpdates(request, callback!!, thread.looper)
    }

    fun getLastKnownLocation(): Location? {
        return client?.lastLocation?.result
    }


    fun stopLocationUpdates() {
        callback?.let { client?.removeLocationUpdates(it) }
        Log.d("GoogleLocationProvider", "Google Location updates stopped.")
    }
}