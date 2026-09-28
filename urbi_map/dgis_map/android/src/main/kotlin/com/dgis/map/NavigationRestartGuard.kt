package com.dgis.map

import android.os.SystemClock

/**
 * Guidance restarted on a new route over a live trip (a stop added on the phone, HB-122).
 * The SDK may report DISABLED meanwhile; a head unit must not take it for a trip end.
 */
object NavigationRestartGuard {
    const val WINDOW_MS = 3000L

    @Volatile
    private var startedAt = 0L

    fun markRestart() {
        startedAt = SystemClock.elapsedRealtime()
    }

    val isRestarting: Boolean
        get() = startedAt != 0L && SystemClock.elapsedRealtime() - startedAt < WINDOW_MS
}
