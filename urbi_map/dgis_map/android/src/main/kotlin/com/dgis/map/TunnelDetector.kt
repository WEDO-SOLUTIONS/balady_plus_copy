package com.dgis.map

import android.os.Handler
import android.os.Looper
import ru.dgis.sdk.navigation.NavigationManager
import ru.dgis.sdk.navigation.RouteInfo
import ru.dgis.sdk.routing.RoadSubtype
import ru.dgis.sdk.routing.RoadSubtypeRouteLongAttribute
import ru.dgis.sdk.routing.RoutePoint

/**
 * Detects whether the current position along the active navigation route lies inside a tunnel
 * (RoadSubtype.TUNNEL), so the caller can force a dark map theme while driving through one.
 *
 * Shared by the phone map ([DgisMapView]) and the Android Auto session
 * ([com.dgis.map.android_auto.NavigationCarAppSession]) — both darken their own map surface.
 *
 * Entering a tunnel is reported immediately. Leaving is debounced by [EXIT_DEBOUNCE_MS] so a
 * short daylight gap between two consecutive tunnel segments doesn't flicker the theme.
 */
class TunnelDetector(
    navigationManager: NavigationManager,
    private val onTunnelStateChanged: (Boolean) -> Unit,
) : AutoCloseable {

    private val model = navigationManager.uiModel
    private val mainHandler = Handler(Looper.getMainLooper())
    private val exitRunnable = Runnable {
        exitPending = false
        applyTunnelState(false)
    }

    private var roadSubtypes: RoadSubtypeRouteLongAttribute = model.route.route.roadSubtypes
    private var isInTunnel = false
    private var exitPending = false

    private val closeables =
        mutableListOf<AutoCloseable>(
            model.routeChannel.connect(::onRouteChanged),
            model.routePositionChannel.connect(::onRoutePositionChanged),
        )

    init {
        // Evaluate the state immediately in case a route/position already exist (e.g. the
        // detector is (re)created while navigation is already in progress).
        model.routePosition?.let(::evaluatePosition)
    }

    private fun onRouteChanged(routeInfo: RouteInfo) {
        roadSubtypes = routeInfo.route.roadSubtypes
        model.routePosition?.let(::evaluatePosition)
    }

    private fun onRoutePositionChanged(position: RoutePoint?) {
        position?.let(::evaluatePosition)
    }

    private fun evaluatePosition(position: RoutePoint) {
        val inTunnel = roadSubtypes.entry(position)?.value == RoadSubtype.TUNNEL
        if (inTunnel) {
            cancelPendingExit()
            applyTunnelState(true)
        } else if (isInTunnel && !exitPending) {
            // Debounce the exit: a short gap between two tunnel segments shouldn't flip the
            // theme back and forth. Position updates arrive more often than the debounce
            // window, so the timer must not be rescheduled on every tick.
            exitPending = true
            mainHandler.postDelayed(exitRunnable, EXIT_DEBOUNCE_MS)
        }
    }

    private fun cancelPendingExit() {
        mainHandler.removeCallbacks(exitRunnable)
        exitPending = false
    }

    private fun applyTunnelState(value: Boolean) {
        if (isInTunnel == value) return
        isInTunnel = value
        onTunnelStateChanged(value)
    }

    override fun close() {
        cancelPendingExit()
        closeables.forEach(AutoCloseable::close)
    }

    private companion object {
        const val EXIT_DEBOUNCE_MS = 2000L
    }
}
