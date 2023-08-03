package com.dgis.map.control_handlers.navigation_controls

import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.navigation.*
import ru.dgis.sdk.positioning.Location
import ru.dgis.sdk.routing.FloatRouteLongAttribute
import ru.dgis.sdk.routing.RouteCamera
import ru.dgis.sdk.routing.RouteCameraPurpose
import ru.dgis.sdk.routing.RoutePoint

class SpeedControlModel(
    model: Model,
    private val eventSink: EventChannel.EventSink,
) : AutoCloseable {

    private val cameraNotifier = CameraNotifier(model)

    private val closables = listOf(
        model.locationChannel.connect(this::locationListener),
        model.routeChannel.connect(this::routeInfoListener),
        model.routePositionChannel.connect(this::positionListener),
        model.exceedingMaxSpeedLimitChannel.connect(this::exceedLimitListener),
        cameraNotifier.cameraProgressChannel.connect(this::cameraListener),
    )

    private var speedLimits: FloatRouteLongAttribute? = null

    override fun close() = closables.forEach(AutoCloseable::close)

    private fun locationListener(location: Location?) {
        val speed = location?.groundSpeed ?: return
        val kmph = metersPerSecondToKilometersPerHour(speed.value).toInt()
        eventSink.success(
            mapOf(
                "event" to SpeedEvents.speedEvent.name,
                "speedEvent" to SpeedEvents.currentSpeedEvent.name,
                "value" to kmph,
            )
        )
    }

    private fun routeInfoListener(routeInfo: RouteInfo) {
        speedLimits = routeInfo.route.maxSpeedLimits
        // TODO: send to flutter
        // Не знаю, насколько тут большой список и как он ищет нужную скорость (метод ниже).
        // В идеале его весь надо передавать во Флаттер, чтоб меньше логики в нативе было.
        // Если по миллиметрам считает, которые в RoutePoint::distance::millimeters то это можно
        // и на Флаттере делать
    }

    private fun positionListener(position: RoutePoint?) {
        position ?: return
        val entry = speedLimits?.entry(position) ?: kotlin.run {
            return eventSink.success(
                mapOf(
                    "event" to SpeedEvents.speedEvent.name,
                    "speedEvent" to SpeedEvents.speedLimitEvent.name,
                    "value" to null,
                )
            )
        }

        val maxAllowedSpeed = metersPerSecondToKilometersPerHour(entry.value.toDouble()).toInt()
        eventSink.success(
            mapOf(
                "event" to SpeedEvents.speedEvent.name,
                "speedEvent" to SpeedEvents.speedLimitEvent.name,
                "value" to maxAllowedSpeed,
            )
        )
    }

    private fun exceedLimitListener(isExceed: Boolean) {
        eventSink.success(
            mapOf(
                "event" to SpeedEvents.speedEvent.name,
                "speedEvent" to SpeedEvents.exceedSpeedLimitEvent.name,
                "value" to isExceed,
            )
        )
    }

    private fun cameraListener(cameraInfo: CameraProgressInfo?) {
        // Check for SPEED_CONTROL, AVERAGE_SPEED_CONTROL, NO_STOPPING_CONTROL
        cameraInfo ?: kotlin.run {
            return eventSink.success(
                mapOf(
                    "event" to SpeedEvents.speedEvent.name,
                    "speedEvent" to SpeedEvents.cameraEvent.name,
                    "value" to null,
                    "direction" to null,
                )
            )
        }

        if (!cameraInfo.camera.isSpeedCamera && !cameraInfo.camera.isNoStoppingCamera) {
            return eventSink.success(
                mapOf(
                    "event" to SpeedEvents.speedEvent.name,
                    "speedEvent" to SpeedEvents.cameraEvent.name,
                    "value" to false,
                    "direction" to null,
                )
            )
        }

        eventSink.success(
            mapOf(
                "event" to SpeedEvents.speedEvent.name,
                "speedEvent" to SpeedEvents.cameraEvent.name,
                "value" to true,
                "direction" to cameraInfo.camera.direction.name,
            )
        )
    }
}


private val RouteCamera.isSpeedCamera: Boolean
    get() = this.purposes.contains(RouteCameraPurpose.SPEED_CONTROL) || this.purposes.contains(
        RouteCameraPurpose.AVERAGE_SPEED_CONTROL
    )

private val RouteCamera.isNoStoppingCamera: Boolean
    get() = this.purposes.contains(RouteCameraPurpose.NO_STOPPING_CONTROL)

private enum class SpeedEvents {
    // Speed event name
    speedEvent,

    // Specific event names
    currentSpeedEvent,
    speedLimitEvent,
    exceedSpeedLimitEvent,
    cameraEvent,
}
