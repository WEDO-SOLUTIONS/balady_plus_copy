package com.dgis.map.extensions

import com.dgis.map.map_api.*
import ru.dgis.sdk.DayTime
import ru.dgis.sdk.WeekDay
import ru.dgis.sdk.WeekTime
import ru.dgis.sdk.coordinates.GeoPoint
import ru.dgis.sdk.directory.IsOpenNow
import ru.dgis.sdk.directory.SortingType
import ru.dgis.sdk.directory.WorkTimeFilter

fun SortingTypeMessage.toSortingType() = when (this) {
    SortingTypeMessage.BY_RELEVANCE -> SortingType.BY_RELEVANCE
    SortingTypeMessage.BY_DISTANCE -> SortingType.BY_DISTANCE
    SortingTypeMessage.BY_RATING -> SortingType.BY_RATING
}

fun WeekTimeSearchMessage?.toFilter(): WorkTimeFilter? {
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

private fun WeekDayMessage.toWeekDay() = when (this) {
    WeekDayMessage.MONDAY -> WeekDay.MONDAY
    WeekDayMessage.TUESDAY -> WeekDay.TUESDAY
    WeekDayMessage.WEDNESDAY -> WeekDay.WEDNESDAY
    WeekDayMessage.THURSDAY -> WeekDay.THURSDAY
    WeekDayMessage.FRIDAY -> WeekDay.FRIDAY
    WeekDayMessage.SATURDAY -> WeekDay.SATURDAY
    WeekDayMessage.SUNDAY -> WeekDay.SUNDAY
}