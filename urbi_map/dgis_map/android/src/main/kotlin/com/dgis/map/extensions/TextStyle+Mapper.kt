package com.dgis.map.extensions

import com.dgis.map.map_api.Messages.*
import ru.dgis.sdk.map.*

fun TextPlacementMessage.toTextPlacement() = when (this) {
    TextPlacementMessage.NO_LABEL -> TextPlacement.NO_LABEL
    TextPlacementMessage.BOTTOM_CENTER -> TextPlacement.BOTTOM_CENTER
    TextPlacementMessage.BOTTOM_RIGHT -> TextPlacement.BOTTOM_RIGHT
    TextPlacementMessage.BOTTOM_LEFT -> TextPlacement.BOTTOM_LEFT
    TextPlacementMessage.CIRCLE_BOTTOM_RIGHT -> TextPlacement.CIRCLE_BOTTOM_LEFT
    TextPlacementMessage.RIGHT_BOTTOM -> TextPlacement.RIGHT_BOTTOM
    TextPlacementMessage.RIGHT_CENTER -> TextPlacement.RIGHT_CENTER
    TextPlacementMessage.RIGHT_TOP -> TextPlacement.RIGHT_TOP
    TextPlacementMessage.CIRCLE_TOP_RIGHT -> TextPlacement.CIRCLE_TOP_RIGHT
    TextPlacementMessage.TOP_CENTER -> TextPlacement.TOP_CENTER
    TextPlacementMessage.TOP_RIGHT -> TextPlacement.TOP_RIGHT
    TextPlacementMessage.TOP_LEFT -> TextPlacement.TOP_LEFT
    TextPlacementMessage.CIRCLE_TOP_LEFT -> TextPlacement.CIRCLE_TOP_LEFT
    TextPlacementMessage.LEFT_TOP -> TextPlacement.LEFT_TOP
    TextPlacementMessage.LEFT_CENTER -> TextPlacement.LEFT_CENTER
    TextPlacementMessage.LEFT_BOTTOM -> TextPlacement.LEFT_BOTTOM
    TextPlacementMessage.CIRCLE_BOTTOM_LEFT -> TextPlacement.CIRCLE_BOTTOM_LEFT
    TextPlacementMessage.CENTER_CENTER -> TextPlacement.CENTER_CENTER
}

fun TextPlacement.toMessage() = when (this) {
    TextPlacement.NO_LABEL -> TextPlacementMessage.NO_LABEL
    TextPlacement.BOTTOM_CENTER -> TextPlacementMessage.BOTTOM_CENTER
    TextPlacement.BOTTOM_RIGHT -> TextPlacementMessage.BOTTOM_RIGHT
    TextPlacement.BOTTOM_LEFT -> TextPlacementMessage.BOTTOM_LEFT
    TextPlacement.CIRCLE_BOTTOM_RIGHT -> TextPlacementMessage.CIRCLE_BOTTOM_LEFT
    TextPlacement.RIGHT_BOTTOM -> TextPlacementMessage.RIGHT_BOTTOM
    TextPlacement.RIGHT_CENTER -> TextPlacementMessage.RIGHT_CENTER
    TextPlacement.RIGHT_TOP -> TextPlacementMessage.RIGHT_TOP
    TextPlacement.CIRCLE_TOP_RIGHT -> TextPlacementMessage.CIRCLE_TOP_RIGHT
    TextPlacement.TOP_CENTER -> TextPlacementMessage.TOP_CENTER
    TextPlacement.TOP_RIGHT -> TextPlacementMessage.TOP_RIGHT
    TextPlacement.TOP_LEFT -> TextPlacementMessage.TOP_LEFT
    TextPlacement.CIRCLE_TOP_LEFT -> TextPlacementMessage.CIRCLE_TOP_LEFT
    TextPlacement.LEFT_TOP -> TextPlacementMessage.LEFT_TOP
    TextPlacement.LEFT_CENTER -> TextPlacementMessage.LEFT_CENTER
    TextPlacement.LEFT_BOTTOM -> TextPlacementMessage.LEFT_BOTTOM
    TextPlacement.CIRCLE_BOTTOM_LEFT -> TextPlacementMessage.CIRCLE_BOTTOM_LEFT
    TextPlacement.CENTER_CENTER -> TextPlacementMessage.CENTER_CENTER
}

fun MarkerTextStyleMessage.toTextStyle(): TextStyle {
    return TextStyle(
        fontSize = this.fontSize?.let {
            LogicalPixel(value = it.toFloat())
        } ?: LogicalPixel(8f),
        color = this.color?.let {
            Color(argb = it.toInt())
        } ?: Color(),
        strokeWidth = this.strokeWidth?.let {
            LogicalPixel(it.toFloat())
        } ?: LogicalPixel(0.35f),
        strokeColor = this.strokeColor?.let {
            Color(argb = it.toInt())
        } ?: Color(),
        textPlacement = this.textPlacement?.placement?.toTextPlacement() ?: TextPlacement.BOTTOM_CENTER,
        textOffset = this.textOffset?.let {
            LogicalPixel(it.toFloat())
        } ?: LogicalPixel(0f),
        fontName = this.fontName
    )
}

fun TextStyle.toMessage(): MarkerTextStyleMessage {
    return MarkerTextStyleMessage.Builder()
        .setFontSize(this.fontSize.value.toDouble())
        .setColor(this.color.argb.toLong())
        .setStrokeWidth(this.strokeWidth.value.toDouble())
        .setStrokeColor(this.color.argb.toLong())
        .setTextPlacement(
            MarkerTextPlacementMessage.Builder()
                .setPlacement(this.textPlacement.toMessage())
                .build()
        )
        .setTextOffset(this.textOffset.value.toDouble())
        .setFontName(this.fontName)
        .build()
}