import Foundation
import DGis

extension SearchResult {
    func toMessage(withId pageId: String, camera: Camera, items: [ItemMarkerInfo]?) -> SearchResultMessage {
        SearchResultMessage(
            firstPage: self.firstPage?.toMessage(withId: pageId),
            representativeArea: self.representativeArea?.toMessage(),
            areaOfInterestPosition: self.representativeArea.map {
                let cameraPosition = calcPosition(camera: camera, geometry: $0)
                
                return CameraPositionMessage(
                    point: cameraPosition.point.toMessage(),
                    zoom:  Double(cameraPosition.zoom.value),
                    tilt: Double(cameraPosition.tilt.value),
                    bearing: cameraPosition.bearing.value
                )
            },
            
            itemMarkerInfos: items?.toMessage(),
            searchResultType: self.searchResultType.toMessage(),
            dynamicFilters: self.dynamicFilters.compactMap {
                $0.toMessage()
            },
            autoUseFirstResult:  self.autoUseFirstResult
        )
    }
}

extension UIMarkerInfo {
    func toMessage() -> UiMarkerInfoMessage {
        UiMarkerInfoMessage(
            objectId: self.objectId.toMessage(),
            label: self.label
        )
    }
}

extension Page {
    func toMessage(withId id: String) -> PageMessage {
        PageMessage(
            id: PageIdMessage(id: id),
            items: self.items.map {
                $0.toMessage()
            }
        )
    }
}

extension Array where Element==ItemMarkerInfo {
    fileprivate func toMessage() -> [ItemMarkerInfoMessage] {
        self.map {
            ItemMarkerInfoMessage(
                objectId: $0.objectId?.toMessage(),
                geoPoint: $0.geoPoint.toMessage(),
                floorInfo: $0.floorInfo?.toMessage(),
                title: $0.title,
                rubricIds: $0.rubricIds.map({
                    Int64($0.value)
                })
            )
        }
    }
}

extension FloorInfo {
    fileprivate func toMessage() -> FloorInfoMessage {
        FloorInfoMessage(
            levelId:  Int64(self.levelId.value),
            buildingId: Int64(self.buildingId.value)
        )
    }
}

extension DynamicFilter {
    fileprivate func toMessage() -> DynamicFilterMessage? {
        switch self {
        case .flagFilter(let flag):
            return DynamicFilterMessage(
                flagFilter: flag.toMessage(),
                rangeFilter: nil
            )
        case .rangeFilter(let range):
            return DynamicFilterMessage(
                flagFilter: nil,
                rangeFilter: range.toMessage()
            )
        case .sortingFilter(_):
            return nil
        }
    }
}

extension FlagFilter {
    fileprivate func toMessage() -> FlagFilterMessage {
        FlagFilterMessage(
            tagName: self.tagName,
            displayName: self.displayName,
            flagValue: self.flagValue
        )
    }
}

extension RangeFilter {
    fileprivate func toMessage() -> RangeFilterMessage {
        RangeFilterMessage(
            tagName: self.tagName,
            displayName: self.displayName,
            minValue: self.minValue,
            maxValue: self.maxValue
        )
    }
}

extension SearchResultType {
    fileprivate func toMessage() -> SearchResultTypeMessage {
        switch self {
        case .recovery:
            return .recovery
        case .discovery:
            return .discovery
        }
    }
}
