package com.dgis.map.android_auto

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import androidx.annotation.DrawableRes
import androidx.car.app.Screen
import androidx.car.app.model.CarColor
import androidx.car.app.model.CarIcon
import androidx.core.content.ContextCompat
import androidx.core.graphics.drawable.IconCompat
import com.dgis.map.DgisMapInitializer
import com.dgis.map.R
import ru.dgis.sdk.map.Image
import ru.dgis.sdk.map.imageFromBitmap

fun Screen.getString(resId: Int): String {
    return carContext.getString(resId)
}

fun Screen.getString(resId: Int, vararg formatArgs: Any): String {
    return carContext.getString(resId, *formatArgs)
}

fun Screen.buildCarIcon(@DrawableRes resId: Int): CarIcon {
    return CarIcon.Builder(IconCompat.createWithResource(carContext, resId)).build()
}

fun Screen.buildTintedCarIcon(@DrawableRes resId: Int, colorHex: String): CarIcon {
    val color = android.graphics.Color.parseColor(colorHex)
    return CarIcon.Builder(IconCompat.createWithResource(carContext, resId))
        .setTint(CarColor.createCustom(color, color))
        .build()
}

fun Screen.createIndexedMarker(index: Int): Image {
    val marker = ContextCompat.getDrawable(carContext, R.drawable.marker_large)
    val bitmap = Bitmap.createBitmap(48, 48, Bitmap.Config.ARGB_8888)
    val canvas = Canvas(bitmap)
    marker?.setBounds(0, 0, canvas.width, canvas.height)
    marker?.draw(canvas)
    val paint = Paint().apply {
        color = Color.WHITE
        textSize = 27f
        textAlign = Paint.Align.CENTER
        isAntiAlias = true
    }
    val y = canvas.height / 2 - ((paint.descent() + paint.ascent()) / 2)
    canvas.drawText(index.toString(), canvas.width / 2f, y, paint)
    return imageFromBitmap(DgisMapInitializer.getSdkContext(), bitmap)
}

fun Screen.createIndexedIcon(index: Int): CarIcon {
    val marker = ContextCompat.getDrawable(carContext, R.drawable.marker_small)
    val bitmap = Bitmap.createBitmap(32, 32, Bitmap.Config.ARGB_8888)
    val canvas = Canvas(bitmap)
    marker?.setBounds(0, 0, canvas.width, canvas.height)
    marker?.draw(canvas)
    val paint = Paint().apply {
        color = Color.WHITE
        textSize = 18f
        textAlign = Paint.Align.CENTER
        isAntiAlias = true
    }
    val y = canvas.height / 2 - ((paint.descent() + paint.ascent()) / 2)
    canvas.drawText(index.toString(), canvas.width / 2f, y, paint)
    val icon = IconCompat.createWithBitmap(bitmap)
    return CarIcon.Builder(icon).build()
}