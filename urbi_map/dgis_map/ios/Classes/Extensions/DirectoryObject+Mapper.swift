import Foundation
import DGis

extension DirectoryObject {
    func toMessage() -> DirectoryObjectMessage {
        return DirectoryObjectMessage.make(
            withTypes: self.types.toMessage(),
            title: self.title,
            titleAddition: self.titleAddition,
            subtitle: self.subtitle, 
            about: self.description,
            id: self.id?.toMessage(),
            markerPosition: self.markerPosition?.toMessage(),
            address: self.address?.toMessage(),
            fullAddressName: self.formattedAddress(type: .full)?.toMessage(),
            shortAddressName: self.formattedAddress(type: .short)?.toMessage(),
            attributes: self.attributes.map { $0.toMessage() },
            contextAttributes: self.attributes.map { $0.toMessage() },
            timeZoneOffset: self.timeZoneOffset.map {
                NSNumber(value: $0)
            },
            openingHours: self.openingHours?.toMessage(),
            contactInfos: self.contactInfos.map {
                $0.toMessage()
            },
            reviews: self.reviews?.toMessage(),
            parkingInfo: self.parkingInfo?.toMessage(),
            workStatus: self.workStatus?.toMessage(),
            levelId: self.levelId.map {
                NSNumber(value: $0.value)
            },
            buildingLevels: self.buildingLevels?.toMessage(), 
            buildingInfo: self.buildingInfo.toMessage(),
            entrances: self.entrances.map {
                $0.toMessage()
            },
            tradeLicense: self.tradeLicense?.toMessage()
        )
    }
}

extension Array where Element==ObjectType {
    fileprivate func toMessage() -> [ObjectTypeItemMessage] {
        return self.map {
            ObjectTypeItemMessage.make(withType: $0.toMessage())
        }
    }
}

extension ObjectType {
    fileprivate func toMessage() -> ObjectTypeMessage {
        switch self {
        case .admDiv:
            return .admDiv
        case .attraction:
            return .attraction
        case .branch:
            return .branch
        case .building:
            return .building
        case .coordinates:
            return .coordinates
        case .crossroad:
            return .crossroad
        case .parking:
            return .parking
        case .road:
            return .road
        case .route:
            return .route
        case .station:
            return .station
        case .stationEntrance:
            return .stationEntrance
        case .street:
            return .street
        default:
            return .unknown
        }
    }
}

extension DgisObjectId {
    func toMessage() -> DgisObjectIdMessage {
        DgisObjectIdMessage.make(
            withObjectId: NSNumber(value: self.objectId),
            entranceId: NSNumber(value: self.entranceId)
        )
    }
}

extension BuildingInfo {
    func toMessage() -> BuildingInfoMessage {
        BuildingInfoMessage.make(
            withBuildingName: self.buildingName,
            purposeName: self.purposeName,
            purposeCode: self.purposeCode.map {
                NSNumber(value: $0.value)
            }
        )
    }
}

extension Address {
    fileprivate func toMessage() -> AddressMessage {
        AddressMessage.make(
            withDrilldown: self.drillDown.map { $0.toMessage() },
            components: self.components.map { $0.toMessage() },
            buildingName: self.buildingName,
            postCode: self.postCode,
            buildingCode: self.buildingCode,
            addressComment: self.addressComment
        )
    }
}

extension FormattedAddress {
    fileprivate func toMessage() -> FormattedAddressMessage {
        FormattedAddressMessage.make(
            withDrilldownAddress: self.drilldownAddress,
            streetAddress: self.streetAddress,
            addressComment: self.addressComment,
            postCode: self.postCode
        )
    }
}

extension AddressAdmDiv {
    fileprivate func toMessage() -> AddressAdmDivMessage {
        AddressAdmDivMessage.make(
            withType: self.type,
            name: self.name
        )
    }
}

extension AddressNumber {
    fileprivate func toMessage() -> AddressNumberMessage {
        AddressNumberMessage.make(withNumber: self.number)
    }
}

extension AddressStreet {
    fileprivate func toMessage() -> AddressStreetMessage {
        AddressStreetMessage.make(
            withStreet: self.street,
            number: self.number
        )
    }
}

extension AddressLocation {
    fileprivate func toMessage() -> AddressLocationMessage {
        AddressLocationMessage.make(
            withComment: self.comment
        )
    }
}

extension AddressComponent {
    fileprivate func toMessage() -> AddressComponentMessage {
        switch self {
        case .location(let location):
            return AddressComponentMessage.make(
                withStreetAddress: nil,
                number: nil,
                location: location.toMessage()
            )
        case .number(let number):
            return AddressComponentMessage.make(
                withStreetAddress: nil,
                number: number.toMessage(),
                location: nil
            )
        case .streetAddress(let street):
            return AddressComponentMessage.make(
                withStreetAddress: street.toMessage(),
                number: nil,
                location: nil
            )
        }
    }
}

extension Attribute {
    fileprivate func toMessage() -> AttributeMessage {
        AttributeMessage.make(
            withTag: self.tag,
            value: self.value
        )
    }
}

extension OpeningHours {
    fileprivate func toMessage() -> OpeningHoursMessage {
        OpeningHoursMessage.make(
            withValues: self.weekOpeningHours.toMessage(),
            isOpen24x7: NSNumber(value: self.isOpen24x7)
        )
    }
}

extension Array where Element==[WeekTimeInterval] {
    fileprivate func toMessage() -> [WeekTimeIntervalListMessage] {
        self.map {
            WeekTimeIntervalListMessage.make(
                withValues: $0.toMessage()
            )
        }
    }
}

extension Array where Element==WeekTimeInterval {
    fileprivate func toMessage() -> [WeekTimeIntervalMessage] {
        self.map {
            $0.toMessage()
        }
    }
}

extension WeekTimeInterval {
    fileprivate func toMessage() -> WeekTimeIntervalMessage {
        WeekTimeIntervalMessage.make(
            withStartTime: startTime.toMessage(),
            finishTime: finishTime.toMessage()
        )
    }
}

extension WeekTime {
    fileprivate func toMessage() -> WeekTimeMessage {
        WeekTimeMessage.make(
            withWeekDay: weekDay.toMessage(),
            time: time.toMessage()
        )
    }
}

extension WeekDay {
    fileprivate func toMessage() -> WeekDayMessage {
        switch self {
        case .sunday:
            return .sunday
        case .monday:
            return .monday
        case .tuesday:
            return .tuesday
        case .wednesday:
            return .wednesday
        case .thursday:
            return .thursday
        case .friday:
            return .friday
        case .saturday:
            return .saturday
        }
    }
}

extension DayTime {
    fileprivate func toMessage() -> DayTimeMessage {
        DayTimeMessage.make(
            withHours: NSNumber(value: hours),
            minutes: NSNumber(value: minutes)
        )
    }
}

extension ContactInfo {
    fileprivate func toMessage() -> ContactInfoMessage {
        ContactInfoMessage.make(
            withType: self.type,
            displayText: self.displayText,
            value: self.value,
            comment: self.comment
        )
    }
}

extension Reviews {
    fileprivate func toMessage() -> ReviewsMessage {
        ReviewsMessage.make(
            withRating: NSNumber(value: self.rating),
            count: NSNumber(value: self.count)
        )
    }
}

extension WorkStatus {
    fileprivate func toMessage() -> WorkStatusMessage {
        WorkStatusMessage.make(
            withIsOpen: NSNumber(value: self.isOpen),
            desc: self.description
        )
    }
}

extension ParkingInfo {
    fileprivate func toMessage() -> ParkingInfoMessage {
        ParkingInfoMessage.make(
            withType: self.type?.toMessage() ?? .none,
            purpose: self.purpose.toMessage(),
            access: self.access.toMessage(),
            pavingType: self.pavingType?.toMessage() ?? .none,
            isPaid: NSNumber(value: self.isPaid),
            isIncentive: NSNumber(value: self.isIncentive),
            forTrucks: NSNumber(value: self.forTrucks),
            levelCount: self.levelCount.map {
                NSNumber(value: $0)
            },
            capacity: self.capacity?.toMessage()
        )
    }
}

extension ParkingType {
    fileprivate func toMessage() -> ParkingTypeMessage {
        switch self {
        case .ground:
            return .ground
        case .underground:
            return .underground
        case .multilevel:
            return .multilevel
        }
    }
}

extension ParkingPurpose {
    fileprivate func toMessage() -> ParkingPurposeMessage {
        switch self {
        case .car:
            return .car
        case .bike:
            return .bike
        case .motorbike:
            return .motorbike
        case .babyCarriage:
            return .babyCarriage
        case .scooter:
            return .scooter
        }
    }
}

extension ParkingAccess {
    fileprivate func toMessage() -> ParkingAccessMessage {
        switch self {
        case .public:
            return .public
        case .handicappedOnly:
            return .handicappedOnly
        case .customersOnly:
            return .customersOnly
        case .residentsOnly:
            return .residentsOnly
        case .taxiOnly:
            return .taxiOnly
        }
    }
}

extension ParkingPavingType {
    fileprivate func toMessage() -> ParkingPavingTypeMessage {
        switch self {
        case .asphalt:
            return .asphalt
        case .concrete:
            return .concrete
        case .gravel:
            return .gravel
        case .unpaved:
            return .unpaved
        }
    }
}

extension ParkingCapacity {
    fileprivate func toMessage() -> ParkingCapacityMessage {
        ParkingCapacityMessage.make(
            withTotal: self.total,
            specialSpaces: self.specialSpaces.map {
                $0.toMessage()
            }
        )
    }
}

extension SpecialSpace {
    fileprivate func toMessage() -> SpecialSpaceMessage {
        SpecialSpaceMessage.make(
            withType: self.type.toMessage(),
            name: self.name,
            count: self.count
        )
    }
}

extension SpecialSpaceType {
    fileprivate func toMessage() -> SpecialSpaceTypeMessage {
        switch self {
        case .bicycle:
            return .bicycle
        case .motorbike:
            return .motorbike
        case .family:
            return .family
        case .handicapped:
            return .handicapped
        case .babyCarriage:
            return .babyCarriage
        case .truck:
            return .truck
        case .scooter:
            return .scooter
        }
    }
}

extension BuildingLevels {
    fileprivate func toMessage() -> BuildingLevelsMessage {
        BuildingLevelsMessage.make(
            withDefaultLevelId: NSNumber(value: self.defaultLevelId.value),
            levels: self.levels.map {
                $0.toMessage()
            }
        )
    }
}

extension LevelInfo {
    fileprivate func toMessage() -> LevelInfoMessage {
        LevelInfoMessage.make(
            withId: NSNumber(value: self.id.value),
            name: self.name
        )
    }
}

extension EntranceInfo {
    fileprivate func toMessage() -> EntranceInfoMessage {
        EntranceInfoMessage.make(
            withId: self.id.toMessage(),
            buildingNumber: self.buildingNumber,
            porchName: self.porchName,
            porchNumber: self.porchNumber,
            apartmentRanges: self.apartmentRanges.map {
                $0.toMessage()
            },
            geometry: self.geometry?.toMessage()
        )
    }
}

extension ApartmentRange {
    fileprivate func toMessage() -> ApartmentRangeMessage {
        ApartmentRangeMessage.make(
            withStart: self.start,
            end: self.end
        )
    }
}

extension EntranceGeometry {
    fileprivate func toMessage() -> EntranceGeometryMessage {
        EntranceGeometryMessage.make(
            withEntrancePoints: self.entrancePoints.map {
                $0.toMessage()
            },
            entrancePolylines: self.entrancePolylines.map { polyline in
                polyline.map {
                    $0.toMessage()
                }
            }
        )
    }
}

extension TradeLicense {
    fileprivate func toMessage() -> TradeLicenseMessage {
        TradeLicenseMessage.make(
            withType: self.type,
            license: self.license,
            legalForm: self.legalForm,
            endDate: self.endDate
        )
    }
}
