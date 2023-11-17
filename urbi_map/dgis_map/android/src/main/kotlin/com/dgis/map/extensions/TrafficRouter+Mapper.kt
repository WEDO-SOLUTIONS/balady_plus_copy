package com.dgis.map.extensions

import com.dgis.map.map_api.Messages
import com.dgis.map.map_api.Messages.BearingMessage
import com.dgis.map.map_api.Messages.BriefExtraRouteInfoMessage
import com.dgis.map.map_api.Messages.BriefRouteInfoMessage
import com.dgis.map.map_api.Messages.DgisObjectIdMessage
import com.dgis.map.map_api.Messages.LevelIdMessage
import com.dgis.map.map_api.Messages.RouteSearchOptionsMessage
import com.dgis.map.map_api.Messages.RouteSearchPointMessage
import ru.dgis.sdk.DgisObjectId
import ru.dgis.sdk.LevelId
import ru.dgis.sdk.coordinates.Bearing
import ru.dgis.sdk.routing.BicycleRouteSearchOptions
import ru.dgis.sdk.routing.BriefExtraRouteInfo
import ru.dgis.sdk.routing.BriefRouteInfo
import ru.dgis.sdk.routing.BriefRouteInfoSearchPoints
import ru.dgis.sdk.routing.CarRouteSearchOptions
import ru.dgis.sdk.routing.PedestrianRouteSearchOptions
import ru.dgis.sdk.routing.PublicTransportRouteSearchOptions
import ru.dgis.sdk.routing.RouteSearchOptions
import ru.dgis.sdk.routing.RouteSearchPoint
import ru.dgis.sdk.routing.ScooterRouteSearchOptions
import ru.dgis.sdk.routing.TaxiRouteSearchOptions
import ru.dgis.sdk.routing.TruckRouteSearchOptions

fun RouteSearchOptionsMessage.toRouteSearchOptions(): RouteSearchOptions = when (this) {
    RouteSearchOptionsMessage.BICYCLE -> RouteSearchOptions(bicycle = BicycleRouteSearchOptions())
    RouteSearchOptionsMessage.CAR -> RouteSearchOptions(car = CarRouteSearchOptions())
    RouteSearchOptionsMessage.PUBLIC_TRANSPORT -> RouteSearchOptions(publicTransport = PublicTransportRouteSearchOptions())
    RouteSearchOptionsMessage.PEDESTRIAN -> RouteSearchOptions(pedestrian = PedestrianRouteSearchOptions())
    RouteSearchOptionsMessage.SCOOTER -> RouteSearchOptions(scooter = ScooterRouteSearchOptions())
    RouteSearchOptionsMessage.TRUCK -> RouteSearchOptions(truck = TruckRouteSearchOptions(CarRouteSearchOptions()))
    RouteSearchOptionsMessage.TAXI -> RouteSearchOptions(taxi = TaxiRouteSearchOptions(CarRouteSearchOptions()))
}

fun Messages.BriefRouteInfoSearchPointsMessage.toSearchPoint(): BriefRouteInfoSearchPoints {
    return BriefRouteInfoSearchPoints(
            startPoint = this.startPoint.toRouteSearchPoint(),
            finishPoint = this.finishPoint.toRouteSearchPoint()
    )
}

fun BearingMessage.toBearing(): Bearing {
    return Bearing(this.value)
}

fun DgisObjectIdMessage.toDgisObjectId(): DgisObjectId {
    return DgisObjectId(objectId = this.objectId, entranceId = this.entranceId)
}

fun LevelIdMessage.toLevelId(): LevelId {
    return LevelId(value = this.value)
}

fun RouteSearchPointMessage.toRouteSearchPoint(): RouteSearchPoint {
    return RouteSearchPoint(
            coordinates = coordinates.toGeoPoint(),
            course = course?.toBearing(),
            objectId = objectId.toDgisObjectId(),
            levelId = levelId?.toLevelId(),
    )
}

fun BriefExtraRouteInfo.toBriefExtraRouteInfoMessage(): BriefExtraRouteInfoMessage {
    return when {
        isCar -> BriefExtraRouteInfoMessage.CAR
        isBicycle -> BriefExtraRouteInfoMessage.BICYCLE
        isScooter -> BriefExtraRouteInfoMessage.SCOOTER
        isPedestrian -> BriefExtraRouteInfoMessage.PEDESTRIAN
        isPublicTransport -> BriefExtraRouteInfoMessage.PUBLIC_TRANSPORT
        else -> BriefExtraRouteInfoMessage.CAR
    }
}

fun BriefRouteInfo.toBriefRouteInfoMessage(): BriefRouteInfoMessage {
    return BriefRouteInfoMessage.Builder()
            .setDuration(duration.inSeconds.toDouble())
            .setExtraInfo(extraInfo.toBriefExtraRouteInfoMessage())
            .build()
}

