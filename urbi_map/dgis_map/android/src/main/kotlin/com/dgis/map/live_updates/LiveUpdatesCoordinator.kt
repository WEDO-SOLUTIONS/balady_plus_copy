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
import io.flutter.plugin.common.MethodChannel

/**
 * Glue between the Flutter method channel ("balady/navigation_live_updates"), the existing
 * NavigationHandler and the phone [NavigationForegroundService].
 *
 * - Dart pushes session metadata (destination, route type, language, enabled toggle).
 * - NavigationHandler reports session start/stop and navigation state transitions.
 * - The coordinator owns the service lifecycle, suppresses the phone notification while
 *   Android Auto projection is connected, posts the arrival notification and forwards
 *   "End Trip" requests both natively (immediate stop) and to Dart (best-effort teardown).
 */
object LiveUpdatesCoordinator {

    data class SessionMetadata(
        val destinationName: String?,
        val routeType: String,
        val language: String,
        val enabled: Boolean,
    )

    private const val TAG = "LiveUpdatesCoordinator"
    const val ARRIVAL_NOTIFICATION_ID = 2002

    @Volatile
    var metadata: SessionMetadata = SessionMetadata(
        destinationName = null,
        routeType = "car",
        language = "en",
        enabled = true,
    )
        private set

    @Volatile
    var isSessionActive: Boolean = false
        private set

    private var appContext: Context? = null
    private var channel: MethodChannel? = null
    private var stopNavigationCallback: (() -> Unit)? = null
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
    fun attach(context: Context, methodChannel: MethodChannel) {
        appContext = context.applicationContext
        channel = methodChannel
    }

    /** Called from DgisMapPlugin.onDetachedFromEngine. */
    fun detachChannel() {
        channel = null
    }

    fun setSessionMetadata(
        destinationName: String?,
        routeType: String,
        language: String,
        enabled: Boolean,
    ) {
        metadata = SessionMetadata(destinationName, routeType, language, enabled)
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
     * navigationManager.start()/startSimulation(). [stopCallback] must stop navigation
     * natively (NavigationHandler.stopNavigation).
     */
    fun onSessionStarted(context: Context, stopCallback: () -> Unit) {
        appContext = context.applicationContext
        stopNavigationCallback = stopCallback
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
        if (!isSessionActive && stopNavigationCallback == null) return
        isSessionActive = false
        stopNavigationCallback = null
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

    /** Invoked by EndTripReceiver when the user taps "End Trip" on the notification. */
    fun requestEndTrip() {
        runOnMain {
            try {
                stopNavigationCallback?.invoke()
            } catch (e: Exception) {
                Log.w(TAG, "End trip stop callback failed", e)
            }
            onSessionStopped()
            try {
                channel?.invokeMethod("onEndTripRequested", null)
            } catch (e: Exception) {
                Log.w(TAG, "onEndTripRequested dispatch failed", e)
            }
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
