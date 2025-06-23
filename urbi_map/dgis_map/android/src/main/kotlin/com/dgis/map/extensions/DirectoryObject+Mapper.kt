package com.dgis.map.extensions

import com.dgis.map.map_api.*
import ru.dgis.sdk.*
import ru.dgis.sdk.directory.*
import ru.dgis.sdk.geometry.*

fun DirectoryObject.toMessage(): DirectoryObjectMessage {
    return DirectoryObjectMessage(
            types = this.types.map { ObjectTypeItemMessage(type = it.toMessage()) },
            title = this.title,
            titleAddition = this.titleAddition,
            subtitle = this.subtitle,
            about = this.description,
            id = this.id?.toMessage(),
            markerPosition = this.markerPosition?.toMessage(),
            address = this.address?.toMessage(),
            fullAddressName = this.formattedAddress(FormattingType.FULL)?.toMessage(),
            shortAddressName = this.formattedAddress(FormattingType.SHORT)?.toMessage(),
            attributes = this.attributes.map { it.toMessage() },
            contextAttributes = this.contextAttributes.map { it.toMessage() },
            timeZoneOffset = this.timeZoneOffset?.let { it.inMilliseconds.toDouble() / 60.0 },
            openingHours = this.openingHours?.toMessage(),
            contactInfos = this.contactInfos.map { it.toMessage() },
            reviews = this.reviews?.toMessage(),
            parkingInfo = this.parkingInfo?.toMessage(),
            workStatus = this.workStatus?.toMessage(),
            levelId = this.levelId?.value,
            buildingLevels = this.buildingLevels?.toMessage(),
            buildingInfo = this.buildingInfo.toMessage(),
            entrances = this.entrances.map { it.toMessage() },
            tradeLicense = this.tradeLicense?.toMessage(),
            rubricIds = this.rubricIds.map { it.value },
            routeInfos = this.routeInfos.map { it.toMessage() },
            group = this.group.map { it.toMessage() }
    )
}

fun DgisObjectId.toMessage(): DgisObjectIdMessage {
    return DgisObjectIdMessage(objectId = this.objectId, entranceId = this.entranceId)
}

fun Address.toMessage(): AddressMessage {
    return AddressMessage(
            drilldown = this.drillDown.map { it.toMessage() },
            components = this.components.map { it.toMessage() },
            buildingName = this.buildingName,
            postCode = this.postCode,
            buildingCode = this.buildingCode,
            addressComment = this.addressComment
    )
}

fun FormattedAddress.toMessage(): FormattedAddressMessage {
    return FormattedAddressMessage(
            drilldownAddress = this.drilldownAddress,
            streetAddress = this.streetAddress,
            addressComment = this.addressComment,
            postCode = this.postCode
    )
}

fun AddressAdmDiv.toMessage(): AddressAdmDivMessage {
    return AddressAdmDivMessage(type = this.type, name = this.name)
}

fun AddressNumber.toMessage(): AddressNumberMessage {
    return AddressNumberMessage(number = this.number)
}

fun AddressStreet.toMessage(): AddressStreetMessage {
    return AddressStreetMessage(street = this.street, number = this.number)
}

fun AddressLocation.toMessage(): AddressLocationMessage {
    return AddressLocationMessage(comment = this.comment)
}

fun AddressComponent.toMessage(): AddressComponentMessage {
    return AddressComponentMessage(
            location = this.asLocation?.toMessage(),
            streetAddress = this.asStreetAddress?.toMessage(),
            number = this.asNumber?.toMessage()
    )
}

fun Attribute.toMessage(): AttributeMessage {
    return AttributeMessage(tag = this.tag, value = this.value)
}

fun OpeningHours.toMessage(): OpeningHoursMessage {
    return OpeningHoursMessage(
            values =
                    this.weekOpeningHours.map { weekTimeIntervals ->
                        WeekTimeIntervalListMessage(
                                values = weekTimeIntervals.map { it.toMessage() }
                        )
                    },
            isOpen24x7 = this.isOpen24x7
    )
}

fun WeekTimeInterval.toMessage(): WeekTimeIntervalMessage {
    return WeekTimeIntervalMessage(
            startTime = this.startTime.toMessage(),
            finishTime = this.finishTime.toMessage()
    )
}

fun WeekTime.toMessage(): WeekTimeMessage {
    return WeekTimeMessage(weekDay = this.weekDay.toMessage(), time = this.time.toMessage())
}

fun WeekDay.toMessage(): WeekDayMessage =
        when (this) {
            WeekDay.SUNDAY -> WeekDayMessage.SUNDAY
            WeekDay.MONDAY -> WeekDayMessage.MONDAY
            WeekDay.TUESDAY -> WeekDayMessage.TUESDAY
            WeekDay.WEDNESDAY -> WeekDayMessage.WEDNESDAY
            WeekDay.THURSDAY -> WeekDayMessage.THURSDAY
            WeekDay.FRIDAY -> WeekDayMessage.FRIDAY
            WeekDay.SATURDAY -> WeekDayMessage.SATURDAY
        }

fun DayTime.toMessage(): DayTimeMessage {
    return DayTimeMessage(hours = this.hours.toLong(), minutes = this.minutes.toLong())
}

fun ContactInfo.toMessage(): ContactInfoMessage {
    return ContactInfoMessage(
            type = this.type,
            displayText = this.displayText,
            value = this.value,
            comment = this.comment
    )
}

fun Reviews.toMessage(): ReviewsMessage {
    return ReviewsMessage(count = this.count.toLong(), rating = this.rating.toDouble())
}

fun ParkingInfo.toMessage(): ParkingInfoMessage {
    return ParkingInfoMessage(
            type = this.type?.toMessage() ?: ParkingTypeMessage.NONE,
            purpose = this.purpose.toMessage(),
            access = this.access.toMessage(),
            pavingType = this.pavingType?.toMessage() ?: ParkingPavingTypeMessage.NONE,
            isPaid = this.isPaid,
            isIncentive = this.isIncentive,
            forTrucks = this.forTrucks,
            levelCount = this.levelCount?.toLong(),
            capacity = this.capacity?.toMessage()
    )
}

fun ParkingType.toMessage() =
        when (this) {
            ParkingType.GROUND -> ParkingTypeMessage.GROUND
            ParkingType.UNDERGROUND -> ParkingTypeMessage.UNDERGROUND
            ParkingType.MULTILEVEL -> ParkingTypeMessage.MULTILEVEL
        }

fun ParkingPurpose.toMessage(): ParkingPurposeMessage =
        when (this) {
            ParkingPurpose.CAR -> ParkingPurposeMessage.CAR
            ParkingPurpose.BIKE -> ParkingPurposeMessage.BIKE
            ParkingPurpose.MOTORBIKE -> ParkingPurposeMessage.MOTORBIKE
            ParkingPurpose.BABY_CARRIAGE -> ParkingPurposeMessage.BABY_CARRIAGE
            ParkingPurpose.SCOOTER -> ParkingPurposeMessage.SCOOTER
        }

fun ParkingAccess.toMessage(): ParkingAccessMessage =
        when (this) {
            ParkingAccess.PUBLIC -> ParkingAccessMessage.PUBLIC_ACCESS
            ParkingAccess.HANDICAPPED_ONLY -> ParkingAccessMessage.HANDICAPPED_ONLY
            ParkingAccess.CUSTOMERS_ONLY -> ParkingAccessMessage.CUSTOMERS_ONLY
            ParkingAccess.RESIDENTS_ONLY -> ParkingAccessMessage.RESIDENTS_ONLY
            ParkingAccess.TAXI_ONLY -> ParkingAccessMessage.TAXI_ONLY
        }

fun ParkingPavingType.toMessage(): ParkingPavingTypeMessage =
        when (this) {
            ParkingPavingType.ASPHALT -> ParkingPavingTypeMessage.ASPHALT
            ParkingPavingType.CONCRETE -> ParkingPavingTypeMessage.CONCRETE
            ParkingPavingType.GRAVEL -> ParkingPavingTypeMessage.GRAVEL
            ParkingPavingType.UNPAVED -> ParkingPavingTypeMessage.UNPAVED
        }

fun ParkingCapacity.toMessage(): ParkingCapacityMessage {
    return ParkingCapacityMessage(
            total = this.total,
            specialSpaces = this.specialSpaces.map { it.toMessage() }
    )
}

fun SpecialSpace.toMessage(): SpecialSpaceMessage {
    return SpecialSpaceMessage(type = this.type.toMessage(), name = this.name, count = this.count)
}

fun SpecialSpaceType.toMessage(): SpecialSpaceTypeMessage =
        when (this) {
            SpecialSpaceType.BICYCLE -> SpecialSpaceTypeMessage.BICYCLE
            SpecialSpaceType.MOTORBIKE -> SpecialSpaceTypeMessage.MOTORBIKE
            SpecialSpaceType.FAMILY -> SpecialSpaceTypeMessage.FAMILY
            SpecialSpaceType.HANDICAPPED -> SpecialSpaceTypeMessage.HANDICAPPED
            SpecialSpaceType.BABY_CARRIAGE -> SpecialSpaceTypeMessage.BABY_CARRIAGE
            SpecialSpaceType.TRUCK -> SpecialSpaceTypeMessage.TRUCK
            SpecialSpaceType.SCOOTER -> SpecialSpaceTypeMessage.SCOOTER
        }

fun WorkStatus.toMessage(): WorkStatusMessage {
    return WorkStatusMessage(isOpen = this.isOpen, desc = this.description)
}

fun BuildingLevels.toMessage(): BuildingLevelsMessage {
    return BuildingLevelsMessage(
            defaultLevelId = this.defaultLevelId.value,
            levels = this.levels.map { it.toMessage() }
    )
}

fun BuildingInfo.toMessage(): BuildingInfoMessage {
    return BuildingInfoMessage(
            buildingName = this.buildingName,
            purposeName = this.purposeName,
            purposeCode = this.purposeCode?.let { it.value }
    )
}

fun LevelInfo.toMessage(): LevelInfoMessage {
    return LevelInfoMessage(id = this.id.value, name = this.name)
}

fun EntranceInfo.toMessage(): EntranceInfoMessage {
    return EntranceInfoMessage(
            id = this.id.toMessage(),
            buildingNumber = this.buildingNumber,
            porchName = this.porchName,
            porchNumber = this.porchNumber,
            apartmentRanges = this.apartmentRanges.map { it.toMessage() },
            geometry = this.geometry?.toMessage()
    )
}

fun ApartmentRange.toMessage(): ApartmentRangeMessage {
    return ApartmentRangeMessage(start = this.start, end = this.end)
}

fun EntranceGeometry.toMessage(): EntranceGeometryMessage {
    return EntranceGeometryMessage(
            entrancePoints = this.entrancePoints.map { it.toMessage() },
            entrancePolylines =
                    this.entrancePolylines.map { polyline -> polyline.map { it.toMessage() } }
    )
}

fun TradeLicense.toMessage(): TradeLicenseMessage {
    return TradeLicenseMessage(
            type = this.type,
            legalForm = this.legalForm,
            license = this.license,
            endDate = this.endDate
    )
}

fun ObjectType.toMessage(): ObjectTypeMessage {
    return when (this) {
        ObjectType.ADM_DIV -> ObjectTypeMessage.ADM_DIV
        ObjectType.ADM_DIV_CITY -> ObjectTypeMessage.ADM_DIV_CITY
        ObjectType.ADM_DIV_COUNTRY -> ObjectTypeMessage.ADM_DIV_COUNTRY
        ObjectType.ADM_DIV_DISTRICT -> ObjectTypeMessage.ADM_DIV_DISTRICT
        ObjectType.ADM_DIV_DISTRICT_AREA -> ObjectTypeMessage.ADM_DIV_DISTRICT_AREA
        ObjectType.ADM_DIV_DIVISION -> ObjectTypeMessage.ADM_DIV_DIVISION
        ObjectType.ADM_DIV_LIVING_AREA -> ObjectTypeMessage.ADM_DIV_LIVING_AREA
        ObjectType.ADM_DIV_PLACE -> ObjectTypeMessage.ADM_DIV_PLACE
        ObjectType.ADM_DIV_REGION -> ObjectTypeMessage.ADM_DIV_REGION
        ObjectType.ADM_DIV_SETTLEMENT -> ObjectTypeMessage.ADM_DIV_SETTLEMENT
        ObjectType.ATTRACTION -> ObjectTypeMessage.ATTRACTION
        ObjectType.BRANCH -> ObjectTypeMessage.BRANCH
        ObjectType.BUILDING -> ObjectTypeMessage.BUILDING
        ObjectType.COORDINATES -> ObjectTypeMessage.COORDINATES
        ObjectType.CROSSROAD -> ObjectTypeMessage.CROSSROAD
        ObjectType.GATE -> ObjectTypeMessage.GATE
        ObjectType.KILOMETER_ROAD_SIGN -> ObjectTypeMessage.KILOMETER_ROAD_SIGN
        ObjectType.PARKING -> ObjectTypeMessage.PARKING
        ObjectType.ROAD -> ObjectTypeMessage.ROAD
        ObjectType.ROUTE -> ObjectTypeMessage.ROUTE
        ObjectType.STATION -> ObjectTypeMessage.STATION
        ObjectType.STATION_ENTRANCE -> ObjectTypeMessage.STATION_ENTRANCE
        ObjectType.STATION_METRO -> ObjectTypeMessage.STATION_METRO
        ObjectType.STATION_PLATFORM -> ObjectTypeMessage.STATION_PLATFORM
        ObjectType.STREET -> ObjectTypeMessage.STREET
        ObjectType.UNKNOWN -> ObjectTypeMessage.UNKNOWN
    }
}

fun PublicTransportDirectoryRouteInfo.toMessage(): PublicTransportDirectoryRouteInfoMessage {
    return PublicTransportDirectoryRouteInfoMessage(
            id = this.id.toMessage(),
            name = this.name,
            color = this.color?.toLong(),
            fromToStationNames = this.fromToStationNames?.toMessage(),
            directions = this.directions.map { it.toMessage() }
    )
}

fun PublicTransportDirectoryRouteDirectionNamesInfo.toMessage():
        PublicTransportDirectoryRouteDirectionNamesInfoMessage {
    return PublicTransportDirectoryRouteDirectionNamesInfoMessage(
            fromName = this.fromName,
            toName = this.toName
    )
}

fun PublicTransportRouteDirection.toMessage(): PublicTransportRouteDirectionMessage {
    return PublicTransportRouteDirectionMessage(
            id = this.id.toMessage(),
            type = this.type.toMessage(),
            geometry = this.geometry?.toMessage(),
            platforms = this.platforms.map { it.toMessage() }
    )
}

fun PublicTransportRouteDirectionId.toMessage(): PublicTransportRouteDirectionIdMessage {
    return PublicTransportRouteDirectionIdMessage(value = this.value)
}

fun PublicTransportRouteDirectionType.toMessage(): PublicTransportRouteDirectionTypeMessage =
        when (this) {
            PublicTransportRouteDirectionType.FORWARD ->
                    PublicTransportRouteDirectionTypeMessage.FORWARD
            PublicTransportRouteDirectionType.BACKWARD ->
                    PublicTransportRouteDirectionTypeMessage.BACKWARD
            PublicTransportRouteDirectionType.ADDITIONAL ->
                    PublicTransportRouteDirectionTypeMessage.ADDITIONAL
            PublicTransportRouteDirectionType.CIRCULAR ->
                    PublicTransportRouteDirectionTypeMessage.CIRCULAR
            PublicTransportRouteDirectionType.LOOP -> PublicTransportRouteDirectionTypeMessage.LOOP
        }

fun PublicTransportRouteGeometry.toMessage(): PublicTransportRouteGeometryMessage {
    return PublicTransportRouteGeometryMessage(
            line = this.line.toMessage(),
            centroid = this.centroid?.toMessage()
    )
}

fun PolylineGeometry.toMessage(): PolylineGeometryMessage {
    return PolylineGeometryMessage(points = this.points.map { it.toMessage() })
}

fun PublicTransportPlatform.toMessage(): PublicTransportPlatformMessage {
    return PublicTransportPlatformMessage(
            id = this.id.toMessage(),
            stationId = this.stationId.toMessage(),
            name = this.name,
            description = this.description,
            transitions = this.transitions.map { it.toMessage() },
            position = this.position?.toMessage()
    )
}

fun PublicTransportPlatformTransition.toMessage(): PublicTransportPlatformTransitionMessage {
    return PublicTransportPlatformTransitionMessage(
            routeId = this.routeId.toMessage(),
            routeName = this.routeName,
            routeType = this.routeType.toMessage(),
            color = this.color?.toLong(),
            stationId = this.stationId.toMessage(),
            stationName = this.stationName
    )
}

fun PublicTransportRouteType.toMessage(): PublicTransportRouteTypeMessage =
        when (this) {
            PublicTransportRouteType.BUS -> PublicTransportRouteTypeMessage.BUS
            PublicTransportRouteType.TROLLEYBUS -> PublicTransportRouteTypeMessage.TROLLEYBUS
            PublicTransportRouteType.TRAM -> PublicTransportRouteTypeMessage.TRAM
            PublicTransportRouteType.SHUTTLE_BUS -> PublicTransportRouteTypeMessage.SHUTTLE_BUS
            PublicTransportRouteType.METRO -> PublicTransportRouteTypeMessage.METRO
            PublicTransportRouteType.SUBURBAN_TRAIN ->
                    PublicTransportRouteTypeMessage.SUBURBAN_TRAIN
            PublicTransportRouteType.FUNICULAR_RAILWAY ->
                    PublicTransportRouteTypeMessage.FUNICULAR_RAILWAY
            PublicTransportRouteType.MONORAIL -> PublicTransportRouteTypeMessage.MONORAIL
            PublicTransportRouteType.RIVER_TRANSPORT ->
                    PublicTransportRouteTypeMessage.RIVER_TRANSPORT
            PublicTransportRouteType.CABLE_CAR -> PublicTransportRouteTypeMessage.CABLE_CAR
            PublicTransportRouteType.LIGHT_RAIL -> PublicTransportRouteTypeMessage.LIGHT_RAIL
            PublicTransportRouteType.PREMETRO -> PublicTransportRouteTypeMessage.PREMETRO
            PublicTransportRouteType.LIGHT_METRO -> PublicTransportRouteTypeMessage.LIGHT_METRO
            PublicTransportRouteType.AEROEXPRESS -> PublicTransportRouteTypeMessage.AEROEXPRESS
        }

fun GroupItem.toMessage(): GroupItemMessage {
    return GroupItemMessage(id = this.id.toMessage(), type = this.type.toMessage())
}
