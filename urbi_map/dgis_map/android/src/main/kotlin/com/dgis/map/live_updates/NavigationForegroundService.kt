package com.dgis.map.live_updates

import android.app.Service
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import android.os.SystemClock
import android.util.Log
import androidx.core.app.NotificationManagerCompat
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.conflate
import kotlinx.coroutines.launch

/**
 * Phone foreground service carrying the ongoing navigation notification (id 2001).
 *
 * Started/stopped exclusively by [LiveUpdatesCoordinator]; it renders whatever the
 * navigation control models push into [NavLiveEventBus], throttled to at most one
 * notification update per second and only when the visible content changed.
 */
class NavigationForegroundService : Service() {

    private var scope: CoroutineScope? = null
    private var lastContentKey: String? = null
    private var lastNotifyElapsedMs = 0L

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        NavNotificationBuilder.ensureChannel(this)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val metadata = LiveUpdatesCoordinator.metadata
        val content = NavNotificationBuilder.renderContent(
            this, metadata, NavLiveEventBus.eta.value, NavLiveEventBus.maneuver.value,
        )
        val notification = NavNotificationBuilder.buildOngoing(this, metadata, content)
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                startForeground(
                    NOTIFICATION_ID, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION,
                )
            } else {
                startForeground(NOTIFICATION_ID, notification)
            }
        } catch (e: Exception) {
            Log.e(TAG, "startForeground failed", e)
            stopSelf()
            return START_NOT_STICKY
        }

        if (!LiveUpdatesCoordinator.isSessionActive) {
            // Stray start without an active navigation session — clean up immediately.
            stopSelf()
            return START_NOT_STICKY
        }

        lastContentKey = content.key
        lastNotifyElapsedMs = SystemClock.elapsedRealtime()
        startCollecting()
        return START_NOT_STICKY
    }

    override fun onDestroy() {
        scope?.cancel()
        scope = null
        stopForeground(STOP_FOREGROUND_REMOVE)
        super.onDestroy()
    }

    private fun startCollecting() {
        if (scope != null) return
        val serviceScope = CoroutineScope(SupervisorJob() + Dispatchers.Main)
        scope = serviceScope
        serviceScope.launch {
            combine(NavLiveEventBus.eta, NavLiveEventBus.maneuver) { eta, maneuver ->
                eta to maneuver
            }
                .conflate()
                .collect {
                    throttle()
                    // Re-read the latest values after the throttle delay.
                    updateNotification()
                }
        }
    }

    private suspend fun throttle() {
        val elapsed = SystemClock.elapsedRealtime() - lastNotifyElapsedMs
        if (elapsed < MIN_UPDATE_INTERVAL_MS) {
            delay(MIN_UPDATE_INTERVAL_MS - elapsed)
        }
    }

    private fun updateNotification() {
        val metadata = LiveUpdatesCoordinator.metadata
        val content = NavNotificationBuilder.renderContent(
            this, metadata, NavLiveEventBus.eta.value, NavLiveEventBus.maneuver.value,
        )
        if (content.key == lastContentKey) return
        lastContentKey = content.key
        lastNotifyElapsedMs = SystemClock.elapsedRealtime()
        try {
            NotificationManagerCompat.from(this).notify(
                NOTIFICATION_ID,
                NavNotificationBuilder.buildOngoing(this, metadata, content),
            )
        } catch (e: SecurityException) {
            Log.w(TAG, "Missing notification permission for navigation update", e)
        }
    }

    companion object {
        const val NOTIFICATION_ID = 2001
        private const val MIN_UPDATE_INTERVAL_MS = 1000L
        private const val TAG = "NavigationFgService"
    }
}
