package com.dgis.map

import android.annotation.SuppressLint
import android.content.Context
import android.location.Location
import android.os.HandlerThread
import android.util.Log
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices

class GoogleLocationProvider(private val context: Context) {
    private var client: FusedLocationProviderClient? = null
    private var callback: LocationCallback? = null
    private var thread: HandlerThread? = null
    private var lastLocation: Location? = null

    init {
        client = LocationServices.getFusedLocationProviderClient(context)
    }

    @SuppressLint("MissingPermission")
    fun requestLocationUpdates(accuracy: Int, interval: Long, onLocationUpdate: (Location) -> Unit) {
        val thread = thread ?: HandlerThread("GoogleLocationThread").also {
            it.start()
            this.thread = it
        }

        val request = LocationRequest.Builder(accuracy, interval).build()
        callback = object : LocationCallback() {
            override fun onLocationResult(result: LocationResult) {
                result.locations.lastOrNull()?.let {
                    lastLocation = it
                    onLocationUpdate(it)
                }
            }
        }
        try {
            client?.requestLocationUpdates(request, callback!!, thread.looper)
        } catch (e: SecurityException) {
            Log.w("GoogleLocationProvider", "requestLocationUpdates without location permission", e)
        }
    }

    @SuppressLint("MissingPermission")
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
                Log.e("GoogleLocationProvider", "Failed to get last location", it)
                onResult(null)
            }
        } catch (e: SecurityException) {
            Log.w("GoogleLocationProvider", "lastLocation without location permission", e)
            onResult(null)
        }
    }

    fun stopLocationUpdates() {
        callback?.let { client?.removeLocationUpdates(it) }
        Log.d("GoogleLocationProvider", "Google Location updates stopped.")
    }
}