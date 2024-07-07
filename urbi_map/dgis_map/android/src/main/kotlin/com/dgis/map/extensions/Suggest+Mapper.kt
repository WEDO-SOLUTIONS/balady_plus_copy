package com.dgis.map.extensions

import com.dgis.map.map_api.Messages.*
import ru.dgis.sdk.*
import ru.dgis.sdk.directory.*

fun Suggest.toMessage(searchQueryId: String?): SuggestMessage {
    return SuggestMessage.Builder()
        .setHandler(this.handler.toMessage(searchQueryId))
        .setSuggestedType(this.suggestedType.toMessage())
        .setTitle(this.title.toMessage())
        .setSubtitle(this.subtitle.toMessage())
        .build()
}

fun SuggestHandler.toMessage(searchQueryId: String?): SuggestHandlerMessage {
    return SuggestHandlerMessage.Builder()
        .setObjectHandler(
            this.asObjectHandler?.let {
                SuggestObjectHandlerMessage.Builder()
                    .setItem(it.item.toMessage())
                    .build()
            }
        )
        .setIncompleteTextHandler(
            this.asIncompleteTextHandler?.let {
                IncompleteTextHandlerMessage.Builder()
                    .setQueryText(it.queryText)
                    .build()
            }
        )
        .setPerformSearchHandler(
            this.asPerformSearchHandler?.let {
                PerformSearchHandlerMessage.Builder()
                    .setSearchQuery(
                        SearchQueryMessage.Builder()
                            .setId(searchQueryId!!)
                            .build()
                    )
                    .build()
            }
        )
        .build()
}

fun SuggestedType.toMessage(): SuggestedTypeMessage = when(this) {
    SuggestedType.ADM_DIV -> SuggestedTypeMessage.ADM_DIV
    SuggestedType.ATTRACTION -> SuggestedTypeMessage.ATTRACTION
    SuggestedType.ATTRIBUTE -> SuggestedTypeMessage.ATTRIBUTE
    SuggestedType.BRANCH -> SuggestedTypeMessage.BRANCH
    SuggestedType.BUILDING -> SuggestedTypeMessage.BUILDING
    SuggestedType.COORDINATES -> SuggestedTypeMessage.COORDINATES
    SuggestedType.CROSSROAD -> SuggestedTypeMessage.CROSSROAD
    SuggestedType.DISTRICT_AREA -> SuggestedTypeMessage.DISTRICT_AREA
    SuggestedType.ORG -> SuggestedTypeMessage.ORG
    SuggestedType.ORG_CATEGORY -> SuggestedTypeMessage.ORG_CATEGORY
    SuggestedType.PARKING -> SuggestedTypeMessage.PARKING
    SuggestedType.REGION -> SuggestedTypeMessage.REGION
    SuggestedType.ROAD -> SuggestedTypeMessage.ROAD
    SuggestedType.ROUTE -> SuggestedTypeMessage.ROUTE
    SuggestedType.STATION -> SuggestedTypeMessage.STATION
    SuggestedType.STATION_ENTRANCE -> SuggestedTypeMessage.STATION_ENTRANCE
    SuggestedType.STREET -> SuggestedTypeMessage.STREET
    SuggestedType.TEXT -> SuggestedTypeMessage.TEXT
    SuggestedType.UNKNOWN -> SuggestedTypeMessage.UNKNOWN
}

fun SuggestedTypeMessage.toSuggestType(): SuggestedType = when(this) {
    SuggestedTypeMessage.ADM_DIV -> SuggestedType.ADM_DIV
    SuggestedTypeMessage.ATTRACTION -> SuggestedType.ATTRACTION
    SuggestedTypeMessage.ATTRIBUTE -> SuggestedType.ATTRIBUTE
    SuggestedTypeMessage.BRANCH -> SuggestedType.BRANCH
    SuggestedTypeMessage.BUILDING -> SuggestedType.BUILDING
    SuggestedTypeMessage.COORDINATES -> SuggestedType.COORDINATES
    SuggestedTypeMessage.CROSSROAD -> SuggestedType.CROSSROAD
    SuggestedTypeMessage.DISTRICT_AREA -> SuggestedType.DISTRICT_AREA
    SuggestedTypeMessage.ORG -> SuggestedType.ORG
    SuggestedTypeMessage.ORG_CATEGORY -> SuggestedType.ORG_CATEGORY
    SuggestedTypeMessage.PARKING -> SuggestedType.PARKING
    SuggestedTypeMessage.REGION -> SuggestedType.REGION
    SuggestedTypeMessage.ROAD -> SuggestedType.ROAD
    SuggestedTypeMessage.ROUTE -> SuggestedType.ROUTE
    SuggestedTypeMessage.STATION -> SuggestedType.STATION
    SuggestedTypeMessage.STATION_ENTRANCE -> SuggestedType.STATION_ENTRANCE
    SuggestedTypeMessage.STREET -> SuggestedType.STREET
    SuggestedTypeMessage.TEXT -> SuggestedType.TEXT
    SuggestedTypeMessage.UNKNOWN -> SuggestedType.UNKNOWN
}

fun MarkedUpText.toMessage(): MarkedUpTextMessage {
    return MarkedUpTextMessage.Builder()
        .setText(this.text)
        .setMatchedParts(this.matchedParts.map {
            it.toMessage()
        })
        .build()
}

fun MarkedUpTextSpan.toMessage(): MarkedUpTextSpanMessage {
    return MarkedUpTextSpanMessage.Builder()
        .setOffset(this.offset)
        .setLength(this.length)
        .build()
}
