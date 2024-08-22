package com.dgis.map.extensions

import com.dgis.map.map_api.Messages.*
import ru.dgis.sdk.*
import ru.dgis.sdk.directory.*

fun DirectoryObject.toMessage(): DirectoryObjectMessage {
    return DirectoryObjectMessage.Builder()
        .setTypes(this.types.map {
            ObjectTypeItemMessage.Builder()
                .setType(it.toMessage())
                .build()
        })
        .setTitle(this.title)
        .setTitleAddition(this.titleAddition)
        .setSubtitle(this.subtitle)
        .setAbout(this.description)
        .setId(this.id?.toMessage())
        .setMarkerPosition(this.markerPosition?.toMessage())
        .setAddress(this.address?.toMessage())
        .setFullAddressName(this.formattedAddress(FormattingType.FULL)?.toMessage())
        .setShortAddressName(this.formattedAddress(FormattingType.SHORT)?.toMessage())
        .setAttributes(this.attributes.map {
            it.toMessage()
        })
        .setContextAttributes(this.contextAttributes.map {
            it.toMessage()
        })
        .setTimeZoneOffset(this.timeZoneOffset?.let { it.inMilliseconds.toDouble() / 60.0 })
        .setOpeningHours(this.openingHours?.toMessage())
        .setContactInfos(this.contactInfos.map {
            it.toMessage()
        })
        .setReviews(this.reviews?.toMessage())
        .setParkingInfo(this.parkingInfo?.toMessage())
        .setWorkStatus(this.workStatus?.toMessage())
        .setLevelId(this.levelId?.value)
        .setBuildingLevels(this.buildingLevels?.toMessage())
        .setBuildingInfo(this.buildingInfo.toMessage())
        .setEntrances(this.entrances.map {
            it.toMessage()
        })
        .setTradeLicense(this.tradeLicense?.toMessage())
        .build()
}

fun ObjectType.toMessage(): ObjectTypeMessage = when (this) {
    ObjectType.ADM_DIV -> ObjectTypeMessage.ADM_DIV
    ObjectType.ATTRACTION -> ObjectTypeMessage.ATTRACTION
    ObjectType.BRANCH -> ObjectTypeMessage.BRANCH
    ObjectType.BUILDING -> ObjectTypeMessage.BUILDING
    ObjectType.COORDINATES -> ObjectTypeMessage.COORDINATES
    ObjectType.CROSSROAD -> ObjectTypeMessage.CROSSROAD
    ObjectType.PARKING -> ObjectTypeMessage.PARKING
    ObjectType.ROAD -> ObjectTypeMessage.ROAD
    ObjectType.ROUTE -> ObjectTypeMessage.ROUTE
    ObjectType.STATION -> ObjectTypeMessage.STATION
    ObjectType.STATION_ENTRANCE -> ObjectTypeMessage.STATION_ENTRANCE
    ObjectType.STREET -> ObjectTypeMessage.STREET
    ObjectType.UNKNOWN -> ObjectTypeMessage.UNKNOWN
    ObjectType.ADM_DIV_CITY -> ObjectTypeMessage.ADM_DIV_CITY
    ObjectType.ADM_DIV_COUNTRY -> ObjectTypeMessage.ADM_DIV_COUNTRY
    ObjectType.ADM_DIV_DISTRICT -> ObjectTypeMessage.ADM_DIV_DISTRICT
    ObjectType.ADM_DIV_DISTRICT_AREA -> ObjectTypeMessage.ADM_DIV_DISTRICT_AREA
    ObjectType.ADM_DIV_DIVISION -> ObjectTypeMessage.ADM_DIV_DIVISION
    ObjectType.ADM_DIV_LIVING_AREA -> ObjectTypeMessage.ADM_DIV_LIVING_AREA
    ObjectType.ADM_DIV_PLACE -> ObjectTypeMessage.ADM_DIV_PLACE
    ObjectType.ADM_DIV_REGION -> ObjectTypeMessage.ADM_DIV_REGION
    ObjectType.ADM_DIV_SETTLEMENT -> ObjectTypeMessage.ADM_DIV_SETTLEMENT
    ObjectType.GATE -> ObjectTypeMessage.GATE
    ObjectType.KILOMETER_ROAD_SIGN -> ObjectTypeMessage.KILOMETER_ROAD_SIGN
    ObjectType.STATION_METRO -> ObjectTypeMessage.STATION_METRO
    ObjectType.STATION_PLATFORM -> ObjectTypeMessage.STATION_PLATFORM
}

fun DgisObjectId.toMessage(): DgisObjectIdMessage {
    return DgisObjectIdMessage.Builder()
        .setObjectId(this.objectId)
        .setEntranceId(this.entranceId)
        .build()
}

fun Address.toMessage(): AddressMessage {
    return AddressMessage.Builder()
        .setDrilldown(this.drillDown.map {
            it.toMessage()
        })
        .setComponents(this.components.map {
            it.toMessage()
        })
        .setBuildingName(this.buildingName)
        .setPostCode(this.postCode)
        .setBuildingCode(this.buildingCode)
        .setAddressComment(this.addressComment)
        .build()
}

fun FormattedAddress.toMessage(): FormattedAddressMessage {
    return FormattedAddressMessage.Builder()
        .setDrilldownAddress(this.drilldownAddress)
        .setStreetAddress(this.streetAddress)
        .setAddressComment(this.addressComment)
        .setPostCode(this.postCode)
        .build()
}

fun AddressAdmDiv.toMessage(): AddressAdmDivMessage {
    return AddressAdmDivMessage.Builder()
        .setType(this.type)
        .setName(this.name)
        .build()
}

fun AddressNumber.toMessage(): AddressNumberMessage {
    return AddressNumberMessage.Builder()
        .setNumber(this.number)
        .build()
}

fun AddressStreet.toMessage(): AddressStreetMessage {
    return AddressStreetMessage.Builder()
        .setStreet(this.street)
        .setNumber(this.number)
        .build()
}

fun AddressLocation.toMessage(): AddressLocationMessage {
    return AddressLocationMessage.Builder()
        .setComment(this.comment)
        .build()
}

fun AddressComponent.toMessage(): AddressComponentMessage {
    return AddressComponentMessage.Builder()
        .setLocation(this.asLocation?.toMessage())
        .setStreetAddress(this.asStreetAddress?.toMessage())
        .setNumber(this.asNumber?.toMessage())
        .build()
}

fun Attribute.toMessage(): AttributeMessage {
    return AttributeMessage.Builder()
        .setTag(this.tag)
        .setValue(this.value)
        .build()
}

fun OpeningHours.toMessage(): OpeningHoursMessage {
    return OpeningHoursMessage.Builder()
        .setValues(this.weekOpeningHours.map { weekTimeIntervals ->
            WeekTimeIntervalListMessage.Builder()
                .setValues(weekTimeIntervals.map {
                    it.toMessage()
                })
                .build()
        })
        .setIsOpen24x7(this.isOpen24x7)
        .build()
}

fun WeekTimeInterval.toMessage(): WeekTimeIntervalMessage {
    return WeekTimeIntervalMessage.Builder()
        .setStartTime(this.startTime.toMessage())
        .setFinishTime(this.finishTime.toMessage())
        .build()
}

fun WeekTime.toMessage(): WeekTimeMessage {
    return WeekTimeMessage.Builder()
        .setWeekDay(this.weekDay.toMessage())
        .setTime(this.time.toMessage())
        .build()
}

fun WeekDay.toMessage(): WeekDayMessage = when(this) {
    WeekDay.SUNDAY -> WeekDayMessage.SUNDAY
    WeekDay.MONDAY -> WeekDayMessage.MONDAY
    WeekDay.TUESDAY -> WeekDayMessage.TUESDAY
    WeekDay.WEDNESDAY -> WeekDayMessage.WEDNESDAY
    WeekDay.THURSDAY -> WeekDayMessage.THURSDAY
    WeekDay.FRIDAY -> WeekDayMessage.FRIDAY
    WeekDay.SATURDAY -> WeekDayMessage.SATURDAY
}

fun DayTime.toMessage(): DayTimeMessage {
    return DayTimeMessage.Builder()
        .setHours(this.hours.toLong())
        .setMinutes(this.minutes.toLong())
        .build()
}

fun ContactInfo.toMessage(): ContactInfoMessage {
    return ContactInfoMessage.Builder()
        .setType(this.type)
        .setDisplayText(this.displayText)
        .setValue(this.value)
        .setComment(this.comment)
        .build()
}

fun Reviews.toMessage(): ReviewsMessage {
    return ReviewsMessage.Builder()
        .setCount(this.count.toLong())
        .setRating(this.rating.toDouble())
        .build()
}

fun ParkingInfo.toMessage(): ParkingInfoMessage {
    return ParkingInfoMessage.Builder()
        .setType(this.type?.toMessage() ?: ParkingTypeMessage.NONE)
        .setPurpose(this.purpose.toMessage())
        .setAccess(this.access.toMessage())
        .setPavingType(this.pavingType?.toMessage() ?: ParkingPavingTypeMessage.NONE)
        .setIsPaid(this.isPaid)
        .setIsIncentive(this.isIncentive)
        .setForTrucks(this.forTrucks)
        .setLevelCount(this.levelCount?.toLong())
        .setCapacity(this.capacity?.toMessage())
        .build()
}

fun ParkingType.toMessage() = when(this) {
    ParkingType.GROUND -> ParkingTypeMessage.GROUND
    ParkingType.UNDERGROUND -> ParkingTypeMessage.UNDERGROUND
    ParkingType.MULTILEVEL -> ParkingTypeMessage.MULTILEVEL
}

fun ParkingPurpose.toMessage(): ParkingPurposeMessage = when(this) {
    ParkingPurpose.CAR -> ParkingPurposeMessage.CAR
    ParkingPurpose.BIKE -> ParkingPurposeMessage.BIKE
    ParkingPurpose.MOTORBIKE -> ParkingPurposeMessage.MOTORBIKE
    ParkingPurpose.BABY_CARRIAGE -> ParkingPurposeMessage.BABY_CARRIAGE
    ParkingPurpose.SCOOTER -> ParkingPurposeMessage.SCOOTER
}

fun ParkingAccess.toMessage(): ParkingAccessMessage = when(this) {
    ParkingAccess.PUBLIC -> ParkingAccessMessage.PUBLIC
    ParkingAccess.HANDICAPPED_ONLY -> ParkingAccessMessage.HANDICAPPED_ONLY
    ParkingAccess.CUSTOMERS_ONLY -> ParkingAccessMessage.CUSTOMERS_ONLY
    ParkingAccess.RESIDENTS_ONLY -> ParkingAccessMessage.RESIDENTS_ONLY
    ParkingAccess.TAXI_ONLY -> ParkingAccessMessage.TAXI_ONLY
}

fun ParkingPavingType.toMessage(): ParkingPavingTypeMessage = when(this) {
    ParkingPavingType.ASPHALT -> ParkingPavingTypeMessage.ASPHALT
    ParkingPavingType.CONCRETE -> ParkingPavingTypeMessage.CONCRETE
    ParkingPavingType.GRAVEL -> ParkingPavingTypeMessage.GRAVEL
    ParkingPavingType.UNPAVED -> ParkingPavingTypeMessage.UNPAVED
}

fun ParkingCapacity.toMessage(): ParkingCapacityMessage {
    return ParkingCapacityMessage.Builder()
        .setTotal(this.total)
        .setSpecialSpaces(this.specialSpaces.map {
            it.toMessage()
        })
        .build()
}

fun SpecialSpace.toMessage(): SpecialSpaceMessage {
    return SpecialSpaceMessage.Builder()
        .setType(this.type.toMessage())
        .setName(this.name)
        .setCount(this.count)
        .build()
}

fun SpecialSpaceType.toMessage(): SpecialSpaceTypeMessage = when(this) {
    SpecialSpaceType.BICYCLE -> SpecialSpaceTypeMessage.BICYCLE
    SpecialSpaceType.MOTORBIKE -> SpecialSpaceTypeMessage.MOTORBIKE
    SpecialSpaceType.FAMILY -> SpecialSpaceTypeMessage.FAMILY
    SpecialSpaceType.HANDICAPPED -> SpecialSpaceTypeMessage.HANDICAPPED
    SpecialSpaceType.BABY_CARRIAGE -> SpecialSpaceTypeMessage.BABY_CARRIAGE
    SpecialSpaceType.TRUCK -> SpecialSpaceTypeMessage.TRUCK
    SpecialSpaceType.SCOOTER -> SpecialSpaceTypeMessage.SCOOTER
}

fun WorkStatus.toMessage(): WorkStatusMessage {
    return WorkStatusMessage.Builder()
        .setIsOpen(this.isOpen)
        .setDesc(this.description)
        .build()
}

fun BuildingLevels.toMessage(): BuildingLevelsMessage {
    return BuildingLevelsMessage.Builder()
        .setDefaultLevelId(this.defaultLevelId.value)
        .setLevels(this.levels.map {
            it.toMessage()
        })
        .build()
}

fun BuildingInfo.toMessage(): BuildingInfoMessage {
    return BuildingInfoMessage.Builder()
            .setBuildingName(this.buildingName)
            .setPurposeName(this.purposeName)
            .setPurposeCode(this.purposeCode?.let {
                it.value
            })
            .build()
}

fun LevelInfo.toMessage(): LevelInfoMessage {
    return LevelInfoMessage.Builder()
        .setId(this.id.value)
        .setName(this.name)
        .build()
}

fun EntranceInfo.toMessage(): EntranceInfoMessage {
    return EntranceInfoMessage.Builder()
        .setId(this.id.toMessage())
        .setBuildingNumber(this.buildingNumber)
        .setPorchName(this.porchName)
        .setPorchNumber(this.porchNumber)
        .setApartmentRanges(this.apartmentRanges.map {
            it.toMessage()
        })
        .setGeometry(this.geometry?.toMessage())
        .build()
}

fun ApartmentRange.toMessage(): ApartmentRangeMessage {
    return ApartmentRangeMessage.Builder()
        .setStart(this.start)
        .setEnd(this.end)
        .build()
}

fun EntranceGeometry.toMessage(): EntranceGeometryMessage {
    return EntranceGeometryMessage.Builder()
        .setEntrancePoints(this.entrancePoints.map {
            it.toMessage()
        })
        .setEntrancePolylines(this.entrancePolylines.map { polyline ->
            polyline.map {
                it.toMessage()
            }
        })
        .build()
}

fun TradeLicense.toMessage(): TradeLicenseMessage {
    return TradeLicenseMessage.Builder()
        .setType(this.type)
        .setLegalForm(this.legalForm)
        .setLicense(this.license)
        .setEndDate(this.endDate)
        .build()
}
