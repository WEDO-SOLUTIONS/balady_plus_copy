package com.dgis.map.android_auto

import android.content.Intent
import android.net.Uri
import android.text.SpannableString
import android.text.Spanned
import android.util.Log
import androidx.annotation.OptIn
import androidx.car.app.CarContext
import androidx.car.app.ScreenManager
import androidx.car.app.annotations.ExperimentalCarApi
import androidx.car.app.constraints.ConstraintManager
import androidx.car.app.model.Action
import androidx.car.app.model.CarColor
import androidx.car.app.model.DistanceSpan
import androidx.car.app.model.DurationSpan
import androidx.car.app.model.Header
import androidx.car.app.model.ItemList
import androidx.car.app.model.Pane
import androidx.car.app.model.Row
import androidx.car.app.model.Template
import androidx.car.app.navigation.model.MapController
import androidx.car.app.navigation.model.MapTemplate
import androidx.car.app.navigation.model.RoutePreviewNavigationTemplate
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.dgis.map.R
import com.dgis.map.android_auto.utils.AndroidAutoUtils
import ru.dgis.sdk.directory.DirectoryObject
import ru.dgis.sdk.map.Padding
import ru.dgis.sdk.routing.RouteEditorRoutesInfo
import ru.dgis.sdk.routing.meters
import java.util.concurrent.TimeUnit
import kotlin.math.min


class RoutePreviewScreen(
    carContext: CarContext,
    private val mapController: CarMapController,
    private val directoryObject: DirectoryObject,
) : CarMapScreen(carContext, mapController) {

    private var state: RoutePreviewScreenState = RoutePreviewScreenState.Loading

    private val itemsLimit = carContext.getCarService(ConstraintManager::class.java)
        .getContentLimit(ConstraintManager.CONTENT_LIMIT_TYPE_ROUTE_LIST)

    private val headerBack by lazy {
        Header.Builder().setStartHeaderAction(Action.BACK)
            .addEndHeaderAction(closeAction)
            .setTitle(getString(R.string.back)).build()
    }

    private val headerRouteOverview by lazy {
        Header.Builder().setStartHeaderAction(Action.BACK)
            .setTitle(getString(R.string.route_overview_title)).build()
    }

    private val closeAction by lazy {
        Action.Builder().setIcon(buildCarIcon(R.drawable.close_36))
            .setOnClickListener { carContext.getCarService(ScreenManager::class.java).popToRoot() }
            .build()
    }

    private val navigationAction by lazy {
        Action.Builder()
            .setTitle(getString(R.string.go_button))
            .setBackgroundColor(CarColor.PRIMARY)
            .setOnClickListener(::onNavigate)
            .build()
    }

    init {
        mapController.setRouteInfoListener(object : RouteInfoListener {
            override fun onRoutesInfoChanged(routesInfo: RouteEditorRoutesInfo) {
                handleInfoChanged(routesInfo)
            }
        })

        lifecycle.addObserver(object : DefaultLifecycleObserver {
            override fun onDestroy(owner: LifecycleOwner) {
                mapController.resetRouteInfoListener()
                mapController.hideRoutes()
            }
        })

        directoryObject.markerPosition?.let {
            mapController.setRouteParams(
                it.latitude.value,
                it.longitude.value,
                directoryObject.id
            )
        }
    }

    @OptIn(ExperimentalCarApi::class)
    override fun onGetTemplate(): Template {
        return when (val state = this.state) {
            RoutePreviewScreenState.Loading -> {
                MapTemplate.Builder()
                    .setHeader(Header.Builder().setStartHeaderAction(Action.BACK).build())
                    .setPane(Pane.Builder().setLoading(true).build()).build()
            }

            is RoutePreviewScreenState.SingleRoute -> {
                val templateMapController = MapController.Builder()
                    .setMapActionStrip(buildMapActionStrip())
                    .build();
                MapTemplate.Builder().setMapController(templateMapController)
                    .setHeader(headerBack).setPane(state.pane).build()
            }

            is RoutePreviewScreenState.SeveralRoutes -> {
                RoutePreviewNavigationTemplate.Builder()
                    .setPanModeListener(panModeListener)
                    .setMapActionStrip(buildMapActionStrip())
                    .setHeader(headerRouteOverview)
                    .setNavigateAction(navigationAction)
                    .setItemList(state.itemList)
                    .build()
            }
        }
    }

    private fun onNavigate() {
        when (val state = state) {
            is RoutePreviewScreenState.SeveralRoutes -> mapController.startNavigation(state.routesInfo.routeParams)
            is RoutePreviewScreenState.SingleRoute -> mapController.startNavigation(state.routesInfo.routeParams)
            else -> {}
        }

        carContext.getCarService(ScreenManager::class.java).popToRoot()
    }

    private fun handleInfoChanged(routesInfo: RouteEditorRoutesInfo) {
        if (routesInfo.routes.isEmpty()) return

        if (routesInfo.routes.size == 1) {
            val route = routesInfo.routes.first().route
            val distanceInMeters = route.geometry.last?.point?.distance?.meters ?: 0.0
            val distanceSpan = DistanceSpan.create(
                AndroidAutoUtils.createDistance(distanceInMeters)
            )

            val title = SpannableString("${directoryObject.title}\n ")
            val spanStart = title.length
            title.setSpan(
                distanceSpan,
                spanStart - 1,
                spanStart,
                Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
            )

            val pane = Pane.Builder()
            pane.addRow(
                Row.Builder().setTitle(title).addText(directoryObject.makeAddressString()).build()
            )
            val phone = directoryObject.contactInfos.firstOrNull { it.type == "phone" }?.value
            if (phone != null) {
                pane.addAction(buildPhoneAction(phone))
            }
            pane.addAction(navigationAction)

            state = RoutePreviewScreenState.SingleRoute(pane.build(), routesInfo)
            invalidate()
            return
        }

        val itemList = ItemList.Builder()
        itemList.setOnSelectedListener { i -> selectRoute(i) }

        for (i in 0 until min(routesInfo.routes.size, itemsLimit)) {
            val route = routesInfo.routes[i]
            val distanceInMeters = route.route.geometry.last?.point?.distance?.meters ?: 0.0
            val distance = AndroidAutoUtils.createDistance(distanceInMeters)
            val duration =
                route.route.geometry.first?.point?.let {
                    route.traffic.durations.calculateDuration(it).inSeconds
                } ?: 0

            val title = SpannableString(" \n ")
            title.setSpan(
                DurationSpan.create(TimeUnit.SECONDS.toSeconds(duration)),
                0,
                1,
                Spanned.SPAN_INCLUSIVE_INCLUSIVE
            )

            val distanceSpanStart = title.length
            title.setSpan(
                DistanceSpan.create(distance),
                distanceSpanStart - 1,
                distanceSpanStart,
                Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
            )

            itemList.addItem(
                Row.Builder().setTitle(title).build()
            )
        }

        state = RoutePreviewScreenState.SeveralRoutes(itemList.build(), routesInfo)
        invalidate()
    }

    private fun selectRoute(index: Int) {
        mapController.setActiveRouteIndex(index)
    }

    private fun buildPhoneAction(phone: String): Action {
        return Action.Builder()
            .setTitle(getString(R.string.phone_button))
            .setOnClickListener {
                val intent = Intent(Intent.ACTION_DIAL).apply {
                    data = Uri.parse("tel:$phone")
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                }
                carContext.startCarApp(intent)
            }
            .build()
    }
}

private sealed class RoutePreviewScreenState {
    data object Loading : RoutePreviewScreenState()
    data class SeveralRoutes(val itemList: ItemList, val routesInfo: RouteEditorRoutesInfo) :
        RoutePreviewScreenState()

    data class SingleRoute(val pane: Pane, val routesInfo: RouteEditorRoutesInfo) :
        RoutePreviewScreenState()
}

