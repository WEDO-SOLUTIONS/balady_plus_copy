package com.dgis.map.android_auto

import androidx.annotation.DrawableRes
import androidx.car.app.Screen
import androidx.car.app.model.CarIcon
import androidx.core.graphics.drawable.IconCompat

fun Screen.getString(resId: Int): String {
    return carContext.getString(resId)
}

fun Screen.getString(resId: Int, vararg formatArgs: Any): String {
    return carContext.getString(resId, *formatArgs)
}
fun Screen.buildCarIcon(@DrawableRes resId: Int): CarIcon {
    return CarIcon.Builder(IconCompat.createWithResource(carContext, resId)).build()
}
