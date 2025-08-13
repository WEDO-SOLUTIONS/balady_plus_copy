package com.dgis.map.android_auto.utils

import androidx.car.app.model.Distance
import kotlin.math.round

object AndroidAutoUtils {

    fun createDistance(distanceInMeter: Double): Distance {
        val unit: Int
        val distance: Double
        if (distanceInMeter >= 1000) {
            distance = distanceInMeter / 1000.0
            unit = Distance.UNIT_KILOMETERS_P1
        } else {
            distance = round(distanceInMeter / 10) * 10
            unit = Distance.UNIT_METERS
        }
        return Distance.create(distance, unit)
    }
}
