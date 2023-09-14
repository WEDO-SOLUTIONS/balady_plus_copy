package com.dgis.map.extensions

import com.dgis.map.map_api.Messages.*
import ru.dgis.sdk.directory.*
import ru.dgis.sdk.map.Camera
import ru.dgis.sdk.map.calcPosition

fun SearchResult.toMessage(pageId: String, camera: Camera, items: List<ItemMarkerInfo>?): SearchResultMessage {
    return SearchResultMessage.Builder()
        .setFirstPage(this.firstPage?.toMessage(pageId))
        .setRepresentativeArea(this.representativeArea?.toMessage())
        .setAreaOfInterestPosition(this.representativeArea?.let {
            val cameraPosition = calcPosition(camera, it)
            CameraPositionMessage
                    .Builder()
                    .setPoint(cameraPosition.point.toMessage())
                    .setZoom(cameraPosition.zoom.value.toDouble())
                    .setTilt(cameraPosition.tilt.value.toDouble())
                    .setBearing(cameraPosition.bearing.value)
                    .build()
        })
        .setItemMarkerInfos(items?.map {
            it.toMessage()
        })
        .setSearchResultType(this.searchResultType.toMessage())
        .setDynamicFilters(this.dynamicFilters.map {
            it.toMessage()
        })
        .setAutoUseFirstResult(this.autoUseFirstResult)
        .build()
}

fun Page.toMessage(id: String): PageMessage {
    return PageMessage.Builder()
        .setId(
            PageIdMessage.Builder()
                .setId(id)
                .build()
        )
        .setItems(this.items.map {
            it.toMessage(null)
        })
        .build()
}

fun ItemMarkerInfo.toMessage(): ItemMarkerInfoMessage {
    return ItemMarkerInfoMessage.Builder()
        .setObjectId(this.objectId?.toMessage())
        .setFloorInfo(this.floorInfo?.toMessage())
        .setGeoPoint(this.geoPoint.toMessage())
        .build()
}

fun FloorInfo.toMessage(): FloorInfoMessage {
    return FloorInfoMessage.Builder()
        .setLevelId(this.levelId.value)
        .setBuildingId(this.buildingId.value)
        .build()
}

fun SearchResultType.toMessage(): SearchResultTypeMessage = when(this) {
    SearchResultType.RECOVERY -> SearchResultTypeMessage.RECOVERY
    SearchResultType.DISCOVERY -> SearchResultTypeMessage.DISCOVERY
}

fun RangeFilter.toMessage(): RangeFilterMessage {
    return  RangeFilterMessage.Builder()
        .setTagName(this.tagName)
        .setDisplayName(this.displayName)
        .setMinValue(this.minValue)
        .setMaxValue(this.maxValue)
        .build()
}

fun FlagFilter.toMessage(): FlagFilterMessage {
    return FlagFilterMessage.Builder()
        .setTagName(this.tagName)
        .setDisplayName(this.displayName)
        .setFlagValue(this.flagValue)
        .build()
}

fun DynamicFilter.toMessage(): DynamicFilterMessage {
    return DynamicFilterMessage.Builder()
        .setFlagFilter(this.asFlagFilter?.toMessage())
        .setRangeFilter(this.asRangeFilter?.toMessage())
        .build()
}

fun SearchCategoryMessage.toRubrics(): List<RubricId> {
    val ids: List<Long> = when (this) {
        SearchCategoryMessage.MOUSQUES -> listOf(13374)
        SearchCategoryMessage.GAS_STATIONS -> listOf(18547)
        SearchCategoryMessage.CAFE -> listOf(159, 162)
        SearchCategoryMessage.RESTAURANTS -> listOf(161)
        SearchCategoryMessage.PARKS -> listOf(168)
    }

    return ids.map {
        RubricId(it)
    }
}