package com.dgis.map.android_auto.custom_renderer

import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.PorterDuff
import android.graphics.RectF
import android.text.Layout
import android.text.StaticLayout
import android.text.TextDirectionHeuristics
import android.text.TextPaint
import android.view.Surface
import com.dgis.map.android_auto.SpeedInfoModel
import com.dgis.map.android_auto.StableAreaPaddingProvider
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlin.math.ceil

class CustomRenderer(private val paddingProvider: StableAreaPaddingProvider) : AutoCloseable {

    private var surface: Surface? = null
    private var rendererData: CustomRendererData? = null
    private val paint = Paint(Paint.ANTI_ALIAS_FLAG)
    private val attributionPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply { textSize = 16f }
    private var paddingFlowJob: Job? = null

    var label: String = ""
        set(value) {
            if (field == value) return
            field = value
            update()
        }

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

    var isDarkMode: Boolean = false
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
        redraw()
    }

    fun resetSurface() {
        surface = null
    }

    fun render(customRendererData: CustomRendererData) {
        rendererData = customRendererData
        redraw()
    }

    private fun update() {
        redraw()
    }

    fun clear() {
        rendererData = null
        redraw()
    }

    private fun redraw() {
        withLockedCanvas { canvas ->
            clearCanvas(canvas)
            drawAttribution(canvas)
            rendererData?.let { draw(it, canvas) }
        }
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

        val signalLostMessage = customRendererData.signalLostMessage
        if (!signalLostMessage.isNullOrEmpty()) {
            drawSignalLostBanner(signalLostMessage, canvas)
        }
    }

    private fun drawSignalLostBanner(message: String, canvas: Canvas) {
        val padding = paddingProvider.paddingFlow.value
        val cardHorizontalPadding = 32f
        val cardVerticalPadding = 24f
        val edgeOffset = 12f
        val cardLeft = edgeOffset
        val cardTop = edgeOffset
        val maxCardWidth = (canvas.width - padding.right - edgeOffset).coerceAtLeast(0f)
        val maxTextWidth = (maxCardWidth - cardHorizontalPadding * 2).coerceAtLeast(0f).toInt()
        if (maxTextWidth <= 0) return

        val textPaint = TextPaint(Paint.ANTI_ALIAS_FLAG).apply {
            color = Color.parseColor("#F8F9FA")
            textSize = 28f
        }
        fun buildLayout(width: Int) = StaticLayout.Builder
            .obtain(message, 0, message.length, textPaint, width)
            .setAlignment(Layout.Alignment.ALIGN_NORMAL)
            .setTextDirection(TextDirectionHeuristics.FIRSTSTRONG_RTL)
            .build()

        val measuringLayout = buildLayout(maxTextWidth)
        val contentWidth = (0 until measuringLayout.lineCount)
            .maxOf { ceil(measuringLayout.getLineWidth(it)).toInt() }
            .coerceIn(1, maxTextWidth)
        // Rebuild at the actual content width so ALIGN_NORMAL (which depends on paragraph
        // direction) hugs the card edge correctly for RTL text too, instead of leaving slack
        // from the wider measuring width.
        val textLayout = buildLayout(contentWidth)

        val cardWidth = contentWidth + cardHorizontalPadding * 2
        val cardHeight = textLayout.height + cardVerticalPadding * 2
        val cornerRadius = 16f

        paint.reset()
        paint.apply {
            color = Color.parseColor("#C5221F")
            style = Paint.Style.FILL
        }
        canvas.drawRoundRect(
            RectF(cardLeft, cardTop, cardLeft + cardWidth, cardTop + cardHeight),
            cornerRadius,
            cornerRadius,
            paint
        )

        canvas.save()
        canvas.translate(cardLeft + cardHorizontalPadding, cardTop + cardVerticalPadding)
        textLayout.draw(canvas)
        canvas.restore()
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
                strokeWidth = 1f
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

    private fun drawAttribution(canvas: Canvas) {
        val text = label
        if (text.isEmpty()) return

        val padding = paddingProvider.paddingFlow.value
        val margin = 16f
        val y = canvas.height - padding.bottom - margin
        val x: Float
        if (isRtl) {
            x = canvas.width - padding.right - margin
            attributionPaint.textAlign = Paint.Align.RIGHT
        } else {
            x = padding.left + margin
            attributionPaint.textAlign = Paint.Align.LEFT
        }

        attributionPaint.apply {
            style = Paint.Style.STROKE
            color = if (isDarkMode) Color.BLACK else Color.WHITE
            strokeWidth = 1f
            strokeJoin = Paint.Join.ROUND
            strokeCap = Paint.Cap.ROUND
        }
        canvas.drawText(text, x, y, attributionPaint)

        attributionPaint.apply {
            style = Paint.Style.FILL
            color = if (isDarkMode) Color.WHITE else Color.BLACK
        }
        canvas.drawText(text, x, y, attributionPaint)
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
    val signalLostMessage: String? = null,
)
