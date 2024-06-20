package com.dgis.map.extensions

import com.dgis.map.map_api.Messages.*
import ru.dgis.sdk.directory.*
import ru.dgis.sdk.map.Camera
import ru.dgis.sdk.map.calcPosition

fun SearchResult.toMessage(pageId: String, camera: Camera, items: List<ItemMarkerInfo>?, labels: List<UIMarkerInfo>?): SearchResultMessage {
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

        .setMarkersWithLabel(labels?.map {
            it.toMessage()
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

fun UIMarkerInfo.toMessage(): UiMarkerInfoMessage {
    return UiMarkerInfoMessage.Builder()
        .setObjectId(objectId?.toMessage())
        .setLabel(label)
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
            it.toMessage()
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
        SearchCategoryMessage.RESTAURANTS -> listOf(161,165,161,9786,162,469,58871)
        SearchCategoryMessage.PARKS -> listOf(168)
        SearchCategoryMessage.BEACHES -> listOf(168)
        SearchCategoryMessage.HOSPITALS -> listOf(201)
        SearchCategoryMessage.SCHOOLS -> listOf(245)
        SearchCategoryMessage.PHARMACIES -> listOf(207)
        SearchCategoryMessage.DENTAL_CENTERS -> listOf(222)
        SearchCategoryMessage.HOTELS -> listOf(269)
        SearchCategoryMessage.BEAUTY_CENTERS -> listOf(56759,110351,382,4521,4517,5603,651,58858,4518,652,13726,110355,13102,53986,110352)
        SearchCategoryMessage.RECREATION_CENTERS -> listOf(537,169,169,170,110358,51001,24472,173,110300,630,110388,110358,190,110358)
    }

    return ids.map {
        RubricId(it)
    }
}