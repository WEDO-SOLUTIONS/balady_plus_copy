package com.dgis.map

import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import com.dgis.map.map_api.FavouritesStateMessage

object FavouritesUpdateNotifier {
    private val _events = MutableStateFlow<FavouritesStateMessage?>(null)
    val events: StateFlow<FavouritesStateMessage?> get() = _events

    fun sendEvent(event: FavouritesStateMessage?) {
        _events.value = event
    }
}
