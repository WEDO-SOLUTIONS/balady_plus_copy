package com.dgis.map.extensions

import com.dgis.map.map_api.Messages
import ru.dgis.sdk.positioning.DesiredAccuracy

fun Messages.DesiredAccuracyMessage.toSdkAccuracy() = when (this) {
    Messages.DesiredAccuracyMessage.LOW -> DesiredAccuracy.LOW
    Messages.DesiredAccuracyMessage.MEDIUM -> DesiredAccuracy.MEDIUM
    Messages.DesiredAccuracyMessage.HIGH -> DesiredAccuracy.HIGH
}