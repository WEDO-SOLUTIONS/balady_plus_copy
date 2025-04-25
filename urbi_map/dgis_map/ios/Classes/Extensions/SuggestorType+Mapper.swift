import Foundation
import DGis

extension SuggestorTypeEnum {
    func toSuggestorType() -> DGis.SuggestorType {
        switch self {
            case .address:
                return .address
            case .citySelector:
                return .citySelector
            case .object:
                return .object
            case .places:
                return .places
            case .routeEndpoint:
                return .routeEndpoint
            case .rubric:
                return .rubric
        }
    }
}
