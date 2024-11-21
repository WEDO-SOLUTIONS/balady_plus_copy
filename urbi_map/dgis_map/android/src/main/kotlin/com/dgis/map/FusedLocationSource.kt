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
import com.google.android.gms.location.Priority
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.coordinates.GeoRect
import ru.dgis.sdk.positioning.DesiredAccuracy
import ru.dgis.sdk.positioning.LocationChangeListener
import ru.dgis.sdk.positioning.LocationSource

class FusedLocationSource(private val context: Context) : LocationSource {
    private var client: FusedLocationProviderClient? = null
    private var listener: LocationChangeListener? = null
    private var accuracy: DesiredAccuracy = DesiredAccuracy.MEDIUM
    private var callback: LocationCallback? = null
    private var thread: HandlerThread? = null
    private var isAvailable: Boolean = false

    @Suppress("Unused")
    var lastLocation: android.location.Location? = null

    @Synchronized
    override fun activate(listener: LocationChangeListener) {
        if (this.listener != null) {
            throw IllegalStateException("This source is already activated")
        }
        this.client = LocationServices.getFusedLocationProviderClient(context)
        this.listener = listener
        updateSource()
    }

    @Synchronized
    override fun deactivate() {
        client = null
        listener = null
        callback = null
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
        val client = this.client ?: return
        val listener = this.listener ?: return

        if (isAvailable) {
            try {
                val thread = thread ?: HandlerThread("DgisLocation").also {
                    it.start()
                    this.thread = it
                }

                val (newPriority, interval) = when (accuracy) {
                    DesiredAccuracy.HIGH -> Pair(Priority.PRIORITY_HIGH_ACCURACY, 100L)
                    DesiredAccuracy.MEDIUM -> Pair(Priority.PRIORITY_HIGH_ACCURACY, 1000L)
                    DesiredAccuracy.LOW -> Pair(Priority.PRIORITY_BALANCED_POWER_ACCURACY, 5000L)
                }
                val request = LocationRequest.Builder(newPriority, interval).build()
                val callback = (object : LocationCallback() {
                    override fun onLocationResult(result: LocationResult) {
                        val userLocation = result.lastLocation
                        val isLocationInsideKSA = userLocation != null && saRect.contains(
                            GeoPoint(
                                userLocation.latitude,
                                userLocation.longitude
                            )
                        )
                        // Use mocked location if user location is outside KSA
                        if (isLocationInsideKSA) {
                            listener.onLocationChanged(result.locations.toTypedArray())
                            lastLocation = result.lastLocation
                        } else {
                            val location = Location(null).apply {
                                latitude = 24.712899222459676
                                longitude = 46.631036554650116
                            }
                            listener.onLocationChanged(arrayOf(location))
                            lastLocation = location
                        }
                    }
                }).also {
                    this.callback = it
                }

                client.requestLocationUpdates(request, callback, thread.looper)
                listener.onAvailabilityChanged(true)
            } catch (e: Exception) {
                Log.e("2Gis", "Failed to create location source", e)
            }
        } else {
            this.callback?.let(client::removeLocationUpdates)
            listener.onAvailabilityChanged(false)
        }
    }

    private companion object {
        val saRect = GeoRect(
            GeoPoint(15.506104, 32.61185), GeoPoint(32.568765, 56.694472)
        )
    }
}
