package com.dgis.map

import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

/// Reacts when the user is authorized and event comes from
/// the Flutter side
object UserAuthorizedNotifier {
    private val _events = MutableStateFlow<Boolean>(false)
    val events: StateFlow<Boolean> get() = _events

    fun sendEvent(event: Boolean) {
        _events.value = event
    }
}