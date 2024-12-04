import Foundation
import DGis

extension Suggest {
    func toMessage(searchQueryId: String?) -> SuggestMessage {
        SuggestMessage.make(
            withHandler: self.handler.toMessage(searchQueryId: searchQueryId),
            suggestedType: self.suggestedType.toMessage(),
            title: self.title.toMessage(),
            subtitle: self.subtitle.toMessage()
        )
    }
}

extension SuggestHandler {
    fileprivate func toMessage(searchQueryId: String?) -> SuggestHandlerMessage {
        switch self {
        case .objectHandler(let objectHandler):
            return SuggestHandlerMessage.make(
                withObjectHandler: objectHandler.map {
                    return SuggestObjectHandlerMessage.make(
                        withItem: $0.item.toMessage()
                    )
                },
                performSearchHandler: nil,
                incompleteTextHandler: nil
            )
        case .performSearchHandler(_):
            return SuggestHandlerMessage.make(
                withObjectHandler: nil,
                performSearchHandler: searchQueryId.map {
                    PerformSearchHandlerMessage.make(
                        withSearchQuery: SearchQueryMessage.make(withId: $0)
                    )
                },
                incompleteTextHandler: nil
            )
        case .incompleteTextHandler(let incompleteText):
            return SuggestHandlerMessage.make(
                withObjectHandler: nil,
                performSearchHandler: nil,
                incompleteTextHandler: incompleteText.map {
                    IncompleteTextHandlerMessage.make(
                        withQueryText: $0.queryText
                    )
                }
            )
        }
    }
}

extension SuggestedType {
    fileprivate func toMessage() -> SuggestedTypeMessage {
        switch self {
        case .admDivCity:
            return .admDivCity
        case .attraction:
            return .attraction
        case .attribute:
            return .attribute
        case .branch:
            return .branch
        case .building:
            return .building
        case .coordinates:
            return .coordinates
        case .crossroad:
            return .crossroad
        case .admDivDistrictArea:
            return .admDivDistrictArea
        case .org:
            return .org
        case .parking:
            return .parking
        case .admDivRegion:
            return .admDivRegion
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
        case .text:
            return .text
        case .unknown:
            return .unknown
        case .admDivCountry:
            return .admDivCountry
        case .admDivDistrict:
            return .admDivDistrict
        case .admDivDivision:
            return .admDivDivision
        case .admDivLivingArea:
            return .admDivLivingArea
        case .admDivPlace:
            return .admDivPlace
        case .admDivSettlement:
            return .admDivSettlement
        case .kilometerRoadSign:
            return .kilometerRoadSign
        case .marketAttribute:
            return .marketAttribute
        case .marketBrand:
            return .marketBrand
        case .marketCategory:
            return .marketCategory
        case .marketSuggestorCategory:
            return .marketSuggestorCategory
        case .metaRubric:
            return .metaRubric
        case .routeType:
            return .routeType
        case .rubric:
            return .rubric
        case .stationMetro:
            return .stationMetro

        }
    }
}

extension SuggestedTypeMessage {
    var suggestedType: SuggestedType {
        switch self {
        case .admDivCity:
            return .admDivCity
        case .attraction:
            return .attraction
        case .attribute:
            return .attribute
        case .branch:
            return .branch
        case .building:
            return .building
        case .coordinates:
            return .coordinates
        case .crossroad:
            return .crossroad
        case .admDivDistrictArea:
            return .admDivDistrictArea
        case .org:
            return .org
        case .parking:
            return .parking
        case .admDivRegion:
            return .admDivRegion
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
        case .text:
            return .text
        case .unknown:
            return .unknown
        case .admDivCountry:
            return .admDivCountry
        case .admDivDistrict:
            return .admDivDistrict
        case .admDivDivision:
            return .admDivDivision
        case .admDivLivingArea:
            return .admDivLivingArea
        case .admDivPlace:
            return .admDivPlace
        case .admDivSettlement:
            return .admDivSettlement
        case .kilometerRoadSign:
            return .kilometerRoadSign
        case .marketAttribute:
            return .marketAttribute
        case .marketBrand:
            return .marketBrand
        case .marketCategory:
            return .marketCategory
        case .marketSuggestorCategory:
            return .marketSuggestorCategory
        case .metaRubric:
            return .metaRubric
        case .routeType:
            return .routeType
        case .rubric:
            return .rubric
        case .stationMetro:
            return .stationMetro
        }
    }
}

extension MarkedUpText {
    fileprivate func toMessage() -> MarkedUpTextMessage {
        MarkedUpTextMessage.make(
            withText: self.text,
            matchedParts: self.matchedParts.map {
                $0.toMessage()
            }
        )
    }
}

extension MarkedUpTextSpan {
    fileprivate func toMessage() -> MarkedUpTextSpanMessage {
        MarkedUpTextSpanMessage.make(
            withOffset:  Int(self.offset),
            length:  Int(self.length)
        )
    }
}
