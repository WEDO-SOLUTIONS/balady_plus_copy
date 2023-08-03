package com.dgis.map.views

import android.content.Context
import android.content.res.Configuration
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.constraintlayout.widget.ConstraintLayout
import com.dgis.map.databinding.NavigationControlsLayoutBinding
import com.dgis.map.views.util.DirectUiThreadExecutor
import com.dgis.map.views.util.FadeAnimator
import com.google.android.material.bottomsheet.BottomSheetBehavior
import ru.dgis.sdk.Duration
import ru.dgis.sdk.R
import ru.dgis.sdk.databinding.DgisDefaultNavigationControlsBinding
import ru.dgis.sdk.milliseconds
import ru.dgis.sdk.navigation.Model
import ru.dgis.sdk.navigation.NavigationControl
import ru.dgis.sdk.navigation.NavigationManager
import ru.dgis.sdk.navigation.RemainingRouteInfoControl
import ru.dgis.sdk.navigation.RouteInfo
import ru.dgis.sdk.navigation.State
import ru.dgis.sdk.navigation.TrafficLineControl
import ru.dgis.sdk.routing.Route
import ru.dgis.sdk.routing.TransportType
import kotlin.math.max

/**
 * UI контролы навигатора, предлагаемые к использованию по умолчанию: полосность, ограничение скорости,
 * обозначение следующего манёвра и т.д. Пользователи SDK также могут создать свои собственные UI контролы
 * и использовать UI модель навигатора для получения оповещений о событиях при ведении по маршруту.
 */
class NavigationControls @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyle: Int = 0
) : NavigationControl(context, attrs, defStyle) {

    private var orientation: Int? = null
    private val isFreeRoam: Boolean
        get() = if (navigatorState == State.DISABLED) isFreeRoamDefault else !hasRouteBuildOptions
    private var hasRouteBuildOptions = false

    private var route: Route? = null
    private var isCarOrPublicRoute: Boolean = true
    private var isIndoor: Boolean = false

    private var lanesControlVisible: Boolean = false
    private var cameraControlVisible: Boolean = false
    private var additionalManeuverControlVisible: Boolean = false
    private var isDashboardActive: Boolean = false

    private var navigatorState: State = State.DISABLED
    private var hasBetterRoutePrompt: Boolean = false
    private var isFinishRouteControlExpanded: Boolean = false

    private val localCloseables = mutableListOf<AutoCloseable>()

    private lateinit var binding: NavigationControlsLayoutBinding

    private var trafficLineControlFadeAnimator: FadeAnimator? = null
    private var routeOverviewControlFadeAnimator: FadeAnimator? = null
    private var dashboardVisibilityAnimator: FadeAnimator? = null

    var onFinishClicked: (() -> Unit)? = null
        set(value) {
            field = value
            if (::binding.isInitialized) {
                setupOnFinishClicked()
                updateFreeRoamControlsVisibility()
            }
        }

    /**
     *  Состояние контрола навигатора по умолчанию.
     *  Нужно для установки корректного начального состояния контролов.
     *  Данное свойство допускает возможность задания только до момента отображения контрола.
     */
    var isFreeRoamDefault = false
        set(value) {
            check(!isAttachedToWindow) {
                "defaultMode property cannot be set after the view is attached to window!"
            }
            field = value
        }

    private fun inflateLayout(orientation: Int) {
        if (this.orientation == orientation) {
            return
        }
        if (this.orientation != null) {
            removeAllViews()
            localCloseables.forEach(AutoCloseable::close)
            localCloseables.clear()
            additionalManeuverControlVisible = false
            lanesControlVisible = false
            cameraControlVisible = false
        }

        trafficLineControlFadeAnimator = null
        routeOverviewControlFadeAnimator = null
        dashboardVisibilityAnimator = null
        val prevIsRouteOverview = if (::binding.isInitialized) binding.dgisNavigatorShowRouteControl.isRouteOverview else false

        binding = NavigationControlsLayoutBinding.inflate(context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater, this, true)

        this.orientation = orientation

        if (prevIsRouteOverview) {
            binding.dgisNavigatorShowRouteControl.setRouteOverview(prevIsRouteOverview)
        }

        initDashboardControl()
        initAddRoadEventControls()
        initFinishRouteControl()
        initBetterRoutePromptControl()
        updateSpeedControlVisibility()
        updateFreeRoamControlsVisibility()
        updateTrafficLineControlVisibility()
        updateMapPadding()
        updateRouteOverviewVisibility()
        updateParkingButtonVisibility()
        updateIndoorControlVisibity()

        binding.dgisNavigatorShowDashboardButton.setOnClickListener {
            binding.dgisNavigatorDashboardControl.toggleExpandedState()
        }

        binding.mapnessNavigatorMapControls.findViewById<View>(R.id.dgisNavigatorAddEventButton)
            .setOnClickListener {
                binding.dgisNavigatorAddRoadEventControls.show()
            }
        localCloseables.add(binding.mapnessNavigatorMapControls.visibilityChannel.connect {
            updateTrafficLineControlVisibility()
        })
        trafficLineControlFadeAnimator = FadeAnimator(
            binding.dgisNavigatorTrafficLineControl,
            animationDuration = 200.milliseconds,
            hideDelay = Duration.ZERO
        )
        binding.dgisNavigatorTrafficLineControl.apply {
            pointObjectsPosition = when (orientation) {
                Configuration.ORIENTATION_LANDSCAPE -> TrafficLineControl.PointObjectsPosition.LEFT
                else -> TrafficLineControl.PointObjectsPosition.RIGHT
            }
            setOnClickListener {
                showRoute()
            }
        }

        initRouteOverviewControl()
        setupOnFinishClicked()
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        inflateLayout(newConfig.orientation)
    }

    override fun attachToManager(manager: NavigationManager) {
        super.attachToManager(manager)
        closeables.add(manager.indoorDetector.indoorChannel.connect{
            if (isIndoor != it) {
                isIndoor = it
                updateTrafficLineControlVisibility()
                updateIndoorControlVisibity()
            }
        })
    }
    override fun attachToModel(model: Model) {
        closeables.add(model.stateChannel.connect(::onStateChanged))
        closeables.add(model.routeChannel.connect(::onRoute))
    }

    override fun onAttachedToWindow() {
        inflateLayout(resources.configuration.orientation)
        super.onAttachedToWindow()
    }

    private fun onStateChanged(state: State) {
        navigatorState = state
        if (state != State.NAVIGATION) {
            binding.dgisNavigatorShowRouteControl.setRouteOverview(false)
        }

        updateDashboardControlVisibility()
        updateBetterRouteInfoControlVisibility()
        updateFinishRouteControlVisibility(true)
        updateFreeRoamControlsVisibility()
        updateTrafficLineControlVisibility()
        updateDashboardPeekHeight()
    }

    private fun initDashboardControl() {
        if (navigatorState == State.FINISHED) {
            binding.dgisNavigatorDashboardControl.visibility = GONE
        }

        val fade = binding.dgisNavigatorDashboardFade.apply {
            setOnClickListener {
                binding.dgisNavigatorDashboardControl.collapse()
            }
        }
        BottomSheetBehavior.from(binding.dgisNavigatorDashboardControl).addBottomSheetCallback(object :
            BottomSheetBehavior.BottomSheetCallback() {
            override fun onSlide(bottomSheet: View, slideOffset: Float) {
                fade.alpha = slideOffset
                fade.visibility = if (slideOffset != 0.0f) View.VISIBLE else View.GONE
            }

            override fun onStateChanged(bottomSheet: View, newState: Int) {
                isDashboardActive = newState != BottomSheetBehavior.STATE_COLLAPSED
                updateBetterRouteInfoControlVisibility()
            }
        })
        dashboardVisibilityAnimator = FadeAnimator(
            binding.dgisNavigatorDashboardControl,
            animationDuration = 200.milliseconds,
            hideDelay = Duration.ZERO
        )
        localCloseables.add(binding.dgisNavigatorDashboardControl.remainingRouteInfoControl.heightChannel.connect(
            DirectUiThreadExecutor
        ) {
            updateDashboardPeekHeight()
            updateMapPadding()
        })
    }

    private fun initAddRoadEventControls() {
        binding.dgisNavigatorDashboardControl.remainingRouteInfoControl.onAddRoadEventButtonClicked = {
            binding.dgisNavigatorDashboardControl.collapse()
            binding.dgisNavigatorAddRoadEventControls.show()
        }
        localCloseables.add(binding.dgisNavigatorAddRoadEventControls.cardHeightChannel.connect {
            updateMapPadding()
        })
    }

    private fun updateMapPadding() {
        val minHeight = dp(context, 68)
        val dashboardHeaderHeight = binding.dgisNavigatorDashboardControl.run {
            if (visibility == VISIBLE) headerHeight - dp(context, RemainingRouteInfoControl.MARGIN) else 0
        }
        val roadEventCardHeight = binding.dgisNavigatorAddRoadEventControls.cardHeightChannel.value
        val finishCardHeight = binding.dgisNavigatorFinishRouteControl.run {
            if (visibility == VISIBLE) heightChannel.value else 0
        }
        binding.dgisNavigatorMapPaddingControl.apply {
            setMargins(bottom = max(
                max(minHeight, dashboardHeaderHeight),
                max(roadEventCardHeight, finishCardHeight)))
        }
    }

    private fun updateSpeedControlVisibility() {
        binding.speedInfoControl.apply {
            visibility = if (isCarOrPublicRoute) VISIBLE else INVISIBLE
        }
    }

    private fun updateFreeRoamControlsVisibility() {
        binding.dgisNavigatorDashboardControl.isFreeRoam = isFreeRoam
        binding.mapnessNavigatorMapControls.isAddRoadEventButtonVisible = isFreeRoam
        binding.dgisNavigatorShowDashboardButton.visibility = if (isFreeRoam && onFinishClicked != null) View.VISIBLE else View.GONE
    }

    private fun updateBetterRouteInfoControlVisibility() {
        binding.betterRoutePromptControl.apply {
            visibility = if (hasBetterRoutePrompt) VISIBLE else GONE
        }
    }

    private fun onRoute(routeInfo: RouteInfo) {
        route = routeInfo.route
        val transportTypes = routeInfo.route.transportTypes
        isCarOrPublicRoute = transportTypes.entries.any {
            it.value == TransportType.CAR || it.value == TransportType.PUBLIC
        }
        hasRouteBuildOptions = routeInfo.routeBuildOptions != null

        updateSpeedControlVisibility()
        updateTrafficLineControlVisibility()
        updateParkingButtonVisibility()
    }

    private fun initFinishRouteControl() {
        binding.dgisNavigatorFinishRouteControl.apply {
            localCloseables.add(this.heightChannel.connect {
                updateMapPadding()
            })
        }

        findViewById<ConstraintLayout>(R.id.dgisNavigatorFinishRouteLayout).apply {
            BottomSheetBehavior.from(this)
                .addBottomSheetCallback(object : BottomSheetBehavior.BottomSheetCallback() {
                    override fun onSlide(bottomSheet: View, slideOffset: Float) {}
                    override fun onStateChanged(bottomSheet: View, newState: Int) {
                        isFinishRouteControlExpanded =
                            newState == BottomSheetBehavior.STATE_EXPANDED
                    }
                })
        }
    }

    private fun initBetterRoutePromptControl() {
        binding.betterRoutePromptControl.let { control ->
            localCloseables.add(control.visibilityChannel.connect {
                hasBetterRoutePrompt = it

                updateDashboardControlVisibility()
                updateBetterRouteInfoControlVisibility()
                updateFinishRouteControlVisibility(false)
            })
        }
    }

    private fun updateDashboardControlVisibility() {
        val visible = navigatorState != State.FINISHED && !hasBetterRoutePrompt
                && !binding.dgisNavigatorShowRouteControl.isRouteOverview
        val animator = dashboardVisibilityAnimator
        if (animator != null) {
            animator.visible = visible
        }
        else {
            binding.dgisNavigatorDashboardControl.visibility = if (visible) VISIBLE else GONE
        }
    }

    private fun updateFinishRouteControlVisibility(shouldExpandByForce: Boolean) {
        binding.dgisNavigatorFinishRouteControl.apply {
            if (navigatorState == State.FINISHED) {
                visibility = VISIBLE
                if (shouldExpandByForce || isFinishRouteControlExpanded) post {
                    expand()
                }
            } else visibility = GONE
        }
        updateMapPadding()
    }

    private fun updateTrafficLineControlVisibility() {
        val isHiddenByMapControls =
            resources.configuration.orientation == Configuration.ORIENTATION_LANDSCAPE && binding.mapnessNavigatorMapControls.visibilityChannel.value
        val visible = !isFreeRoam && !isIndoor && !isHiddenByMapControls && navigatorState != State.FINISHED
                && !binding.dgisNavigatorShowRouteControl.isRouteOverview
        val animator = trafficLineControlFadeAnimator
        if (animator != null) {
            animator.visible = visible
        }
        else {
            binding.dgisNavigatorTrafficLineControl.visibility = if (visible) VISIBLE else GONE
        }
    }

    private fun setupOnFinishClicked() {
        binding.dgisNavigatorDashboardControl.onFinishClicked = onFinishClicked
        binding.dgisNavigatorFinishRouteControl.onFinishClicked = onFinishClicked
    }

    private fun initRouteOverviewControl() {
        routeOverviewControlFadeAnimator = FadeAnimator(
            binding.dgisNavigatorRouteOverviewControl,
            animationDuration = 200.milliseconds,
            hideDelay = Duration.ZERO
        )
        binding.dgisNavigatorRouteOverviewControl.setOnClickListener {
            binding.dgisNavigatorShowRouteControl.cancelRouteOverview()
        }
        localCloseables.add(binding.dgisNavigatorShowRouteControl.isRouteOverviewChannel.connect {
            updateRouteOverviewVisibility()
            updateTrafficLineControlVisibility()
            updateDashboardControlVisibility()
        })
        binding.dgisNavigatorDashboardControl.onShowRouteClicked = this::showRoute
    }

    private fun updateRouteOverviewVisibility() {
        val visible = binding.dgisNavigatorShowRouteControl.isRouteOverview
        val animator = routeOverviewControlFadeAnimator
        if (animator != null) {
            animator.visible = visible
        }
        else {
            binding.dgisNavigatorRouteOverviewControl.visibility = if (visible) VISIBLE else GONE
        }
    }

    private fun updateDashboardPeekHeight() {
        BottomSheetBehavior.from(binding.dgisNavigatorDashboardControl).peekHeight = if (isFreeRoam) 0
        else binding.dgisNavigatorDashboardControl.headerHeight
    }

    private fun updateParkingButtonVisibility() {
        binding.dgisNavigatorFinishRouteControl.isParkingButtonVisible = isCarOrPublicRoute
    }

    private fun updateIndoorControlVisibity() {
        binding.dgisNavigatorIndoorControl.visibility = if (isIndoor) VISIBLE else INVISIBLE
    }

    private fun showRoute() {
        val route = route ?: return
        binding.dgisNavigatorShowRouteControl.showRoute(route)
    }
}

internal fun dp(context: Context, value: Int): Int {
    return (value * context.resources.displayMetrics.density).toInt()
}

internal fun View.setMargins(left: Int? = null, top: Int? = null, right: Int? = null, bottom: Int? = null) {
    (layoutParams as ViewGroup.MarginLayoutParams).apply {
        left?.let { leftMargin = left }
        top?.let { topMargin = top }
        right?.let { rightMargin = right }
        bottom?.let { bottomMargin = bottom }
    }
    requestLayout()
}
