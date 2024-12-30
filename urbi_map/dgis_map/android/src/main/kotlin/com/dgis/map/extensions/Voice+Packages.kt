package com.dgis.map.extensions

import com.dgis.map.map_api.VoiceMessage
import ru.dgis.sdk.navigation.Voice

fun Voice.toVoiceMessage(): VoiceMessage {
    return VoiceMessage(
        language = this.language,
        packageMessage = this.toMessage()
    )
}