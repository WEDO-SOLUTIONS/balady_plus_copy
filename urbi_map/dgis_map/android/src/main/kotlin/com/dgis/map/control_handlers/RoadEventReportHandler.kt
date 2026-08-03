package com.dgis.map.control_handlers

import com.dgis.map.extensions.toGeoPoint
import com.dgis.map.extensions.toLaneEnumSet
import com.dgis.map.extensions.toMessage
import com.dgis.map.map_api.AddRoadEventResultMessage
import com.dgis.map.map_api.GeoPointMessage
import com.dgis.map.map_api.RoadEventLaneMessage
import com.dgis.map.map_api.RoadEventTypeMessage
import ru.dgis.sdk.Context
import ru.dgis.sdk.Future
import ru.dgis.sdk.road_events.AddEventResult
import ru.dgis.sdk.road_events.RoadEventManager

/// Creates new road events via the native RoadEventManager. Lanes are only
/// forwarded to the SDK for event types whose create* overload accepts them
/// (accident/roadWorks/other) — camera/roadRestriction/comment have no lanes
/// parameter natively, so `lanes` is simply not passed for those.
class RoadEventReportHandler(sdkContext: Context) {
    private val roadEventManager = RoadEventManager(sdkContext)
    private var pendingCreateFuture: Future<AddEventResult>? = null

    fun createRoadEvent(
        type: RoadEventTypeMessage,
        location: GeoPointMessage,
        lanes: List<RoadEventLaneMessage>,
        description: String,
        callback: (Result<AddRoadEventResultMessage>) -> Unit,
    ) {
        val point = location.toGeoPoint()
        val laneSet = lanes.toLaneEnumSet()
        val future = when (type) {
            RoadEventTypeMessage.ACCIDENT -> roadEventManager.createAccident(point, laneSet, description)
            RoadEventTypeMessage.ROAD_WORKS -> roadEventManager.createRoadWorks(point, laneSet, description)
            RoadEventTypeMessage.OTHER -> roadEventManager.createOther(point, laneSet, description)
            RoadEventTypeMessage.CAMERA -> roadEventManager.createCamera(point, description)
            RoadEventTypeMessage.ROAD_RESTRICTION -> roadEventManager.createRoadRestriction(point, description)
            RoadEventTypeMessage.COMMENT -> roadEventManager.createComment(point, description)
        }

        pendingCreateFuture = future.apply {
            onResult { result ->
                result.match(
                        { _ -> callback(Result.success(AddRoadEventResultMessage.OK)) },
                        { error -> callback(Result.success(error.toMessage())) },
                )
            }
            onError { error -> callback(Result.failure(error)) }
        }
    }
}
