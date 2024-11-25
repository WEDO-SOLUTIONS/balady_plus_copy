package com.dgis.map.android_auto.custom_renderer

import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.PorterDuff
import android.view.Surface
import com.dgis.map.android_auto.SpeedInfoModel

class CustomRenderer {

    // TODO(Sergei): using temporary additional offset until SDK implements visible area rect
    private val controlsOffset = 68f
    private var surface: Surface? = null
    private val paint = Paint(Paint.ANTI_ALIAS_FLAG)

    fun setSurface(surface: Surface) {
        this.surface = surface
        clear()
    }

    fun resetSurface() {
        surface = null
    }

    fun render(customRendererData: CustomRendererData) {
        withLockedCanvas {
            clearCanvas(it)
            draw(customRendererData, it)
        }
    }

    fun clear() {
        withLockedCanvas(::clearCanvas)
    }

    private fun withLockedCanvas(block: (canvas: Canvas) -> Unit) {
        val surface = this.surface ?: return
        var canvas: Canvas? = null
        try {
            canvas = surface.lockHardwareCanvas()
            block(canvas)
        } catch (e: Exception) {
            e.printStackTrace()
        } finally {
            if (canvas != null) {
                surface.unlockCanvasAndPost(canvas)
            }
        }
    }

    private fun draw(customRendererData: CustomRendererData, canvas: Canvas) {
        val speedInfo = customRendererData.speedInfo
        drawSpeed(speedInfo.currentSpeed, canvas)
    }

    private fun drawSpeed(speed: Int, canvas: Canvas) {
        paint.apply {
            color = Color.WHITE
            style = Paint.Style.FILL
        }
        val centerX = canvas.width - 45f
        val centerY = 30f + controlsOffset
        canvas.drawCircle(centerX, centerY, 20f, paint)
        paint.apply {
            color = Color.BLACK
            style = Paint.Style.FILL
            textSize = 18f
            textAlign = Paint.Align.CENTER
        }
        canvas.drawText("$speed", centerX, centerY + paint.textSize / 3, paint)
    }

    private fun drawSpeedLimit(speedLimit: Int?, exceeded: Boolean, canvas: Canvas) {
        val centerX = canvas.width - 39f
        val centerY = 39f + controlsOffset
        if (exceeded) {
            paint.apply {
                color = Color.RED
                style = Paint.Style.FILL
            }
            canvas.drawCircle(centerX, centerY, 24f, paint)
        } else {
            paint.apply {
                color = Color.RED
                style = Paint.Style.STROKE
                strokeWidth = 4f
            }
            canvas.drawCircle(centerX, centerY, 24f, paint)
            paint.apply {
                color = Color.WHITE
                style = Paint.Style.FILL
            }
            canvas.drawCircle(centerX, centerY, 22.5f, paint)
        }

        paint.apply {
            color = if (exceeded) Color.WHITE else Color.BLACK
            style = Paint.Style.FILL
            textSize = 24f
            textAlign = Paint.Align.CENTER
        }
        val value = speedLimit?.toString() ?: "--"
        canvas.drawText(value, centerX, centerY + paint.textSize / 3, paint)
    }

    private fun clearCanvas(canvas: Canvas) {
        canvas.drawColor(Color.TRANSPARENT, PorterDuff.Mode.CLEAR)
    }
}

data class CustomRendererData(
    val speedInfo: SpeedInfoModel,
)
