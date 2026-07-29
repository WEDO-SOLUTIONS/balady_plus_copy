package com.dgis.map.android_auto.custom_renderer

import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.PorterDuff
import android.view.Surface
import com.dgis.map.android_auto.SpeedInfoModel
import com.dgis.map.android_auto.StableAreaPaddingProvider
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class CustomRenderer(private val paddingProvider: StableAreaPaddingProvider) : AutoCloseable {

    private var surface: Surface? = null
    private var rendererData: CustomRendererData? = null
    private val paint = Paint(Paint.ANTI_ALIAS_FLAG)
    private var paddingFlowJob: Job? = null

    /**
     * Layout direction of the current locale. When true (e.g. Arabic) the speed and speed-limit
     * widgets are anchored to the start (left) edge instead of the end (right) edge so they mirror
     * correctly in RTL. Updated by the session whenever the locale changes.
     */
    var isRtl: Boolean = false
        set(value) {
            if (field == value) return
            field = value
            update()
        }

    init {
        paddingFlowJob = CoroutineScope(Dispatchers.Default).launch {
            paddingProvider.paddingFlow.collect {
                withContext(Dispatchers.Main) { update() }
            }
        }
    }

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

    private fun clearCanvas() {
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
        val centerX = if (isRtl) {
            paddingProvider.paddingFlow.value.left + 40f
        } else {
            canvas.width - paddingProvider.paddingFlow.value.right - 40f
        }
        val centerY = canvas.height - paddingProvider.paddingFlow.value.bottom - 51f
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
        val centerX = if (isRtl) {
            paddingProvider.paddingFlow.value.left + 93f
        } else {
            canvas.width - paddingProvider.paddingFlow.value.right - 93f
        }
        val centerY = canvas.height - paddingProvider.paddingFlow.value.bottom - 45f
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

    override fun close() {
        paddingFlowJob?.cancel()
    }
}

data class CustomRendererData(
    val speedInfo: SpeedInfoModel,
)
