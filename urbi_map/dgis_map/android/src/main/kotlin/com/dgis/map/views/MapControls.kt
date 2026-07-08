package com.dgis.map.views

import android.annotation.SuppressLint
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.AttributeSet
import android.view.MotionEvent
import android.view.View
import com.dgis.map.R
import com.dgis.map.views.util.FadeAnimator
import ru.dgis.sdk.MutableStatefulChannel
import ru.dgis.sdk.StatefulChannel
import ru.dgis.sdk.map.CameraState
import ru.dgis.sdk.map.Map
import ru.dgis.sdk.map.MapControl

/** Контролы управления картой во время навигации. */
class MapControls @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyle: Int = 0
) : MapControl(context, attrs, defStyle) {

    private val fadeAnimator: FadeAnimator
    private val closeables = mutableListOf<AutoCloseable>()
    private val hideHandler = Handler(Looper.getMainLooper())
    private val hideableControls: List<View>
    private val unhideableControls: List<View>

    private val addEventButton: View

    var isAddRoadEventButtonVisible = false
        set(value) {
            if (field == value) {
                return
            }
            field = value
            updateControlsVisibility()

        }

    private val _visibilityChannel = MutableStatefulChannel(true)
    val visibilityChannel: StatefulChannel<Boolean> = _visibilityChannel

    init {
        inflate(context, R.layout.navigation_map_controls_layout, this)
        addEventButton = findViewById(R.id.dgisNavigatorAddEventButton)
        val root = getChildAt(0)
        fadeAnimator = FadeAnimator(root)
        hideableControls = listOf(
            findViewById(R.id.dgisNavigatorZoomControl),
            addEventButton,
        )
        unhideableControls = listOf(
            findViewById(R.id.dgisNavigatorFollowControl),
            findViewById(R.id.dgisNavigatorCompassControl)
        )
        updateControlsVisibility()
        scheduleHide()
    }

    @SuppressLint("ClickableViewAccessibility")
    override fun onTouchEvent(event: MotionEvent): Boolean {
        if (event.action == MotionEvent.ACTION_DOWN) {
            setVisible(true)
            scheduleHide()
        }
        return false
    }

    override fun onLayout(changed: Boolean, left: Int, top: Int, right: Int, bottom: Int) {
        super.onLayout(changed, left, top, right, bottom)
        post {
            updateControlsVisibility()
        }
    }

    private fun updateControlsVisibility() {
        var availableHeight = height
        unhideableControls.forEach {
            availableHeight -= it.height
        }
        hideableControls.forEach {
            if (it == addEventButton && !isAddRoadEventButtonVisible) {
                it.visibility = GONE
                return@forEach
            }
            if (it.height <= availableHeight) {
                it.visibility = VISIBLE
                availableHeight -= it.height
            }
            else {
                it.visibility = GONE
                availableHeight = -1
            }
        }
    }

    override fun attachToMap(map: Map) {
        val camera = map.camera
        closeables.add(camera)
        // 2GIS SDK 13: BaseCamera.changed replaces the old stateChannel; read the
        // current state off `camera` on every change notification instead.
        closeables.add(camera.changed.connect {
            if (camera.state == CameraState.BUSY) {
                setVisible(true)
                hideHandler.removeCallbacksAndMessages(null)
            }
            else {
                scheduleHide()
            }
        })
    }

    override fun detachFromMap(map: Map) {
        hideHandler.removeCallbacksAndMessages(null)
        closeables.forEach(AutoCloseable::close)
        closeables.clear()
    }

    private fun scheduleHide() {
        hideHandler.removeCallbacksAndMessages(null)
        hideHandler.postDelayed({
            setVisible(false)
        }, 20000)
    }

    private fun setVisible(visible: Boolean) {
        fadeAnimator.visible = visible
        _visibilityChannel.value = visible
    }
}
