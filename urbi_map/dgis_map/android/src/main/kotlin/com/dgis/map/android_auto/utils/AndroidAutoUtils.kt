package com.dgis.map.android_auto.utils

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
            MapMarkersType.MARKETS -> R.drawable.ic_markets
            MapMarkersType.BEACH -> R.drawable.ic_beach
            MapMarkersType.GYM -> R.drawable.ic_gym
            MapMarkersType.GAS_STATION -> R.drawable.ic_gas_station
            MapMarkersType.EVENTS -> R.drawable.ic_events
            MapMarkersType.CAR_SERVICES -> R.drawable.ic_car_services
            MapMarkersType.HOSPITALS -> R.drawable.ic_hospitals
            MapMarkersType.HOTELS -> R.drawable.ic_hotels
            MapMarkersType.PHARMACIES -> R.drawable.ic_pharmacies
            MapMarkersType.MOSQUES -> R.drawable.ic_mosques
            MapMarkersType.PARKS -> R.drawable.ic_parks
            MapMarkersType.QIBLA -> R.drawable.ic_qibla
            MapMarkersType.RESTAURANTS -> R.drawable.ic_restaurants
            MapMarkersType.WC -> R.drawable.ic_wc
            MapMarkersType.DENTAL_CENTERS -> R.drawable.ic_dental_centers
            MapMarkersType.SCHOOLS -> R.drawable.ic_schools
            MapMarkersType.SHOPPING -> R.drawable.ic_shopping
            MapMarkersType.BEAUTY -> R.drawable.ic_beauty
            MapMarkersType.MEDICAL_HELP -> R.drawable.ic_hospitals
            MapMarkersType.BARBERSHOPS -> R.drawable.ic_barbershops
            MapMarkersType.POLICE_STATION -> R.drawable.ic_police_station
            MapMarkersType.RECREATION_CENTERS -> R.drawable.ic_recreation_centers
            else -> null
        }
        return resId
    }
}
