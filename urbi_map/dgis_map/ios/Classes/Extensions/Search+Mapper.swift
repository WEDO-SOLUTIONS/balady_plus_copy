import Foundation
import DGis

extension SearchResult {
    func toMessage(withId pageId: String, camera: Camera, items: [ItemMarkerInfo]?) -> SearchResultMessage {
        SearchResultMessage.make(
            withFirstPage: self.firstPage?.toMessage(withId: pageId),
            representativeArea: self.representativeArea?.toMessage(),
            areaOfInterestPosition: self.representativeArea.map {
                let cameraPosition = calcPosition(camera: camera, geometry: $0)
                
                return CameraPositionMessage.make(
                    withPoint: cameraPosition.point.toMessage(),
                    zoom: NSNumber(value: cameraPosition.zoom.value),
                    tilt: NSNumber(value: cameraPosition.tilt.value),
                    bearing: NSNumber(value: cameraPosition.bearing.value)
                )
            },
            
            itemMarkerInfos: items?.toMessage(),
            searchResultType: self.searchResultType.toMessage(),
            dynamicFilters: self.dynamicFilters.compactMap {
                $0.toMessage()
            },
            autoUseFirstResult: NSNumber(value: self.autoUseFirstResult)
        )
    }
}


extension Page {
    func toMessage(withId id: String) -> PageMessage {
        PageMessage.make(
            withId: PageIdMessage.make(withId: id),
            items: self.items.map {
                $0.toMessage()
            }
        )
    }
}

extension Array where Element==ItemMarkerInfo {
    fileprivate func toMessage() -> [ItemMarkerInfoMessage] {
        self.map {
            ItemMarkerInfoMessage.make(
                withObjectId: $0.objectId?.toMessage(),
                geoPoint: $0.geoPoint.toMessage(),
                floorInfo: $0.floorInfo?.toMessage(),
                title: $0.title,
                rubricIds: $0.rubricIds.map({
                    NSNumber(value: $0.value)
                })
            )
        }
    }
}

extension FloorInfo {
    fileprivate func toMessage() -> FloorInfoMessage {
        FloorInfoMessage.make(
            withLevelId: NSNumber(value: self.levelId.value),
            buildingId: NSNumber(value: self.buildingId.value)
        )
    }
}

extension DynamicFilter {
    fileprivate func toMessage() -> DynamicFilterMessage? {
        switch self {
        case .flagFilter(let flag):
            return DynamicFilterMessage.make(
                withFlagFilter: flag.toMessage(),
                rangeFilter: nil
            )
        case .rangeFilter(let range):
            return DynamicFilterMessage.make(
                withFlagFilter: nil,
                rangeFilter: range.toMessage()
            )
        case .sortingFilter(_):
            return nil
        }
    }
}

extension FlagFilter {
    fileprivate func toMessage() -> FlagFilterMessage {
        FlagFilterMessage.make(
            withTagName: self.tagName,
            displayName: self.displayName,
            flagValue: self.flagValue.map {
                NSNumber(value: $0)
            }
        )
    }
}

extension RangeFilter {
    fileprivate func toMessage() -> RangeFilterMessage {
        RangeFilterMessage.make(
            withTagName: self.tagName,
            displayName: self.displayName,
            minValue: NSNumber(value: self.minValue),
            maxValue: NSNumber(value: self.maxValue)
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

extension SearchCategoryMessage {
    private func toCategories() -> [UInt64] {
        switch self {
        case .mousques:
            return [13374]
        case .gasStations:
            return [18547]
        case .cafe:
            return [159, 162]
        case .restaurants:
            return [161,165,161,9786,162,469,58871]
        case .parks:
            return [168]
        case .beaches:
            return [168]    
        case .hospitals:
            return [201]
        case .schools:
            return [245]
        case .pharmacies:
            return [207]
        case .dentalCenters:
            return [222]
        case .hotels:
            return [269]
        case .beautyCenters:
            return [56759,110351,382,4521,4517,5603,651,58858,4518,652,13726,110355,13102,53986,110352]
        case .recreationCenters:
            return [537,169,169,170,110358,51001,24472,173,110300,630,110388,110358,190,110358]
        }
    }
    
    func toRubrics() -> [RubricId] {
        return self.toCategories().map {
            RubricId(value: $0)
        }
    }
}
