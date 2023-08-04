package com.dgis.map.views.util

import android.view.View
import android.view.ViewPropertyAnimator
import ru.dgis.sdk.Duration
import ru.dgis.sdk.TimePoint
import ru.dgis.sdk.max
import ru.dgis.sdk.milliseconds

/** Изменяет видимость [view] с помощью анимации прозрачности. */
internal class FadeAnimator(
    private val view: View,
    private val animationDuration: Duration = 300.milliseconds,
    private val showDelay: Duration = Duration.ZERO,
    private val hideDelay: Duration = 100.milliseconds,
    private val minVisibleDuration: Duration = Duration.ZERO
) {
    private enum class State {
        VISIBLE,
        INVISIBLE,
        SHOW_ANIMATION,
        HIDE_ANIMATION
    }

    private var state = if (view.visibility == View.VISIBLE) State.VISIBLE else State.INVISIBLE
        set(value) {
            if (field == value) {
                return
            }
            stateChangeTimePoint = TimePoint.now()
            field = value
        }
    private var stateChangeTimePoint: TimePoint = TimePoint.now()

    private val currentStateDuration: Duration
        get() = max(Duration.ZERO, TimePoint.now() - stateChangeTimePoint)

    private var animator: ViewPropertyAnimator? = null

    var visible: Boolean = state == State.VISIBLE
        set(value) {
            if (field == value) {
                return
            }
            field = value
            updateAnimation()
        }

    private fun updateAnimation() {
        if (state == State.SHOW_ANIMATION && currentStateDuration > showDelay) {
            return
        }
        if (state == State.HIDE_ANIMATION && currentStateDuration > hideDelay) {
            return
        }

        animator?.cancel()
        animator = null

        val inVisibleState = state == State.VISIBLE || state == State.SHOW_ANIMATION
        if (inVisibleState == visible) {
            return
        }

        if (visible) {
            if (state == State.HIDE_ANIMATION) {
                state = State.VISIBLE
                return
            }
            view.alpha = 0f
            view.visibility = View.VISIBLE
            state = State.SHOW_ANIMATION
            animator = view.animate().apply {
                duration = animationDuration.inMilliseconds
                alpha(1f)
                startDelay = showDelay.inMilliseconds
                withEndAction {
                    animator = null
                    state = State.VISIBLE
                    updateAnimation()
                }
                start()
            }
        }
        else {
            if (state == State.SHOW_ANIMATION) {
                state = State.INVISIBLE
                return
            }
            val hideDelay = max(minVisibleDuration - currentStateDuration, hideDelay)
            state = State.HIDE_ANIMATION
            animator = view.animate().apply {
                duration = animationDuration.inMilliseconds
                alpha(0f)
                startDelay = hideDelay.inMilliseconds
                withEndAction {
                    animator = null
                    state = State.INVISIBLE
                    view.visibility = View.INVISIBLE
                    updateAnimation()
                }
                start()
            }
        }
    }
}
