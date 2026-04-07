import Foundation
import DGis

extension DirectoryObject {
    func toMessage() -> DirectoryObjectMessage {
        return DirectoryObjectMessage(
            types: self.types.toMessage(),
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
            timeZoneOffset: self.timeZoneOffset,
            openingHours: self.openingHours?.toMessage(),
            contactInfos: self.contactInfos.map {
                $0.toMessage()
            },
            reviews: self.reviews?.toMessage(),
            parkingInfo: self.parkingInfo?.toMessage(),
            workStatus: self.workStatus?.toMessage(),
            levelId: self.levelId?.value != nil ? Int64(self.levelId!.value): nil,
            buildingLevels: self.buildingLevels?.toMessage(),
            entrances: self.entrances.map {
                $0.toMessage()
            },
            tradeLicense: self.tradeLicense?.toMessage(),
            buildingInfo: self.buildingInfo.toMessage(),
            rubricIds: self.rubricIds.map {
                Int64($0.value)
            },
            orgInfo: self.orgInfo?.toMessage(),
            group: self.group.map { $0.toMessage() },
            routeInfos: self.routeInfos.map { $0.toMessage() },
            platformIds: self.platformIds.map { $0.toMessage() }
        )
    }
    
    var addressString: String {
        guard let address = address else { return "" }

        let delimiter = ", "

        let addressComponents = address.components.reduce("") {
            partial, addressComponent in
            let componentString =
                switch addressComponent {
                case .streetAddress(let addressStreet):
                    addressStreet.number + delimiter + addressStreet.street
                case .number(let number):
                    number.number
                case .location(let location):
                    location.comment
                @unknown default:
                    ""
                }
            return partial + componentString + delimiter
        }

        let drillDownTypes: Set = ["city", "district"]

        let drillDown = address.drillDown.filter {
            addressAdmDiv in drillDownTypes.contains(addressAdmDiv.type)
        }.reduce("") {
            partial, addressAdmDiv in partial + addressAdmDiv.name + delimiter
        }

        let result = addressComponents + drillDown

        return result.hasSuffix(delimiter)
            ? String(result.dropLast(delimiter.count)) : result
    }
}

extension Array where Element==ObjectType {
    fileprivate func toMessage() -> [ObjectTypeItemMessage] {
        return self.map {
            ObjectTypeItemMessage(type: $0.toMessage())
        }
    }
}

extension ObjectType {
    fileprivate func toMessage() -> ObjectTypeMessage {
        switch self {
        case .admDivDistrict:
            return .admDivDistrict
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
        case .stationMetro:
            return .stationMetro
        case .stationPlatform:
            return .stationPlatform    
        default:
            return .unknown
        }
    }
}

extension DgisObjectId {
    func toMessage() -> DgisObjectIdMessage {
        DgisObjectIdMessage(
            objectId:  Int64(self.objectId),
            entranceId:  Int64(self.entranceId)
        )
    }
}

extension BuildingInfo {
    func toMessage() -> BuildingInfoMessage {
        BuildingInfoMessage(
            buildingName: self.buildingName,
            purposeName: self.purposeName,
            purposeCode: self.purposeCode?.value != nil ? Int64(self.purposeCode!.value): nil
        )
    }
}

extension Address {
    fileprivate func toMessage() -> AddressMessage {
        AddressMessage(
            drilldown: self.drillDown.map { $0.toMessage() },
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
        FormattedAddressMessage(
            drilldownAddress: self.drilldownAddress,
            streetAddress: self.streetAddress,
            addressComment: self.addressComment,
            postCode: self.postCode
        )
    }
}

extension AddressAdmDiv {
    fileprivate func toMessage() -> AddressAdmDivMessage {
        AddressAdmDivMessage(
            type: self.type,
            name: self.name
        )
    }
}

extension AddressNumber {
    fileprivate func toMessage() -> AddressNumberMessage {
        AddressNumberMessage(number: self.number)
    }
}

extension AddressStreet {
    fileprivate func toMessage() -> AddressStreetMessage {
        AddressStreetMessage(
            street: self.street,
            number: self.number
        )
    }
}

extension AddressLocation {
    fileprivate func toMessage() -> AddressLocationMessage {
        AddressLocationMessage(
            comment: self.comment
        )
    }
}

extension AddressComponent {
    fileprivate func toMessage() -> AddressComponentMessage {
        switch self {
        case .location(let location):
            return AddressComponentMessage(
                streetAddress: nil,
                number: nil,
                location: location.toMessage()
            )
        case .number(let number):
            return AddressComponentMessage(
                streetAddress: nil,
                number: number.toMessage(),
                location: nil
            )
        case .streetAddress(let street):
            return AddressComponentMessage(
                streetAddress: street.toMessage(),
                number: nil,
                location: nil
            )
        }
    }
}

extension Attribute {
    fileprivate func toMessage() -> AttributeMessage {
        AttributeMessage(
            tag: self.tag,
            value: self.value
        )
    }
}

extension OpeningHours {
    fileprivate func toMessage() -> OpeningHoursMessage {
        OpeningHoursMessage(
            values: self.weekOpeningHours.toMessage(),
            isOpen24x7:  self.isOpen24x7
        )
    }
}

extension Array where Element==[WeekTimeInterval] {
    fileprivate func toMessage() -> [WeekTimeIntervalListMessage] {
        self.map {
            WeekTimeIntervalListMessage(
                values: $0.toMessage()
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
        WeekTimeIntervalMessage(
            startTime: startTime.toMessage(),
            finishTime: finishTime.toMessage()
        )
    }
}

extension WeekTime {
    fileprivate func toMessage() -> WeekTimeMessage {
        WeekTimeMessage(
            weekDay: weekDay.toMessage(),
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
        DayTimeMessage(
            hours: Int64(hours),
            minutes: Int64(minutes)
        )
    }
}

extension ContactInfo {
    fileprivate func toMessage() -> ContactInfoMessage {
        ContactInfoMessage(
            type: self.type,
            displayText: self.displayText,
            value: self.value,
            comment: self.comment
        )
    }
}

extension Reviews {
    fileprivate func toMessage() -> ReviewsMessage {
        ReviewsMessage(
            rating: Double(self.rating),
            count: Int64( self.count)
        )
    }
}

extension WorkStatus {
    fileprivate func toMessage() -> WorkStatusMessage {
        WorkStatusMessage(
            isOpen:  self.isOpen,
            desc: self.description
        )
    }
}

extension ParkingInfo {
    fileprivate func toMessage() -> ParkingInfoMessage {
        ParkingInfoMessage(
            type: self.type?.toMessage() ?? .none,
            purpose: self.purpose.toMessage(),
            access: self.access.toMessage(),
            pavingType: self.pavingType?.toMessage() ?? .none,
            isPaid: self.isPaid,
            isIncentive: self.isIncentive,
            forTrucks: self.forTrucks,
            levelCount:self.levelCount != nil ? Int64(self.levelCount!): nil,
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
            return .publicAccess
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
        ParkingCapacityMessage(
            total: self.total,
            specialSpaces: self.specialSpaces.map {
                $0.toMessage()
            }
        )
    }
}

extension SpecialSpace {
    fileprivate func toMessage() -> SpecialSpaceMessage {
        SpecialSpaceMessage(
            type: self.type.toMessage(),
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
        BuildingLevelsMessage(
            defaultLevelId:  Int64(self.defaultLevelId.value),
            levels: self.levels.map {
                $0.toMessage()
            }
        )
    }
}

extension LevelInfo {
    fileprivate func toMessage() -> LevelInfoMessage {
        LevelInfoMessage(
            id: Int64(self.id.value),
            name: self.name
        )
    }
}

extension EntranceInfo {
    fileprivate func toMessage() -> EntranceInfoMessage {
        EntranceInfoMessage(
            id: self.id.toMessage(),
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
        ApartmentRangeMessage(
            start: self.start,
            end: self.end
        )
    }
}

extension EntranceGeometry {
    fileprivate func toMessage() -> EntranceGeometryMessage {
        EntranceGeometryMessage(
            entrancePoints: self.entrancePoints.map {
                $0.toMessage()
            },
            entrancePolylines: self.entrancePolylines.map { polyline in
                PolylineGeometryMessage(
                    points: polyline.map {
                        $0.toMessage()
                    }
                )
            }
        )
    }
}

extension TradeLicense {
    fileprivate func toMessage() -> TradeLicenseMessage {
        TradeLicenseMessage(
            type: self.type,
            license: self.license,
            legalForm: self.legalForm,
            endDate: self.endDate
        )
    }
}

extension PublicTransportDirectoryRouteInfo {
    func toMessage() -> PublicTransportDirectoryRouteInfoMessage {
        PublicTransportDirectoryRouteInfoMessage(
            id: self.id.toMessage(),
            name: self.name,
            color: self.color != nil ? Int64(self.color!) : nil,
            fromToStationNames: self.fromToStationNames?.toMessage(),
            directions: self.directions.map { $0.toMessage() }
        )
    }
}

extension PublicTransportDirectoryRouteDirectionNamesInfo {
    func toMessage() -> PublicTransportDirectoryRouteDirectionNamesInfoMessage {
        PublicTransportDirectoryRouteDirectionNamesInfoMessage(
            fromName: self.fromName,
            toName: self.toName
        )
    }
}

extension PublicTransportRouteDirection {
    func toMessage() -> PublicTransportRouteDirectionMessage {
        PublicTransportRouteDirectionMessage(
            id: self.id.toMessage(),
            type: self.type.toMessage(),
            geometry: self.geometry?.toMessage(),
            platforms: self.platforms.map { $0.toMessage() }
        )
    }
}

extension PublicTransportRouteDirectionId {
    func toMessage() -> PublicTransportRouteDirectionIdMessage {
        PublicTransportRouteDirectionIdMessage(value: Int64(self.value))
    }
}

extension PublicTransportRouteDirectionType {
    func toMessage() -> PublicTransportRouteDirectionTypeMessage {
        switch self {
        case .forward: return .forward
        case .backward: return .backward
        case .additional: return .additional
        case .circular: return .circular
        case .loop: return .loop
        @unknown default: return .forward
        }
    }
}

extension PublicTransportRouteGeometry {
    func toMessage() -> PublicTransportRouteGeometryMessage {
        PublicTransportRouteGeometryMessage(
            line: self.line.toMessage(),
            centroid: self.centroid?.toMessage()
        )
    }
}

extension PolylineGeometry {
    func toMessage() -> PolylineGeometryMessage {
        PolylineGeometryMessage(points: self.points.map { $0.toMessage() })
    }
}

extension PublicTransportPlatform {
    func toMessage() -> PublicTransportPlatformMessage {
        PublicTransportPlatformMessage(
            id: self.id.toMessage(),
            stationId: self.stationId.toMessage(),
            name: self.name,
            description: self.description,
            transitions: self.transitions.map { $0.toMessage() },
            position: self.position?.toMessage()
        )
    }
}

extension PublicTransportPlatformTransition {
    func toMessage() -> PublicTransportPlatformTransitionMessage {
        PublicTransportPlatformTransitionMessage(
            routeId: self.routeId.toMessage(),
            routeName: self.routeName,
            routeType: self.routeType.toMessage(),
            color: self.color != nil ? Int64(self.color!) : nil,
            stationId: self.stationId.toMessage(),
            stationName: self.stationName
        )
    }
}

extension PublicTransportRouteType {
    func toMessage() -> PublicTransportRouteTypeMessage {
        switch self {
        case .bus: return .bus
        case .trolleybus: return .trolleybus
        case .tram: return .tram
        case .shuttleBus: return .shuttleBus
        case .metro: return .metro
        case .suburbanTrain: return .suburbanTrain
        case .funicularRailway: return .funicularRailway
        case .monorail: return .monorail
        case .riverTransport: return .riverTransport
        case .cableCar: return .cableCar
        case .lightRail: return .lightRail
        case .premetro: return .premetro
        case .lightMetro: return .lightMetro
        case .aeroexpress: return .aeroexpress
        @unknown default: return .bus
        }
    }
}

extension PublicTransportType {
    var toMessage: PublicTransportRouteTypeMessage {
        switch self {
        case .aeroexpress: return .aeroexpress
        case .bus: return .bus
        case .cableCar: return .cableCar
        case .funicularRailway: return .funicularRailway
        case .lightMetro: return .lightMetro
        case .metro: return .metro
        case .monorail: return .monorail
        case .premetro: return .premetro
        case .trolleybus: return .trolleybus
        case .tram: return .tram
        case .shuttleBus: return .shuttleBus
        case .suburbanTrain: return .suburbanTrain
        @unknown default: return .bus
        }
    }
}

extension GroupItem {
    func toMessage() -> GroupItemMessage {
        return GroupItemMessage(
            id: self.id.toMessage(),
            type: self.type.toMessage()
        )
    }
}


extension OrgInfo {
    func toMessage() -> OrgInfoMessage {
        OrgInfoMessage(branchCount: Int64(self.branchCount), id: Int64(self.id.value), name: self.name)
    }
}


extension SearchHistoryItem {
    func toMessage() -> SearchHistoryDirectoryObjectMessage {
        return switch self {
        case .directoryObject(let directoryObject):
            SearchHistoryDirectoryObjectMessage(
                      title: directoryObject.title,
                      address: directoryObject.addressString,
                      id: directoryObject.id.map {
                          DgisObjectIdMessage(
                            objectId: Int64($0.objectId),
                            entranceId: Int64(directoryObject.id?.entranceId ?? 0),
                          )
                      }
                  )
        case .searchQuery(let searchQuery):
            SearchHistoryDirectoryObjectMessage(title: searchQuery.title, address: searchQuery.subtitle)
        @unknown default:
            fatalError("unknown SearchHistoryItem")
        }
    }
}
