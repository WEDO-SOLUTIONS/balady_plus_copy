package com.dgis.map.extensions

import com.dgis.map.map_api.Messages.VoiceMessage
import ru.dgis.sdk.navigation.Voice

fun Voice.toVoiceMessage(): VoiceMessage {
    return VoiceMessage
        .Builder()
        .setLanguage(language)
        .setPackageMessage(toMessage())
        .build()
}