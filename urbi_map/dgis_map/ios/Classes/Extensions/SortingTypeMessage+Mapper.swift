import Foundation
import DGis

extension SortingTypeMessage {
    func toSortingType() -> SortingType {
        switch self {
        case .byRelevance:
            return .byRelevance
        case .byDistance:
            return .byDistance
        case .byRating:
            return .byRating
        @unknown default:
            return .byRelevance
        }
    }
}
