package com.dgis.map

import com.dgis.map.map_api.FavouritesStateMessage
import kotlinx.coroutines.channels.BufferOverflow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.SharedFlow

/// Carries favourites changes from the Flutter side to the Android Auto session.
///
/// Only the newest state is ever useful, so the buffer is conflated and emission is non-blocking:
/// [sendEvent] never suspends and never throws, whether or not a car session is collecting.
///
/// The previous implementation exposed a rendezvous `Channel` and wrote to it from a detached
/// `CoroutineScope(Dispatchers.Default).launch { send(...) }`. With no car session attached every
/// send suspended forever, leaking a coroutine plus its payload for each favourites change, and the
/// whole backlog was then delivered in one burst when a session finally connected — thrashing the
/// car screen stack.
object FavouritesUpdateNotifier {
    private val _events = MutableSharedFlow<FavouritesStateMessage>(
        replay = 0,
        extraBufferCapacity = 1,
        onBufferOverflow = BufferOverflow.DROP_OLDEST,
    )
    val events: SharedFlow<FavouritesStateMessage> get() = _events

    fun sendEvent(event: FavouritesStateMessage) {
        _events.tryEmit(event)
    }
}
