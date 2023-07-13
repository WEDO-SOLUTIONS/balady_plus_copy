package com.dgis.map.extensions

import com.dgis.map.map_api.Messages
import com.dgis.map.map_api.Messages.SuggestMessage
import ru.dgis.sdk.directory.Suggest

fun mapSuggestToMessage(index: Int, suggest: Suggest): SuggestMessage {
    val builder = SuggestMessage.Builder()
        .setTitle(suggest.title.text)
        .setSubTitle(suggest.subtitle.text)
        .setIndex(index.toLong())

    when {
        suggest.handler.isObjectHandler ->
            builder.setHandler(Messages.SuggestHandlerMessage.OBJECT)
        suggest.handler.isIncompleteTextHandler ->
            builder.setHandler(Messages.SuggestHandlerMessage.INCOMPLETE)
        suggest.handler.isPerformSearchHandler ->
            builder.setHandler(Messages.SuggestHandlerMessage.SEARCH)
    }

    return builder.build()
}