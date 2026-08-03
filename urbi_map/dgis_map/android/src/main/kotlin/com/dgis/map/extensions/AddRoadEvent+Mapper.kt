package com.dgis.map.extensions

import com.dgis.map.map_api.AddRoadEventResultMessage
import com.dgis.map.map_api.RoadEventLaneMessage
import ru.dgis.sdk.road_events.AddEventError
import ru.dgis.sdk.road_events.Lane
import java.util.EnumSet

fun AddEventError.toMessage(): AddRoadEventResultMessage = when (this) {
    AddEventError.NETWORK_ERROR -> AddRoadEventResultMessage.NETWORK_ERROR
    AddEventError.TERRITORY_NOT_SUPPORTED -> AddRoadEventResultMessage.TERRITORY_NOT_SUPPORTED
    AddEventError.UNKNOWN_USER_LOCATION -> AddRoadEventResultMessage.UNKNOWN_USER_LOCATION
    AddEventError.USER_LOCATION_TOO_FAR_FROM_EVENT -> AddRoadEventResultMessage.USER_LOCATION_TOO_FAR_FROM_EVENT
    AddEventError.NOT_AUTHORIZED -> AddRoadEventResultMessage.NOT_AUTHORIZED
    AddEventError.NO_PERSONAL_DATA_COLLECTION_CONSENT -> AddRoadEventResultMessage.NO_PERSONAL_DATA_COLLECTION_CONSENT
    AddEventError.USER_BLOCKED -> AddRoadEventResultMessage.USER_BLOCKED
    AddEventError.TOO_MANY_REQUESTS -> AddRoadEventResultMessage.TOO_MANY_REQUESTS
}

fun RoadEventLaneMessage.toLane(): Lane = when (this) {
    RoadEventLaneMessage.LEFT -> Lane.LEFT
    RoadEventLaneMessage.CENTER -> Lane.CENTER
    RoadEventLaneMessage.RIGHT -> Lane.RIGHT
}

fun List<RoadEventLaneMessage>.toLaneEnumSet(): EnumSet<Lane> {
    val lanes = this.map { it.toLane() }
    return if (lanes.isEmpty()) EnumSet.noneOf(Lane::class.java) else EnumSet.copyOf(lanes)
}
