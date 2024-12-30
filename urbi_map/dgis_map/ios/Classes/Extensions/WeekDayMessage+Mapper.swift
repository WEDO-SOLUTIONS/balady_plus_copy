import Foundation
import DGis


extension WeekDayMessage {
    func toWeekDay() -> WeekDay? {
        switch self {
            case .sunday:
                return WeekDay.sunday
            case .monday:
                return WeekDay.monday
            case .tuesday:
                return WeekDay.tuesday
            case .wednesday:
                return WeekDay.wednesday
            case .thursday:
                return WeekDay.thursday
            case .friday:
                return WeekDay.friday
            case .saturday:
                return WeekDay.saturday
            @unknown default:
                return nil
            }
    }
}

extension DayTimeMessage {
    func toDayTime() -> DayTime {
        return DayTime(
            hours: UInt8(self.hours),
            minutes: UInt8(self.minutes)
        )
    }
}

extension WorkingFilterMessage {
    func toFilter() -> WorkTimeFilter? {
        if self == .isOpen {
            return WorkTimeFilter.isOpenNow(IsOpenNow())
        }
        
        return nil
    }
}
