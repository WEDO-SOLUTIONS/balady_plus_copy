package com.dgis.map.extensions

import com.dgis.map.map_api.RoadEventActionResultMessage
import com.dgis.map.map_api.RoadEventActionTypeMessage
import ru.dgis.sdk.road_events.ActionResult
import ru.dgis.sdk.road_events.RoadEventActionType

fun RoadEventActionTypeMessage.toRoadEventActionType(): RoadEventActionType = when (this) {
    RoadEventActionTypeMessage.LIKE -> RoadEventActionType.LIKE
    RoadEventActionTypeMessage.DISLIKE -> RoadEventActionType.DISLIKE
    RoadEventActionTypeMessage.CONFIRMATION -> RoadEventActionType.CONFIRMATION
    RoadEventActionTypeMessage.DISPROOF -> RoadEventActionType.DISPROOF
}

fun ActionResult.toMessage(): RoadEventActionResultMessage = when (this) {
    ActionResult.OK -> RoadEventActionResultMessage.OK
    ActionResult.NETWORK_ERROR -> RoadEventActionResultMessage.NETWORK_ERROR
}
