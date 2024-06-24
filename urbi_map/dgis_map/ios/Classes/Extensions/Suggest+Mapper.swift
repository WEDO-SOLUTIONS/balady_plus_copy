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
        case .admDiv:
            return .admDiv
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
        case .districtArea:
            return .districtArea
        case .org:
            return .org
        case .orgCategory:
            return .orgCategory
        case .parking:
            return .parking
        case .region:
            return .region
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
        }
    }
}

extension SuggestedTypeMessage {
    var suggestedType: SuggestedType {
        switch self {
        case .admDiv:
            return .admDiv
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
        case .districtArea:
            return .districtArea
        case .org:
            return .org
        case .orgCategory:
            return .orgCategory
        case .parking:
            return .parking
        case .region:
            return .region
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
            withOffset: NSNumber(value: self.offset),
            length: NSNumber(value: self.length)
        )
    }
}
