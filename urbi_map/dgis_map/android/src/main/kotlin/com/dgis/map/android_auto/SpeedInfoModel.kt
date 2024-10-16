package com.dgis.map.android_auto

data class SpeedInfoModel(
    val currentSpeed: Int = 0,
    val speedLimit: Int? = null,
    val speedLimitExceeded: Boolean = false,
)
