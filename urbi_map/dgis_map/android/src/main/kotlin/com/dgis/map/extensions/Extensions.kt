package com.dgis.map.extensions

import com.dgis.map.map_api.Messages
import ru.dgis.sdk.DayTime
import ru.dgis.sdk.WeekDay
import ru.dgis.sdk.WeekTime
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.directory.IsOpenNow
import ru.dgis.sdk.directory.SortingType
import ru.dgis.sdk.directory.WorkTimeFilter

fun Messages.SortingTypeMessage.toSortingType() = when (this) {
    Messages.SortingTypeMessage.BY_RELEVANCE -> SortingType.BY_RELEVANCE
    Messages.SortingTypeMessage.BY_DISTANCE -> SortingType.BY_DISTANCE
    Messages.SortingTypeMessage.BY_RATING -> SortingType.BY_RATING
}

fun Messages.WeekTimeSearchMessage?.toFilter(): WorkTimeFilter? {
    if (this?.isOpenNow == true) return WorkTimeFilter(IsOpenNow())

    val weekDay = this?.weekDay
    val time = this?.time
    if (weekDay != null && time != null) {
        return WorkTimeFilter(
            WeekTime(
                weekDay = weekDay.toWeekDay(),
                time = DayTime(
                    hours = time.hours.toByte(),
                    minutes = time.minutes.toByte(),
                )
            )
        )
    }

    return null
}

private fun Messages.WeekDayMessage.toWeekDay() = when (this) {
    Messages.WeekDayMessage.MONDAY -> WeekDay.MONDAY
    Messages.WeekDayMessage.TUESDAY -> WeekDay.TUESDAY
    Messages.WeekDayMessage.WEDNESDAY -> WeekDay.WEDNESDAY
    Messages.WeekDayMessage.THURSDAY -> WeekDay.THURSDAY
    Messages.WeekDayMessage.FRIDAY -> WeekDay.FRIDAY
    Messages.WeekDayMessage.SATURDAY -> WeekDay.SATURDAY
    Messages.WeekDayMessage.SUNDAY -> WeekDay.SUNDAY
}