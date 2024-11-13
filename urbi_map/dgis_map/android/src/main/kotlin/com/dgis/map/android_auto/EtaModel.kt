package com.dgis.map.android_auto

import androidx.car.app.model.DateTimeWithZone

class EtaModel(
    val duration: Long,
    val distance: Double,
    val arrivalTime: DateTimeWithZone,
    val destination: String?
)
