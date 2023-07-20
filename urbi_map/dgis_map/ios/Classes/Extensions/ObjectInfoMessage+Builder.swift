import Foundation
import DGis

extension DirectoryObject {
    func toMessage() -> ObjectInfoMessage {
        let message = ObjectInfoMessage.make(
            withTitle: self.title,
            subtitle: self.subtitle,
            reviews: nil,
            address: nil,
            workStatus: nil,
            openingHours: nil,
            markerPosition: nil,
            entranceIds: [],
            dgisObjectId: nil,
            type: self.types[0].toMessage()
        )
        message.buildReviews(self)
        message.buildAddress(self)
        message.buildOpeningHours(self)
        message.buildMarkerPosition(self)
        message.buildEntranceIds(self)
        message.buildDgisObjectId(self)
        
        return message
    }
}

extension ObjectType {
    fileprivate func toMessage() -> ObjectTypeMessage {
        switch self {
            case .branch:
                return .branch
            default:
                return .other
        }
    }
}

extension ObjectInfoMessage {
    fileprivate func buildDgisObjectId(_ response: DirectoryObject) {
        guard let objectId = response.id else { return }
        
        self.dgisObjectId = DgisObjectIdMessage.make(
            withObjectId: NSNumber(value: objectId.objectId),
            entranceId: NSNumber(value: objectId.entranceId)
        )
    }
    
    fileprivate func buildReviews(_ response: DirectoryObject) {
        guard let reviews = response.reviews else { return }
        
        self.reviews = ReviewsMessage.make(
            withCount: NSNumber(value: reviews.count),
            rating: NSNumber(value: reviews.rating)
        )
    }
    
    fileprivate func buildAddress(_ response: DirectoryObject) {
        guard let address = response.address,
              let fullAddress = response.formattedAddress(type: .full) else { return }
        
        let drilldown = address.drillDown.map {
            admDiv in
            AdmDivMessage.make(withType: admDiv.type, name: admDiv.name)
        }
        self.address = AddressMessage.make(
            withAddressComment: fullAddress.addressComment,
            drilldownString: fullAddress.drilldownAddress,
            postCode: fullAddress.postCode,
            streetAddress: fullAddress.streetAddress,
            drilldown: drilldown
        )
    }
    
    fileprivate func buildOpeningHours(_ response: DirectoryObject) {
        guard let workStatus = response.workStatus,
              let openingHours = response.openingHours else { return }
        
        self.workStatus = WorkStatusMessage.make(
            withIsOpen: NSNumber(value: workStatus.isOpen),
            desc: workStatus.description
        )
        let map = openingHours.weekOpeningHours.map({ intervalList in
            let intervalMessage: [WeekTimeIntervalMessage] = intervalList
                .map({
                    [weak self] interval in
                    return self?.weekTimeIntervalToMessage(interval)
                })
                .compactMap { $0 }
            return WeekTimeIntervalListMessage.make(withValues: intervalMessage)
        })
        self.openingHours = OpeningHoursMessage.make(
            withValues: map,
            isOpen24x7: NSNumber(value: openingHours.isOpen24x7)
        )
    }
    
    fileprivate func weekTimeIntervalToMessage(_ interval: WeekTimeInterval) -> WeekTimeIntervalMessage {
        let startWeekDay = fromWeekDay(interval.startTime.weekDay)
        let finishWeekDay = fromWeekDay(interval.finishTime.weekDay)
        let start = WeekTimeMessage.make(
            withWeekDay: startWeekDay,
            time: DayTimeMessage.make(
                withHours: NSNumber(value: interval.startTime.time.hours),
                minutes: NSNumber(value: interval.startTime.time.minutes)
            ))
        let finish = WeekTimeMessage.make(
            withWeekDay: finishWeekDay,
            time: DayTimeMessage.make(
                withHours: NSNumber(value: interval.finishTime.time.hours),
                minutes: NSNumber(value: interval.finishTime.time.minutes)
            )
        )
        return WeekTimeIntervalMessage.make(withStartTime: start, finishTime: finish)
    }
    
    fileprivate func buildMarkerPosition(_ response: DirectoryObject) {
        guard let markerPosition = response.markerPosition else { return }
        
        self.markerPosition = MarkerPositionMessage.make(
            withPoint: GeoPointMessage.make(
                withLatitude: NSNumber(value: markerPosition.latitude.value),
                longitude: NSNumber(value: markerPosition.longitude.value)
            ),
            elevation: NSNumber(value: markerPosition.elevation.value)
        )
    }
    
    fileprivate func buildEntranceIds(_ response: DirectoryObject) {
        self.entranceIds = response.buildingEntrances.map {
            entrance in
            return DgisObjectIdMessage.make(
                withObjectId: NSNumber(value: entrance.id.objectId),
                entranceId: NSNumber(value: entrance.id.entranceId)
            )
        }
    }
    
    fileprivate func fromWeekDay(_ weekDay: WeekDay) -> WeekDayMessage {
        switch(weekDay) {
            case .sunday:
                return WeekDayMessage.sunday
            case .monday:
                return WeekDayMessage.monday
            case .tuesday:
                return WeekDayMessage.tuesday
            case .wednesday:
                return WeekDayMessage.wednesday
            case .thursday:
                return WeekDayMessage.thursday
            case .friday:
                return WeekDayMessage.friday
            case .saturday:
                return WeekDayMessage.saturday
            }
    }
}
