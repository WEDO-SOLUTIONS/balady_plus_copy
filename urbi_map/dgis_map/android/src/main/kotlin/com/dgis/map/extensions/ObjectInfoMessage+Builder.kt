package com.dgis.map.extensions

import com.dgis.map.map_api.Messages
import com.dgis.map.map_api.Messages.ObjectTypeMessage
import ru.dgis.sdk.WeekDay
import ru.dgis.sdk.directory.DirectoryObject
import ru.dgis.sdk.directory.FormattingType
import ru.dgis.sdk.directory.ObjectType

fun DirectoryObject.toMessage(): Messages.ObjectInfoMessage {
    val builder = Messages.ObjectInfoMessage.Builder()
        .setTitle(this.title)
        .setSubtitle(this.subtitle)
        .apply {
            buildReviews(this@toMessage)
            buildAddress(this@toMessage)
            buildWorkStatus(this@toMessage)
            buildOpeningHours(this@toMessage)
            buildMarkerPosition(this@toMessage)
            buildEntraceIds(this@toMessage)
            setType(this@toMessage.types[0].toMessage())
        }

    this.id?.let {
        builder.setDgisObjectId(
            Messages.DgisObjectIdMessage.Builder()
                .setObjectId(it.objectId)
                .setEntranceId(it.entranceId)
                .build()
        )
    }

    this.markerPosition?.let {
        builder.setMarkerPosition(
            Messages.MarkerPositionMessage.Builder()
                .setPoint(
                    Messages.GeoPointMessage.Builder()
                        .setLatitude(it.latitude.value)
                        .setLongitude(it.longitude.value)
                        .build()
                )
                .setElevation(it.elevation.value.toDouble())
                .build()
        )
    }

    builder.buildOpeningHours(this)

    return builder.build()
}

private fun ObjectType.toMessage(): ObjectTypeMessage {
    return if (this == ObjectType.BRANCH) ObjectTypeMessage.BRANCH else ObjectTypeMessage.OTHER;
}

private fun Messages.ObjectInfoMessage.Builder.buildReviews(response: DirectoryObject) {
    val reviews = response.reviews ?: return

    this.setReviews(
        Messages.ReviewsMessage.Builder()
            .setCount(reviews.count.toLong())
            .setRating(reviews.rating.toDouble())
            .build()
    )
}

private fun Messages.ObjectInfoMessage.Builder.buildAddress(response: DirectoryObject) {
    val fullAddress = response.formattedAddress(FormattingType.FULL)
    val address = response.address
    val addressBuilder = Messages.AddressMessage.Builder()

    if (fullAddress != null)
        addressBuilder.setAddressComment(fullAddress.addressComment)
            .setPostCode(fullAddress.postCode)
            .setStreetAddress(fullAddress.streetAddress)
            .setDrilldownString(fullAddress.drilldownAddress)

    if (address != null)
        addressBuilder.setDrilldown(address.drillDown.map {
            Messages.AdmDivMessage.Builder()
                .setName(it.name)
                .setType(it.type)
                .build()
        })

    this.setAddress(addressBuilder.build())
}

private fun Messages.ObjectInfoMessage.Builder.buildWorkStatus(response: DirectoryObject) {
    val description = response.workStatus?.description
    val isOpen = response.workStatus?.isOpen
    val workStatusBuilder = Messages.WorkStatusMessage.Builder()

    if (isOpen != null) workStatusBuilder.setIsOpen(isOpen)

    if (description != null) workStatusBuilder.setDesc(description)

    this.setWorkStatus(workStatusBuilder.build())
}

private fun Messages.ObjectInfoMessage.Builder.buildOpeningHours(response: DirectoryObject) {
    buildOpeningHoursMessage(response)?.let(this::setOpeningHours)
}

private fun Messages.ObjectInfoMessage.Builder.buildMarkerPosition(response: DirectoryObject) {
    response.markerPosition?.let { marker ->
        this.setMarkerPosition(
            Messages.MarkerPositionMessage.Builder()
                .setPoint(
                    Messages.GeoPointMessage.Builder()
                        .setLatitude(marker.latitude.value)
                        .setLongitude(marker.longitude.value)
                        .build()
                )
                .setElevation(marker.elevation.value.toDouble())
                .build()
        )
    }
}

private fun Messages.ObjectInfoMessage.Builder.buildEntraceIds(response: DirectoryObject) {
    this.setEntranceIds(
        response.entrances.map {
            Messages.DgisObjectIdMessage.Builder()
                .setObjectId(it.id.objectId)
                .setEntranceId(it.id.entranceId)
                .build()
        }
    )
}

private fun buildOpeningHoursMessage(response: DirectoryObject): Messages.OpeningHoursMessage? {
    val openingHours = response.openingHours ?: return null

    val map = openingHours.weekOpeningHours.map { intervalList ->
        Messages.WeekTimeIntervalListMessage.Builder()
            .setValues(intervalList.map { interval ->
                val startTime = Messages.WeekTimeMessage.Builder()
                    .setWeekDay(interval.startTime.weekDay.toMessage())
                    .setTime(
                        Messages.DayTimeMessage.Builder()
                            .setHours(interval.startTime.time.hours.toLong())
                            .setMinutes(interval.startTime.time.minutes.toLong())
                            .build()
                    )
                val finishTime = Messages.WeekTimeMessage.Builder()
                    .setWeekDay(interval.finishTime.weekDay.toMessage())
                    .setTime(
                        Messages.DayTimeMessage.Builder()
                            .setHours(interval.finishTime.time.hours.toLong())
                            .setMinutes(interval.finishTime.time.minutes.toLong())
                            .build()
                    )
                Messages.WeekTimeIntervalMessage.Builder()
                    .setStartTime(startTime.build())
                    .setFinishTime(finishTime.build())
                    .build()
            })
            .build()
    }

    return Messages.OpeningHoursMessage.Builder()
        .setValues(map.toMutableList())
        .setIsOpen24x7(openingHours.isOpen24x7)
        .build()

}

private fun WeekDay.toMessage() = when (this) {
    WeekDay.SUNDAY -> Messages.WeekDayMessage.SUNDAY
    WeekDay.MONDAY -> Messages.WeekDayMessage.MONDAY
    WeekDay.TUESDAY -> Messages.WeekDayMessage.TUESDAY
    WeekDay.WEDNESDAY -> Messages.WeekDayMessage.WEDNESDAY
    WeekDay.THURSDAY -> Messages.WeekDayMessage.THURSDAY
    WeekDay.FRIDAY -> Messages.WeekDayMessage.FRIDAY
    WeekDay.SATURDAY -> Messages.WeekDayMessage.SATURDAY
}
