package com.dgis.map.live_updates

import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.car.app.connection.CarConnection
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import androidx.lifecycle.Observer

/**
 * Glue between the Flutter method channel ("balady/navigation_live_updates"), the existing
 * NavigationHandler and the phone [NavigationForegroundService].
 *
 * - Dart pushes session metadata (destination, route type, language, enabled toggle).
 * - NavigationHandler reports session start/stop and navigation state transitions.
 * - The coordinator owns the service lifecycle, suppresses the phone notification while
 *   Android Auto projection is connected and posts the arrival notification.
 *
 * The bridge is one-way: nothing is ever sent back from a notification to Dart.
 */
object LiveUpdatesCoordinator {

    data class SessionMetadata(
        val destinationName: String?,
        /** "navigation" | "freeRoam" */
        val mode: String,
        val routeType: String,
        val language: String,
        /** Localized copy pushed from Dart; missing keys fall back to plugin resources. */
        val strings: Map<String, String>,
        val enabled: Boolean,
    )

    private const val TAG = "LiveUpdatesCoordinator"
    const val ARRIVAL_NOTIFICATION_ID = 2002

    @Volatile
    var metadata: SessionMetadata = SessionMetadata(
        destinationName = null,
        mode = "navigation",
        routeType = "car",
        language = "en",
        strings = emptyMap(),
        enabled = true,
    )
        private set

    @Volatile
    var isSessionActive: Boolean = false
        private set

    private var appContext: Context? = null
    private var carConnection: CarConnection? = null
    private var carProjectionConnected = false
    private val mainHandler = Handler(Looper.getMainLooper())

    private val carConnectionObserver = Observer<Int> { connectionType ->
        val connected = connectionType == CarConnection.CONNECTION_TYPE_PROJECTION
        if (connected == carProjectionConnected) return@Observer
        carProjectionConnected = connected
        if (!isSessionActive) return@Observer
        if (connected) {
            // Android Auto notification (id 1) takes over; drop the phone one.
            stopService()
        } else if (metadata.enabled) {
            startService()
        }
    }

    /** Called from DgisMapPlugin.onAttachedToEngine. */
    fun attach(context: Context) {
        appContext = context.applicationContext
    }

    fun setSessionMetadata(
        destinationName: String?,
        mode: String,
        routeType: String,
        language: String,
        strings: Map<String, String>,
        enabled: Boolean,
    ) {
        metadata = SessionMetadata(destinationName, mode, routeType, language, strings, enabled)
        if (!isSessionActive) return
        runOnMain {
            if (!enabled) {
                stopService()
            } else if (!carProjectionConnected) {
                startService()
            }
        }
    }

    /** Dart-side session teardown: stop the service/notification, keep navigation untouched. */
    fun endSession() {
        onSessionStopped()
    }

    /**
     * Called by NavigationHandler after a successful non-public-transport
     * navigationManager.start()/startSimulation().
     */
    fun onSessionStarted(context: Context) {
        appContext = context.applicationContext
        isSessionActive = true
        cancelArrivalNotification()
        runOnMain {
            observeCarConnection()
            if (metadata.enabled && !carProjectionConnected) {
                startService()
            }
        }
    }

    /** Called by NavigationHandler.stopNavigation and on terminal states. Idempotent. */
    fun onSessionStopped() {
        if (!isSessionActive) return
        isSessionActive = false
        runOnMain {
            stopService()
            unobserveCarConnection()
        }
        NavLiveEventBus.reset()
    }

    /** Mirrors NavigationHandler.stateChannelListener state names into the bus. */
    fun onNavStateChanged(state: String) {
        NavLiveEventBus.navState.value = state
        when (state) {
            "finished" -> {
                if (isSessionActive) {
                    if (metadata.enabled && !carProjectionConnected) {
                        postArrivalNotification()
                    }
                    onSessionStopped()
                }
            }
            "disabled" -> onSessionStopped()
        }
    }

    private fun startService() {
        val context = appContext ?: return
        try {
            ContextCompat.startForegroundService(
                context,
                Intent(context, NavigationForegroundService::class.java),
            )
        } catch (e: Exception) {
            // e.g. ForegroundServiceStartNotAllowedException when resuming from background.
            Log.w(TAG, "Unable to start navigation foreground service", e)
        }
    }

    private fun stopService() {
        val context = appContext ?: return
        try {
            context.stopService(Intent(context, NavigationForegroundService::class.java))
        } catch (e: Exception) {
            Log.w(TAG, "Unable to stop navigation foreground service", e)
        }
    }

    private fun postArrivalNotification() {
        val context = appContext ?: return
        try {
            NavNotificationBuilder.ensureChannel(context)
            NotificationManagerCompat.from(context).notify(
                ARRIVAL_NOTIFICATION_ID,
                NavNotificationBuilder.buildArrival(context, metadata),
            )
        } catch (e: SecurityException) {
            Log.w(TAG, "Missing notification permission for arrival notification", e)
        }
    }

    private fun cancelArrivalNotification() {
        val context = appContext ?: return
        NotificationManagerCompat.from(context).cancel(ARRIVAL_NOTIFICATION_ID)
    }

    private fun observeCarConnection() {
        if (carConnection != null) return
        val context = appContext ?: return
        carConnection = CarConnection(context).also {
            it.type.observeForever(carConnectionObserver)
        }
    }

    private fun unobserveCarConnection() {
        carConnection?.type?.removeObserver(carConnectionObserver)
        carConnection = null
        carProjectionConnected = false
    }

    private fun runOnMain(block: () -> Unit) {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            block()
        } else {
            mainHandler.post(block)
        }
    }
}
