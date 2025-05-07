package com.dgis.map.extensions

import com.dgis.map.map_api.*
import ru.dgis.sdk.*
import ru.dgis.sdk.directory.*

fun Suggest.toMessage(searchQueryId: String?): SuggestMessage {
    return SuggestMessage(
        handler = this.handler.toMessage(searchQueryId),
        suggestedType = this.suggestedType.toMessage(),
        title = this.title.toMessage(),
        subtitle = this.subtitle.toMessage()
    )
}

fun SuggestHandler.toMessage(searchQueryId: String?): SuggestHandlerMessage {
    return SuggestHandlerMessage(
        objectHandler = this.asObjectHandler?.let {
            SuggestObjectHandlerMessage(
                item = it.item.toMessage()
            )
        },
        incompleteTextHandler = this.asIncompleteTextHandler?.let {
            IncompleteTextHandlerMessage(
                queryText = it.queryText
            )
        },
        performSearchHandler = this.asPerformSearchHandler?.let {
            PerformSearchHandlerMessage(
                searchQuery = SearchQueryMessage(
                    id = searchQueryId!!
                )
            )
        }
    )
}

fun SuggestedType.toMessage(): SuggestedTypeMessage = when(this) {
    SuggestedType.ATTRACTION -> SuggestedTypeMessage.ATTRACTION
    SuggestedType.ATTRIBUTE -> SuggestedTypeMessage.ATTRIBUTE
    SuggestedType.BRANCH -> SuggestedTypeMessage.BRANCH
    SuggestedType.BUILDING -> SuggestedTypeMessage.BUILDING
    SuggestedType.COORDINATES -> SuggestedTypeMessage.COORDINATES
    SuggestedType.CROSSROAD -> SuggestedTypeMessage.CROSSROAD
    SuggestedType.ADM_DIV_DISTRICT_AREA -> SuggestedTypeMessage.ADM_DIV_DISTRICT_AREA
    SuggestedType.ORG -> SuggestedTypeMessage.ORG
    SuggestedType.PARKING -> SuggestedTypeMessage.PARKING
    SuggestedType.ADM_DIV_REGION -> SuggestedTypeMessage.ADM_DIV_REGION
    SuggestedType.ROAD -> SuggestedTypeMessage.ROAD
    SuggestedType.ROUTE -> SuggestedTypeMessage.ROUTE
    SuggestedType.STATION -> SuggestedTypeMessage.STATION
    SuggestedType.STATION_ENTRANCE -> SuggestedTypeMessage.STATION_ENTRANCE
    SuggestedType.STREET -> SuggestedTypeMessage.STREET
    SuggestedType.TEXT -> SuggestedTypeMessage.TEXT
    SuggestedType.UNKNOWN -> SuggestedTypeMessage.UNKNOWN
    SuggestedType.ADM_DIV_CITY -> SuggestedTypeMessage.ADM_DIV_CITY
    SuggestedType.ADM_DIV_COUNTRY -> SuggestedTypeMessage.ADM_DIV_COUNTRY
    SuggestedType.ADM_DIV_DISTRICT -> SuggestedTypeMessage.ADM_DIV_DISTRICT
    SuggestedType.ADM_DIV_DISTRICT_AREA -> SuggestedTypeMessage.ADM_DIV_DISTRICT_AREA
    SuggestedType.ADM_DIV_DIVISION -> SuggestedTypeMessage.ADM_DIV_DIVISION
    SuggestedType.ADM_DIV_LIVING_AREA -> SuggestedTypeMessage.ADM_DIV_LIVING_AREA
    SuggestedType.ADM_DIV_PLACE -> SuggestedTypeMessage.ADM_DIV_PLACE
    SuggestedType.ADM_DIV_REGION -> SuggestedTypeMessage.ADM_DIV_REGION
    SuggestedType.ADM_DIV_SETTLEMENT -> SuggestedTypeMessage.ADM_DIV_SETTLEMENT
    SuggestedType.KILOMETER_ROAD_SIGN -> SuggestedTypeMessage.KILOMETER_ROAD_SIGN
    SuggestedType.MARKET_ATTRIBUTE -> SuggestedTypeMessage.MARKET_ATTRIBUTE
    SuggestedType.MARKET_BRAND -> SuggestedTypeMessage.MARKET_BRAND
    SuggestedType.MARKET_CATEGORY -> SuggestedTypeMessage.MARKET_CATEGORY
    SuggestedType.MARKET_SUGGESTOR_CATEGORY -> SuggestedTypeMessage.MARKET_SUGGESTOR_CATEGORY
    SuggestedType.META_RUBRIC -> SuggestedTypeMessage.META_RUBRIC
    SuggestedType.ROUTE_TYPE -> SuggestedTypeMessage.ROUTE_TYPE
    SuggestedType.RUBRIC -> SuggestedTypeMessage.RUBRIC
    SuggestedType.STATION_METRO -> SuggestedTypeMessage.STATION_METRO
}

fun SuggestedTypeMessage.toSuggestType(): SuggestedType = when(this) {
    SuggestedTypeMessage.ATTRACTION -> SuggestedType.ATTRACTION
    SuggestedTypeMessage.ATTRIBUTE -> SuggestedType.ATTRIBUTE
    SuggestedTypeMessage.BRANCH -> SuggestedType.BRANCH
    SuggestedTypeMessage.BUILDING -> SuggestedType.BUILDING
    SuggestedTypeMessage.COORDINATES -> SuggestedType.COORDINATES
    SuggestedTypeMessage.CROSSROAD -> SuggestedType.CROSSROAD
    SuggestedTypeMessage.ADM_DIV_DISTRICT_AREA -> SuggestedType.ADM_DIV_DISTRICT_AREA
    SuggestedTypeMessage.ORG -> SuggestedType.ORG
    SuggestedTypeMessage.PARKING -> SuggestedType.PARKING
    SuggestedTypeMessage.ADM_DIV_REGION -> SuggestedType.ADM_DIV_REGION
    SuggestedTypeMessage.ROAD -> SuggestedType.ROAD
    SuggestedTypeMessage.ROUTE -> SuggestedType.ROUTE
    SuggestedTypeMessage.STATION -> SuggestedType.STATION
    SuggestedTypeMessage.STATION_ENTRANCE -> SuggestedType.STATION_ENTRANCE
    SuggestedTypeMessage.STREET -> SuggestedType.STREET
    SuggestedTypeMessage.TEXT -> SuggestedType.TEXT
    SuggestedTypeMessage.UNKNOWN -> SuggestedType.UNKNOWN
    SuggestedTypeMessage.ADM_DIV_CITY -> SuggestedType.ADM_DIV_CITY
    SuggestedTypeMessage.ADM_DIV_COUNTRY -> SuggestedType.ADM_DIV_COUNTRY
    SuggestedTypeMessage.ADM_DIV_DISTRICT -> SuggestedType.ADM_DIV_DISTRICT
    SuggestedTypeMessage.ADM_DIV_DISTRICT_AREA -> SuggestedType.ADM_DIV_DISTRICT_AREA
    SuggestedTypeMessage.ADM_DIV_DIVISION -> SuggestedType.ADM_DIV_DIVISION
    SuggestedTypeMessage.ADM_DIV_LIVING_AREA -> SuggestedType.ADM_DIV_LIVING_AREA
    SuggestedTypeMessage.ADM_DIV_PLACE -> SuggestedType.ADM_DIV_PLACE
    SuggestedTypeMessage.ADM_DIV_REGION -> SuggestedType.ADM_DIV_REGION
    SuggestedTypeMessage.ADM_DIV_SETTLEMENT -> SuggestedType.ADM_DIV_SETTLEMENT
    SuggestedTypeMessage.KILOMETER_ROAD_SIGN -> SuggestedType.KILOMETER_ROAD_SIGN
    SuggestedTypeMessage.MARKET_ATTRIBUTE -> SuggestedType.MARKET_ATTRIBUTE
    SuggestedTypeMessage.MARKET_BRAND -> SuggestedType.MARKET_BRAND
    SuggestedTypeMessage.MARKET_CATEGORY -> SuggestedType.MARKET_CATEGORY
    SuggestedTypeMessage.MARKET_SUGGESTOR_CATEGORY -> SuggestedType.MARKET_SUGGESTOR_CATEGORY
    SuggestedTypeMessage.META_RUBRIC -> SuggestedType.META_RUBRIC
    SuggestedTypeMessage.ROUTE_TYPE -> SuggestedType.ROUTE_TYPE
    SuggestedTypeMessage.RUBRIC -> SuggestedType.RUBRIC
    SuggestedTypeMessage.STATION_METRO -> SuggestedType.STATION_METRO
}

fun SuggestorTypeEnum.toSuggestType(): SuggestorType = when(this) {
    SuggestorTypeEnum.ADDRESS -> SuggestorType.ADDRESS
    SuggestorTypeEnum.CITY_SELECTOR -> SuggestorType.CITY_SELECTOR
    SuggestorTypeEnum.OBJECT -> SuggestorType.OBJECT
    SuggestorTypeEnum.PLACES -> SuggestorType.PLACES
    SuggestorTypeEnum.ROUTE_ENDPOINT -> SuggestorType.ROUTE_ENDPOINT
    SuggestorTypeEnum.RUBRIC -> SuggestorType.RUBRIC
}

fun MarkedUpText.toMessage(): MarkedUpTextMessage {
    return MarkedUpTextMessage(
        text = this.text,
        matchedParts = this.matchedParts.map {
            it.toMessage()
        }
    )
}

fun MarkedUpTextSpan.toMessage(): MarkedUpTextSpanMessage {
    return MarkedUpTextSpanMessage(
        offset = this.offset,
        length = this.length
    )
}