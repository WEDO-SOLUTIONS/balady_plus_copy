package com.dgis.map.extensions

import com.dgis.map.map_api.*
import ru.dgis.sdk.positioning.DesiredAccuracy

fun DesiredAccuracyMessage.toSdkAccuracy() = when (this) {
    DesiredAccuracyMessage.LOW -> DesiredAccuracy.LOW
    DesiredAccuracyMessage.MEDIUM -> DesiredAccuracy.MEDIUM
    DesiredAccuracyMessage.HIGH -> DesiredAccuracy.HIGH
}