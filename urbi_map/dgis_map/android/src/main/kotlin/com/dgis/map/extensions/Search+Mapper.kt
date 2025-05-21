package com.dgis.map.extensions

import com.dgis.map.map_api.*
import ru.dgis.sdk.directory.*
import ru.dgis.sdk.map.Camera
import ru.dgis.sdk.map.calcPosition

fun SearchResult.toMessage(pageId: String, camera: Camera, items: List<ItemMarkerInfo>?): SearchResultMessage {
    return SearchResultMessage(
        firstPage = this.firstPage?.toMessage(pageId),
        representativeArea = this.representativeArea?.toMessage(),
        areaOfInterestPosition = this.representativeArea?.let {
            val cameraPosition = calcPosition(camera, it)
            CameraPositionMessage(
                point = cameraPosition.point.toMessage(),
                zoom = cameraPosition.zoom.value.toDouble(),
                tilt = cameraPosition.tilt.value.toDouble(),
                bearing = cameraPosition.bearing.value
            )
        },
        itemMarkerInfos = items?.map { it.toMessage() },
        searchResultType = this.searchResultType.toMessage(),
        dynamicFilters = this.dynamicFilters.map { it.toMessage() },
        autoUseFirstResult = this.autoUseFirstResult
    )
}
fun UIMarkerInfo.toMessage(): UiMarkerInfoMessage {
    return UiMarkerInfoMessage(
        objectId = objectId?.toMessage(),
        label = label
    )
}
fun Page.toMessage(id: String): PageMessage {
    return PageMessage(
        id = PageIdMessage(id = id),
        items = this.items.map { it.toMessage() }
    )
}

fun ItemMarkerInfo.toMessage(): ItemMarkerInfoMessage {
    return ItemMarkerInfoMessage(
        objectId = this.objectId?.toMessage(),
        geoPoint = this.geoPoint.toMessage(),
        floorInfo = this.floorInfo?.toMessage(),
        title = this.title,
        rubricIds = this.rubricIds.map { it.value },
    )
}
fun FloorInfo.toMessage(): FloorInfoMessage {
    return FloorInfoMessage(
        levelId = this.levelId.value,
        buildingId = this.buildingId.value
    )
}

fun SearchResultType.toMessage(): SearchResultTypeMessage =
        when (this) {
            SearchResultType.RECOVERY -> SearchResultTypeMessage.RECOVERY
            SearchResultType.DISCOVERY -> SearchResultTypeMessage.DISCOVERY
        }



fun RangeFilter.toMessage(): RangeFilterMessage {
    return RangeFilterMessage(
        tagName = this.tagName,
        displayName = this.displayName,
        minValue = this.minValue,
        maxValue = this.maxValue
    )
}

fun FlagFilter.toMessage(): FlagFilterMessage {
    return FlagFilterMessage(
        tagName = this.tagName,
        displayName = this.displayName,
        flagValue = this.flagValue
    )
}

fun DynamicFilter.toMessage(): DynamicFilterMessage {
    return DynamicFilterMessage(
        flagFilter = this.asFlagFilter?.toMessage(),
        rangeFilter = this.asRangeFilter?.toMessage()
    )
}
