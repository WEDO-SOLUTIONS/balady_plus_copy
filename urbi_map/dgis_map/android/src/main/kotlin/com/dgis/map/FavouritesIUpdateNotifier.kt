package com.dgis.map

import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import com.dgis.map.map_api.FavouritesStateMessage
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.ReceiveChannel
import kotlinx.coroutines.launch

object FavouritesUpdateNotifier {
    private val _events = Channel<FavouritesStateMessage>()
    val events: ReceiveChannel<FavouritesStateMessage> get() = _events

    fun sendEvent(event: FavouritesStateMessage) {
        CoroutineScope(Dispatchers.Default).launch {
            _events.send(event)
        }
    }
}
