package com.dgis.map.android_auto.custom_renderer

import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.PorterDuff
import android.graphics.Rect
import android.util.DisplayMetrics
import android.view.Surface
import com.dgis.map.android_auto.SpeedInfoModel

class CustomRenderer {

    private var surface: Surface? = null
    private var rendererData: CustomRendererData? = null
    private val paint = Paint(Paint.ANTI_ALIAS_FLAG)
    private var rightOffset = 0f
    private var bottomOffset = 0f

    fun setSurface(surface: Surface) {
        this.surface = surface
        clearCanvas()
    }

    fun resetSurface() {
        surface = null
    }

    fun render(customRendererData: CustomRendererData) {
        rendererData = customRendererData
        withLockedCanvas {
            clearCanvas(it)
            draw(customRendererData, it)
        }
    }

    private fun update() {
        val data = this.rendererData ?: return
        render(data)
    }

    fun clear() {
        rendererData = null
        clearCanvas()
    }

    private fun clearCanvas(){
        withLockedCanvas(::clearCanvas)
    }

    fun onSurfaceStableAreaChanged(displayMetrics: DisplayMetrics, stableArea: Rect) {
        rightOffset = (displayMetrics.widthPixels - stableArea.right).toFloat()
        bottomOffset = (displayMetrics.heightPixels - stableArea.bottom).toFloat()
        update()
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
        val speedLimit = speedInfo.speedLimit
        if (speedLimit != null && speedLimit != 0) {
            drawSpeedLimit(speedLimit, speedInfo.speedLimitExceeded, canvas)
        }
        drawSpeed(speedInfo.currentSpeed, canvas)
    }

    private fun drawSpeed(speed: Int, canvas: Canvas) {
        paint.apply {
            color = Color.TRANSPARENT
            style = Paint.Style.FILL
            setShadowLayer(2f, 0f, 0f, Color.parseColor("#12000000"))
        }
        val centerX = canvas.width - rightOffset - 40f
        val centerY = canvas.height - bottomOffset - 51f
        canvas.drawCircle(centerX, centerY, 36f, paint)
        paint.apply {
            color = Color.WHITE
            style = Paint.Style.FILL
            clearShadowLayer()
        }
        canvas.drawCircle(centerX, centerY, 32f, paint)
        paint.apply {
            reset()
            color = Color.BLACK
            style = Paint.Style.FILL
            textSize = 28f
            textAlign = Paint.Align.CENTER
        }
        canvas.drawText("$speed", centerX, centerY + paint.textSize / 3, paint)
    }

    private fun drawSpeedLimit(speedLimit: Int, exceeded: Boolean, canvas: Canvas) {
        val centerX = canvas.width - rightOffset - 93f
        val centerY = canvas.height - bottomOffset - 45f
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
        canvas.drawText(speedLimit.toString(), centerX, centerY + paint.textSize / 3, paint)
    }

    private fun clearCanvas(canvas: Canvas) {
        canvas.drawColor(Color.TRANSPARENT, PorterDuff.Mode.CLEAR)
    }
}

data class CustomRendererData(
    val speedInfo: SpeedInfoModel,
)
