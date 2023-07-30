package com.dgis.map.extensions

import com.dgis.map.map_api.Messages.*
import ru.dgis.sdk.directory.*

fun SearchResult.toMessage(pageId: String, items: List<ItemMarkerInfo>?): SearchResultMessage {
    return SearchResultMessage.Builder()
        .setFirstPage(this.firstPage?.toMessage(pageId))
        .setRepresentativeArea(this.representativeArea?.toMessage())
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
        SearchCategoryMessage.RESTAURANTS -> listOf(161, 1203, 112658, 51459, 110376, 166, 15791, 111593)
        SearchCategoryMessage.PARKS -> listOf(168)
    }

    return ids.map {
        RubricId(it)
    }
}