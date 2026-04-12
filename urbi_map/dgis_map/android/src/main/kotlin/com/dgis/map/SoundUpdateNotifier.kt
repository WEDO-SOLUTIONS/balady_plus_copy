package com.dgis.map

import com.dgis.map.map_api.SoundToggleType
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.ReceiveChannel
import kotlinx.coroutines.launch

/** Notifies the phone-side DgisMapView when Android Auto changes voice instruction settings.
 * This allows sending the sound event through the existing event channel to Flutter. */
object SoundUpdateNotifier {
    private val _events = Channel<SoundToggleType>()
    val events: ReceiveChannel<SoundToggleType> get() = _events

    fun sendEvent(toggleType: SoundToggleType) {
        CoroutineScope(Dispatchers.Default).launch {
            _events.send(toggleType)
        }
    }
}

