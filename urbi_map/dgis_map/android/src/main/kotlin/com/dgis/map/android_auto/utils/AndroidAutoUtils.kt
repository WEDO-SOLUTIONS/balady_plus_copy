package com.dgis.map.android_auto.utils

import androidx.car.app.model.CarIcon
import androidx.car.app.model.Distance
import com.dgis.map.map_api.MapMarkersType
import com.dgis.map.R
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

    fun getPoiIcon(type: MapMarkersType?): Int? {
        if (type == null) return null

        val resId = when (type) {
            MapMarkersType.RESTAURANTS -> R.drawable.eat_36
            else -> null
        }
        return resId
    }
}
