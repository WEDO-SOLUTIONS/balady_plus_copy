package com.dgis.map.control_handlers.navigation_controls

import com.dgis.map.live_updates.NavLiveEventBus
import com.dgis.map.live_updates.NavManeuver
import io.flutter.plugin.common.EventChannel.EventSink
import ru.dgis.sdk.navigation.*
import ru.dgis.sdk.routing.*

class ManeuverControlModel(
    private val model: Model,
    private val eventSink: EventSink,
) : AutoCloseable {

    private val closables = listOf(
        model.routeChannel.connect(this::routeListener),
        model.routePositionChannel.connect(this::routePositionListener),
        model.stateChannel.connect(this::stateListener)
    )

    private var roadRules: RoadRuleRouteLongAttribute? = null
    private var instructions: InstructionRouteAttribute? = null

    override fun close() {
        closables.forEach(AutoCloseable::close)
    }

    private fun routeListener(routeInfo: RouteInfo) {
        instructions = routeInfo.route.instructions
        roadRules = routeInfo.route.roadRules

        val routePosition = model.routePosition ?: return
        val instructions = this.instructions ?: return

        getNextManeuverInfo(routePosition, instructions)
        getAdditionalManeuverInfo(routePosition, instructions)
    }

    private fun routePositionListener(position: RoutePoint?) {
        position ?: return
        val instructions = instructions ?: return

        getNextManeuverInfo(position, instructions)
        getAdditionalManeuverInfo(position, instructions)
    }

    private fun stateListener(state: State) {
        val instructions = instructions ?: return
        val position = model.routePosition ?: return

        getNextManeuverInfo(position, instructions)
        getAdditionalManeuverInfo(position, instructions)
    }

    private fun getNextManeuverInfo(position: RoutePoint, instructions: InstructionRouteAttribute) {
        instructions.findNearBackward(position)?.let {
            if (position <= it.point + it.value.range) {
                return getNextManeuverStateForInstruction(it, position)
            }
        }

        instructions.findNearForward(position)?.let {
            return getNextManeuverStateForInstruction(it, position)
        }
    }

    private fun getAdditionalManeuverInfo(
        position: RoutePoint,
        instructions: InstructionRouteAttribute
    ) {
        val instructionEntry = instructions.findNearForward(position) ?: return

        val instruction = instructionEntry.value

        val instructionType = getInstructionManeuver(instruction.extraInstructionInfo)

        // Дополнительного маневра не должно быть у первой инструкции "Двигайтесь прямо",
        // а также у карточки "Вы на месте".
        if (instructionEntry == instructions.first
            && (InstructionManeuver.CROSSROAD_STRAIGHT == instructionType
                    || InstructionManeuver.FINISH == instructionType)
        ) return

        instruction.extraInstructionInfo.asCarRoundabout?.let {
            if (it.type == CarInstructionRoundaboutType.EXIT) {
                return eventSink.success(
                    mapOf(
                        "event" to ManeuverEvents.maneuverAdditionalEvent.name,
                        "type" to ManeuverEvents.additionalHide.name,
                    )
                )
            }

            if (it.exitName.isNotEmpty()) {
                return eventSink.success(
                    mapOf(
                        "event" to ManeuverEvents.maneuverAdditionalEvent.name,
                        "type" to ManeuverEvents.additionalExitName.name,
                        "value" to it.exitName,
                    )
                )
            } else if (it.exitNumber > 0) {
                return eventSink.success(
                    mapOf(
                        "event" to ManeuverEvents.maneuverAdditionalEvent.name,
                        "type" to ManeuverEvents.additionalExitName.name,
                        "value" to it.exitNumber.toString(),
                    )
                )
            }
        }

        instruction.extraInstructionInfo.asCarCrossroad?.let {
            if (it.exitName.isNotEmpty()) {
                return eventSink.success(
                    mapOf(
                        "event" to ManeuverEvents.maneuverAdditionalEvent.name,
                        "type" to ManeuverEvents.additionalExitName.name,
                        "value" to it.exitName,
                    )
                )
            }
        }

        instruction.extraInstructionInfo.asCarUturn?.let {
            if (it.exitName.isNotEmpty()) {
                return eventSink.success(
                    mapOf(
                        "event" to ManeuverEvents.maneuverAdditionalEvent.name,
                        "type" to ManeuverEvents.additionalExitName.name,
                        "value" to it.exitName,
                    )
                )
            }
        }

        // Показываем дополнительный маневр только если до основного осталось ехать не более 1000 метров.
        if (1000 < (instructionEntry.point - position).meters.toInt()) {
            return eventSink.success(
                mapOf(
                    "event" to ManeuverEvents.maneuverAdditionalEvent.name,
                    "type" to ManeuverEvents.additionalHide.name,
                )
            )
        }
        val nextInstructionEntry = instructions.findNearForward(
            RoutePoint(
                instructionEntry.point.distance + RouteDistance(millimeters = 1000)
            )
        ) ?: kotlin.run {
            return eventSink.success(
                mapOf(
                    "event" to ManeuverEvents.maneuverAdditionalEvent.name,
                    "type" to ManeuverEvents.additionalHide.name,
                )
            )
        }

        val instructionManeuver =
            getInstructionManeuver(nextInstructionEntry.value.extraInstructionInfo)

        if (InstructionManeuver.NONE == instructionManeuver) {
            return eventSink.success(
                mapOf(
                    "event" to ManeuverEvents.maneuverAdditionalEvent.name,
                    "type" to ManeuverEvents.additionalHide.name,
                )
            )
        }

        val distance = (nextInstructionEntry.point - instructionEntry.point).meters.toInt()

        if (distance > 50) {
            return eventSink.success(
                mapOf(
                    "event" to ManeuverEvents.maneuverAdditionalEvent.name,
                    "type" to ManeuverEvents.additionalHide.name,
                )
            )
        }

        return eventSink.success(
            mapOf(
                "event" to ManeuverEvents.maneuverAdditionalEvent.name,
                "type" to ManeuverEvents.additionalIconWithText.name,
                "value" to instructionManeuver.name,
            )
        )
    }

    private fun getNextManeuverStateForInstruction(
        instructionEntry: InstructionRouteEntry,
        routePosition: RoutePoint,
    ) {
        val instruction = instructionEntry.value

        val distance = (instructionEntry.point - routePosition).millimeters
        if (distance <= 0 && instruction.roadName.isEmpty()) {
            return eventSink.success(
                mapOf(
                    "event" to ManeuverEvents.maneuverEvent.name,
                    "type" to ManeuverEvents.nextHidden.name
                )
            )
        }

        val instructionType = getInstructionManeuver(instruction.extraInstructionInfo)

        NavLiveEventBus.maneuver.value = NavManeuver(
            distanceMm = distance,
            roadName = instruction.roadName,
            instructionName = instructionType.name,
        )

        return eventSink.success(
            mapOf(
                "event" to ManeuverEvents.maneuverEvent.name,
                "type" to ManeuverEvents.nextManeuver.name,
                "distance" to distance,
                "unit" to "unit",
                "roadName" to instruction.roadName,
                "instruction" to instructionType.name,
            )
        )
    }

    private enum class ManeuverEvents {
        maneuverEvent,
        maneuverAdditionalEvent,

        //
        additionalHide,
        additionalExitName,
        additionalIconWithText,

        //
        nextHidden,
        nextManeuver,
    }
}
