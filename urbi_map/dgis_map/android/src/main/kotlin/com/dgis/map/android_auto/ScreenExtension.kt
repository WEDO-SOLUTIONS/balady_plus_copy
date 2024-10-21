package com.dgis.map.android_auto

import androidx.car.app.Screen

fun Screen.getString(resId: Int): String {
    return carContext.getString(resId)
}

fun Screen.getString(resId: Int, vararg formatArgs: Any): String {
    return carContext.getString(resId, *formatArgs)
}
