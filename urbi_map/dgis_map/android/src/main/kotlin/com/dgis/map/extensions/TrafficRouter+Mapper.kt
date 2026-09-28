package com.dgis.map.extensions


import com.dgis.map.map_api.BearingMessage
import com.dgis.map.map_api.BriefExtraRouteInfoMessage
import com.dgis.map.map_api.BriefExtraRouteInfoTypeMessage
import com.dgis.map.map_api.BriefRouteInfoMessage
import com.dgis.map.map_api.DgisObjectIdMessage
import com.dgis.map.map_api.LevelIdMessage
import com.dgis.map.map_api.RouteSearchOptionsMessage
import com.dgis.map.map_api.RouteSearchPointMessage
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
    RouteSearchOptionsMessage.TRUCK -> RouteSearchOptions(
        truck = TruckRouteSearchOptions(
            CarRouteSearchOptions()
        )
    )

    RouteSearchOptionsMessage.TAXI -> RouteSearchOptions(
        taxi = TaxiRouteSearchOptions(
            CarRouteSearchOptions()
        )
    )
}

fun RouteSearchOptions.toRouteSearchOptionsMessage(): RouteSearchOptionsMessage = when {
    isBicycle -> RouteSearchOptionsMessage.BICYCLE
    isCar -> RouteSearchOptionsMessage.CAR
    isPublicTransport -> RouteSearchOptionsMessage.PUBLIC_TRANSPORT
    isPedestrian -> RouteSearchOptionsMessage.PEDESTRIAN
    isScooter -> RouteSearchOptionsMessage.SCOOTER
    isTruck -> RouteSearchOptionsMessage.TRUCK
    isTaxi -> RouteSearchOptionsMessage.TAXI
    else -> RouteSearchOptionsMessage.CAR
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

fun RouteSearchPoint.toMessage(): RouteSearchPointMessage {
    return RouteSearchPointMessage(
        coordinates = coordinates.toMessage(),
        course = course?.let { BearingMessage(value = it.value) },
        objectId = objectId.toMessage(),
        levelId = levelId?.let { LevelIdMessage(value = it.value) },
    )
}

fun BriefExtraRouteInfo.toBriefExtraRouteInfoMessage(): BriefExtraRouteInfoMessage {
    val distanceValue = when {
        isCar -> asCar?.length?.millimeters ?: 0
        isBicycle -> asBicycle?.length?.millimeters ?: 0
        isScooter -> asScooter?.length?.millimeters ?: 0
        isPedestrian -> asPedestrian?.length?.millimeters ?: 0
        isPublicTransport -> 0 // Для общественного транспорта длина не определена
        else -> asCar?.length?.millimeters ?: 0
    }

    val routeType = when {
        isCar -> BriefExtraRouteInfoTypeMessage.CAR
        isBicycle -> BriefExtraRouteInfoTypeMessage.BICYCLE
        isScooter -> BriefExtraRouteInfoTypeMessage.SCOOTER
        isPedestrian -> BriefExtraRouteInfoTypeMessage.PEDESTRIAN
        isPublicTransport -> BriefExtraRouteInfoTypeMessage.PUBLIC_TRANSPORT
        else -> BriefExtraRouteInfoTypeMessage.CAR
    }
    return BriefExtraRouteInfoMessage(
        type = routeType,
        distance = distanceValue
    )
}

fun BriefRouteInfo.toBriefRouteInfoMessage(): BriefRouteInfoMessage {
    return BriefRouteInfoMessage(
        duration = duration.inSeconds.toDouble(),
        extraInfo = extraInfo.toBriefExtraRouteInfoMessage()
    )
}
