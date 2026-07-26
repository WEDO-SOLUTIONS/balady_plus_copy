package com.dgis.map.live_updates

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/** Handles the "End Trip" action on the phone navigation notification. */
class EndTripReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != NavNotificationBuilder.ACTION_END_TRIP) return
        LiveUpdatesCoordinator.requestEndTrip()
    }
}
