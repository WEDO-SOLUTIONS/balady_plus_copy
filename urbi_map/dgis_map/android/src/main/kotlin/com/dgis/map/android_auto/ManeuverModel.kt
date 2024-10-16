package com.dgis.map.android_auto

import androidx.car.app.model.DateTimeWithZone
import androidx.car.app.navigation.model.Maneuver
import com.dgis.map.R
import ru.dgis.sdk.navigation.InstructionManeuver

class ManeuverModel(
    val type: Int,
    val distance: Double,
    val arrivalTime: DateTimeWithZone,
    val roadName: String,
    val iconId: Int,
    val roundAboutExitNumber: Int?,
)

fun InstructionManeuver.iconId(): Int? {
    return when (this) {
        InstructionManeuver.START -> R.drawable.crossroad_straight
        InstructionManeuver.ROAD_CROSSING -> R.drawable.crossroad_straight
        InstructionManeuver.CROSSROAD_STRAIGHT -> R.drawable.crossroad_straight
        InstructionManeuver.CROSSROAD_SLIGHTLY_LEFT -> R.drawable.crossroad_slightly_left
        InstructionManeuver.CROSSROAD_LEFT -> R.drawable.crossroad_left
        InstructionManeuver.CROSSROAD_SHARPLY_LEFT -> R.drawable.crossroad_sharply_left
        InstructionManeuver.CROSSROAD_SLIGHTLY_RIGHT -> R.drawable.crossroad_slightly_right
        InstructionManeuver.CROSSROAD_RIGHT -> R.drawable.crossroad_right
        InstructionManeuver.CROSSROAD_SHARPLY_RIGHT -> R.drawable.crossroad_sharply_right
        InstructionManeuver.CROSSROAD_KEEP_LEFT -> R.drawable.crossroad_keep_left
        InstructionManeuver.CROSSROAD_KEEP_RIGHT -> R.drawable.crossroad_keep_right
        InstructionManeuver.CROSSROAD_UTURN -> R.drawable.turn_over_right_hand
        InstructionManeuver.ROUNDABOUT_FORWARD -> R.drawable.ringroad_forward
        InstructionManeuver.ROUNDABOUT_LEFT_45 -> R.drawable.ringroad_left_45
        InstructionManeuver.ROUNDABOUT_LEFT_90 -> R.drawable.ringroad_left_90
        InstructionManeuver.ROUNDABOUT_LEFT_135 -> R.drawable.ringroad_left_135
        InstructionManeuver.ROUNDABOUT_RIGHT_45 -> R.drawable.ringroad_right_45
        InstructionManeuver.ROUNDABOUT_RIGHT_90 -> R.drawable.ringroad_right_90
        InstructionManeuver.ROUNDABOUT_RIGHT_135 -> R.drawable.ringroad_right_135
        InstructionManeuver.ROUNDABOUT_BACKWARD -> R.drawable.ringroad_backward
        InstructionManeuver.ROUNDABOUT_EXIT -> R.drawable.ringroad_exit
        InstructionManeuver.UTURN -> R.drawable.turn_over_right_hand
        InstructionManeuver.FINISH -> R.drawable.finish
        else -> null
    }
}

fun InstructionManeuver.toManeuverType(): Int? {
    return when (this) {
        InstructionManeuver.START -> Maneuver.TYPE_STRAIGHT
        InstructionManeuver.ROAD_CROSSING -> Maneuver.TYPE_STRAIGHT
        InstructionManeuver.CROSSROAD_STRAIGHT -> Maneuver.TYPE_STRAIGHT
        InstructionManeuver.CROSSROAD_SLIGHTLY_LEFT -> Maneuver.TYPE_TURN_SLIGHT_LEFT
        InstructionManeuver.CROSSROAD_LEFT -> Maneuver.TYPE_TURN_NORMAL_LEFT
        InstructionManeuver.CROSSROAD_SHARPLY_LEFT -> Maneuver.TYPE_TURN_SHARP_LEFT
        InstructionManeuver.CROSSROAD_SLIGHTLY_RIGHT -> Maneuver.TYPE_TURN_SLIGHT_RIGHT
        InstructionManeuver.CROSSROAD_RIGHT -> Maneuver.TYPE_TURN_NORMAL_RIGHT
        InstructionManeuver.CROSSROAD_SHARPLY_RIGHT -> Maneuver.TYPE_TURN_SHARP_RIGHT
        InstructionManeuver.CROSSROAD_KEEP_LEFT -> Maneuver.TYPE_KEEP_LEFT
        InstructionManeuver.CROSSROAD_KEEP_RIGHT -> Maneuver.TYPE_KEEP_RIGHT
        InstructionManeuver.CROSSROAD_UTURN -> Maneuver.TYPE_U_TURN_LEFT
        InstructionManeuver.ROUNDABOUT_FORWARD -> Maneuver.TYPE_ROUNDABOUT_ENTER_AND_EXIT_CCW
        InstructionManeuver.ROUNDABOUT_LEFT_45 -> Maneuver.TYPE_ROUNDABOUT_ENTER_AND_EXIT_CCW
        InstructionManeuver.ROUNDABOUT_LEFT_90 -> Maneuver.TYPE_ROUNDABOUT_ENTER_AND_EXIT_CCW
        InstructionManeuver.ROUNDABOUT_LEFT_135 -> Maneuver.TYPE_ROUNDABOUT_ENTER_AND_EXIT_CCW
        InstructionManeuver.ROUNDABOUT_RIGHT_45 -> Maneuver.TYPE_ROUNDABOUT_ENTER_AND_EXIT_CCW
        InstructionManeuver.ROUNDABOUT_RIGHT_90 -> Maneuver.TYPE_ROUNDABOUT_ENTER_AND_EXIT_CCW
        InstructionManeuver.ROUNDABOUT_RIGHT_135 -> Maneuver.TYPE_ROUNDABOUT_ENTER_AND_EXIT_CCW
        InstructionManeuver.ROUNDABOUT_BACKWARD -> Maneuver.TYPE_ROUNDABOUT_ENTER_AND_EXIT_CCW
        InstructionManeuver.ROUNDABOUT_EXIT -> Maneuver.TYPE_ROUNDABOUT_EXIT_CCW
        InstructionManeuver.UTURN -> Maneuver.TYPE_U_TURN_LEFT
        InstructionManeuver.FINISH -> Maneuver.TYPE_DESTINATION_STRAIGHT
        else -> null
    }
}
