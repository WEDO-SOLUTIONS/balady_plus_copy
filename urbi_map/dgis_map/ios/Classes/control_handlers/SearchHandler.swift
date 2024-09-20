import Foundation

import DGis
import CoreLocation

class SearchHandler: NSObject {
    private let map: Map
    private let sdkContext: Container

    private let searchManager: SearchManager

    private var objectSearchCancelable: Cancellable?
    private var searchCancelable: Cancellable?
    private var itemMarkerInfosCancellable: Cancellable?
    private var suggestCancelable: Cancellable?
    private var objectLabelsQueue: OperationQueue

    private var labelCancellables = Set<Cancellable>()
    
    private var pages: [String:Page] = [:]
    private var queries: [String:SearchQuery] = [:]
    
    private let jsonDecoder = JSONDecoder()
    
    private let vendorConfig: VendorConfig?
    
    private static let saRestrictions = [
        GeoPoint(latitude: 32.568765, longitude: 56.694472),
        GeoPoint(latitude: 32.568765, longitude: 32.61185),
        GeoPoint(latitude: 15.506104, longitude: 32.61185),
        GeoPoint(latitude: 15.506104, longitude: 56.694472),
    ];

    init(
        searchManager: SearchManager,
        map: Map,
        sdkContext: Container,
        vendorConfig: VendorConfig?
    ) {
        self.searchManager = searchManager
        self.map = map
        self.sdkContext = sdkContext
        self.vendorConfig = vendorConfig
        self.objectLabelsQueue = OperationQueue()
    }

    func cancel() {
        self.objectSearchCancelable?.cancel()
        self.searchCancelable?.cancel()
        self.suggestCancelable?.cancel()
        self.itemMarkerInfosCancellable?.cancel()
        self.objectLabelsQueue.cancelAllOperations()
        self.labelCancellables.forEach { $0.cancel() }
    }

    func searchByDirectoryObjectId(objectId: DgisObjectId, completion: @escaping (DirectoryObjectMessage?, FlutterError?) -> Void) {
        self.objectSearchCancelable = searchManager.searchByDirectoryObjectId(objectId: objectId).sink {
            directoryObject in
            guard let response = directoryObject else {
                completion(nil, FlutterError(
                    code: "NotFoundException",
                    message: "Object with id \(objectId.objectId) not found",
                    details: nil
                ))
                return
            }
            
            completion(
                response.toMessage(),
                nil
            )
        } failure: { error in
            completion(nil, FlutterError(code: "FutureError", message: error.description, details: nil))
        }
    }
    
    func search(
        _ queryText: String,
        categories: [RubricId]?,
        spatialRestriction: [GeoPointMessage]?,
        searchGeoRect: DGis.GeoRect?,
        weekTimeMessage: WeekTimeSearchMessage?,
        sortingType: SortingTypeMessage,
        pageSize: Int32,
        completion: @escaping (SearchResultMessage?, FlutterError?) -> Void
    ) {
        guard queryText.count > 0 else {
            completion(
                nil,
                FlutterError(
                    code: "InvalidQuery",
                    message: "Query text cannot be empty",
                    details: nil
                )
            )
            return
        }
        
        var queryBuilder = categories != nil ?
            SearchQueryBuilder.fromQueryTextAndRubricIds(queryText: queryText, rubricIds: categories!) :
            SearchQueryBuilder.fromQueryText(queryText: queryText)
        
        let query = queryBuilder
            .setPageSize(pageSize: pageSize)
            .setSortingType(sortingType: sortingType.toSortingType())
            .setDirectoryFilter(filter:
                DirectoryFilter(
                    workTime: buildWeekTimeFilter(weekTimeMessage),
                    dynamic: []
                )
            )
            .setAreaOfInterest(rect: searchGeoRect)
            .setSpatialRestriction(spatialRestriction: spatialRestriction?.map {
                $0.geoPoint
            } ?? Self.saRestrictions)
            .build()
        
        performSearch(query, completion: completion)
    }
    
    func searchByQuery(
        _ query: SearchQueryMessage,
        spatialRestriction: [GeoPointMessage]?,
        searchGeoRect: DGis.GeoRect?,
        weekTimeMessage: WeekTimeSearchMessage?,
        sortingType: SortingTypeMessage,
        pageSize: Int32,
        completion: @escaping (SearchResultMessage?, FlutterError?) -> Void
    ) {
        guard let searchQuery = self.queries[query.id] else {
            completion(
                nil,
                FlutterError(
                    code: "NotFoundException",
                    message: "SearchQuery with given id not exists",
                    details: nil
                )
            )
            return
        }
        
        var query = SearchQueryBuilder.fromQuery(query: searchQuery)
            .setPageSize(pageSize: pageSize)
            .setSortingType(sortingType: sortingType.toSortingType())
            .setDirectoryFilter(filter:
                DirectoryFilter(
                    workTime: buildWeekTimeFilter(weekTimeMessage),
                    dynamic: []
                )
            )
            .setAreaOfInterest(rect: searchGeoRect)
            .setSpatialRestriction(spatialRestriction: spatialRestriction?.map {
                $0.geoPoint
            } ?? Self.saRestrictions)
            .build()
        
        performSearch(query, completion: completion)
    }
    
    func searchByCategories(
        _ categories: [RubricId],
        spatialRestriction: [GeoPointMessage]?,
        searchGeoRect: DGis.GeoRect?,
        weekTimeMessage: WeekTimeSearchMessage?,
        sortingType: SortingTypeMessage,
        pageSize: Int32,
        completion: @escaping (SearchResultMessage?, FlutterError?) -> Void
    ) {
        let query = SearchQueryBuilder.fromRubricIds(rubricIds: categories)
            .setPageSize(pageSize: pageSize)
            .setSortingType(sortingType: sortingType.toSortingType())
            .setDirectoryFilter(filter:
                DirectoryFilter(
                    workTime: buildWeekTimeFilter(weekTimeMessage),
                    dynamic: []
                )
            )
            .setAreaOfInterest(rect: searchGeoRect)
            .setSpatialRestriction(spatialRestriction: spatialRestriction?.map {
                $0.geoPoint
            } ?? Self.saRestrictions)
            .build()
        
        performSearch(query, completion: completion)
    }

    func searchByParkCategory(
        spatialRestriction: [GeoPointMessage]?,
        searchGeoRect: DGis.GeoRect?,
        weekTimeMessage: WeekTimeSearchMessage?,
        sortingType: SortingTypeMessage,
        pageSize: Int32,
        completion: @escaping (SearchResultMessage?, FlutterError?) -> Void
    ) {
        let query = SearchQueryBuilder.fromQueryText(queryText: "park")
            .setAllowedResultTypes(allowedResultTypes: [.attraction])
            .setPageSize(pageSize: pageSize)
            .setSortingType(sortingType: sortingType.toSortingType())
            .setDirectoryFilter(filter:
                DirectoryFilter(
                    workTime: buildWeekTimeFilter(weekTimeMessage),
                    dynamic: []
                )
			)
            .setAreaOfInterest(rect: searchGeoRect)
            .setSpatialRestriction(spatialRestriction: spatialRestriction?.map {
                $0.geoPoint
            } ?? Self.saRestrictions)
            .build()

        performSearch(query, completion: completion)
    }

    func searchByBeachCategory(
        spatialRestriction: [GeoPointMessage]?,
        searchGeoRect: DGis.GeoRect?,
        weekTimeMessage: WeekTimeSearchMessage?,
        sortingType: SortingTypeMessage,
        pageSize: Int32,
        completion: @escaping (SearchResultMessage?, FlutterError?) -> Void
    ) {
        let query = SearchQueryBuilder.fromQueryText(queryText: "beach")
            .setAllowedResultTypes(allowedResultTypes: [.attraction])
            .setPageSize(pageSize: pageSize)
            .setSortingType(sortingType: sortingType.toSortingType())
            .setDirectoryFilter(filter:
                DirectoryFilter(
                    workTime: buildWeekTimeFilter(weekTimeMessage),
                    dynamic: []
                )
			)
            .setAreaOfInterest(rect: searchGeoRect)
            .setSpatialRestriction(spatialRestriction: spatialRestriction?.map {
                $0.geoPoint
            } ?? Self.saRestrictions)
            .build()

        performSearch(query, completion: completion)
    }

   private func resolveMarkerTitle(response: SearchResult, objectIds: [DgisObjectId], completion: @escaping (Result<[UIMarkerInfo], Error>) -> Void) {
        let futures = response.markerTitles(objectIds: objectIds)
        var results: [Result<[UIMarkerInfo], Error>] = []
        let group = DispatchGroup()
        
        for future in futures {
            group.enter()
            let c = future
                .sink(receiveValue: { markerInfoList in
                    results.append(.success(markerInfoList))
                    group.leave()
                }, failure: { error in
                    results.append(.failure(error))
                    group.leave()
                })
            self.labelCancellables.insert(c)    
        }
        
        group.notify(queue: .global()) {
            var allMarkerInfo: [UIMarkerInfo] = []
            for result in results {
                switch result {
                case .success(let markerInfoList):
                    allMarkerInfo.append(contentsOf: markerInfoList)
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
            }
            completion(.success(allMarkerInfo))
        }
    }


    func performSearch(
        _ query: SearchQuery,
        completion: @escaping (SearchResultMessage?, FlutterError?) -> Void
    ) {
        self.searchCancelable = self.searchManager.search(query: query).sink(receiveValue: {
            [weak self] response in
            guard let self = self else {
                completion(nil, FlutterError(code: "Self is nil", message: nil, details: nil))
                return
            }
            
            self.itemMarkerInfosCancellable = response.itemMarkerInfos.sink(receiveValue: { itemMarkerInfos in
                let pageId = UUID().uuidString
                if let page = response.firstPage {
                    self.pages[pageId] = page
                }

                guard let markersInfo = itemMarkerInfos else {
                    completion(
                        response.toMessage(withId: pageId, camera: self.map.camera, items: nil, labels: []),
                        nil
                    )
                    return
                }

                let operation = BlockOperation {
                    let objectIds = markersInfo.compactMap { $0.objectId }

                    self.resolveMarkerTitle(response: response, objectIds: objectIds) { resolveResult in
                        switch resolveResult {
                        case .success(let uiMarkerInfo):
                            DispatchQueue.main.async {
                                completion(response.toMessage(withId: pageId, camera: self.map.camera, items: markersInfo, labels: uiMarkerInfo), nil)
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                completion(response.toMessage(withId: pageId, camera: self.map.camera, items: markersInfo, labels: []), nil)
                            }
                            print("Error resolving marker titles: \(error)")
                        }
                    }
                }
                
                self.objectLabelsQueue.addOperation(operation)
            }, failure: { error in
                completion(
                    nil,
                    FlutterError(
                        code: "FutureError",
                        message: error.description,
                        details: nil
                    )
                )
            })
        }, failure: {
            error in
            completion(
                nil,
                FlutterError(
                    code: "FutureError",
                    message: error.description,
                    details: nil
                )
            )
        })
    }
    
    func fetchNextPage(_ pageId: PageIdMessage, completion: @escaping (PageMessage?, FlutterError?) -> Void) {
        guard let page = self.pages[pageId.id] else {
            completion(
                nil,
                FlutterError(
                    code: "NotFoundException",
                    message: "Page with given id not exists",
                    details: nil
                )
            )
            return
        }
        
        self.searchCancelable = page.fetchNextPage().sink(receiveValue: { response in
            let pageId = UUID().uuidString
            self.pages[pageId] = response
            
            if let response = response {
                completion(
                    response.toMessage(withId: pageId),
                    nil
                )
            } else {
                completion(
                    nil,
                    FlutterError(
                        code: "NotFoundException",
                        message: "Failed to fetch page",
                        details: nil
                    )
                )
            }
        }, failure: {
            error in
            completion(
                nil,
                FlutterError(
                    code: "FutureError",
                    message: error.description,
                    details: nil
                )
            )
        })
    }
    
    func fetchPrevPage(_ pageId: PageIdMessage, completion: @escaping (PageMessage?, FlutterError?) -> Void) {
        guard let page = self.pages[pageId.id] else {
            completion(
                nil,
                FlutterError(
                    code: "NotFoundException",
                    message: "Page with given id not exists",
                    details: nil
                )
            )
            return
        }
        
        self.searchCancelable = page.fetchPrevPage().sink(receiveValue: { response in
            let pageId = UUID().uuidString
            self.pages[pageId] = response
            
            if let response = response {
                completion(
                    response.toMessage(withId: pageId),
                    nil
                )
            } else {
                completion(
                    nil,
                    FlutterError(
                        code: "NotFoundException",
                        message: "Failed to fetch page",
                        details: nil
                    )
                )
            }
        }, failure: {
            error in
            completion(
                nil,
                FlutterError(
                    code: "FutureError",
                    message: error.description,
                    details: nil
                )
            )
        })
    }

    func releasePage(_ pageId: PageIdMessage, completion: @escaping (FlutterError?) -> Void) {
        guard self.pages.removeValue(forKey: pageId.id) != nil else {
            completion(
                FlutterError(
                    code: "NotFoundException",
                    message: "Page with given id not exists",
                    details: nil
                )
            )
            return
        }

        completion(nil)
    }
    
    func fetchSuggests(
        queryText: String,
        allowedResultTypes: [SuggestedTypeMessage_]?,
        searchGeoRect: DGis.GeoRect?,
        completion: @escaping (SuggestResultMessage?, FlutterError?) -> Void
    ) {
        var suggestQueryBuilder = SuggestQueryBuilder
            .fromQueryText(queryText: queryText)
            .setAreaOfInterest(rect: searchGeoRect)
            .setSpatialRestriction(spatialRestriction: Self.saRestrictions)
        
        if let allowedResultTypes {
            suggestQueryBuilder = suggestQueryBuilder.setAllowedResultTypes(
                allowedResultTypes: allowedResultTypes.map { $0.type.suggestedType }
            )
        }
            
        let suggestQuery = suggestQueryBuilder.build()

        suggestCancelable?.cancel()
        suggestCancelable = searchManager.suggest(query: suggestQuery).sink(
            receiveValue: {
                [weak self] response in
                guard let self = self else {
                    completion(nil, FlutterError(code: "Self is nil", message: nil, details: nil))
                    return
                }
                self.queries.removeAll()
                let suggests = response.suggests.enumerated().map {
                    (index, suggest) in
                    var queryId: String? = nil
                    
                    if case .performSearchHandler(let handler) = suggest.handler, let handler = handler {
                        queryId = UUID().uuidString
                        self.queries[queryId!] = handler.searchQuery
                    }
                    
                    return suggest.toMessage(searchQueryId: queryId)
                }

                completion(
                    SuggestResultMessage.make(
                        withSuggests: suggests
                    ),
                    nil
                )
            },
            failure: { error in
                completion(nil, FlutterError(code: "FutureError", message: error.description, details: nil))
            }
        )
    }

    func getDistanceTo(
        points: [DistanceRequestMessage],
        location: GeoPoint?,
        completion: @escaping ([DistanceResponseMessage], FlutterError?) -> Void
    ) {
        guard let location = location else {
            completion(
                [],
                FlutterError(code: "LocationError", message: "Cannot define last location", details: nil)
            )
            return
        }

        let current = location
        let response: [DistanceResponseMessage] = points.map {
            let distance =  current.distance(
                point: GeoPoint(
                    latitude: $0.geoPoint.latitude.doubleValue,
                    longitude: $0.geoPoint.longitude.doubleValue
                ))
            return DistanceResponseMessage.make(
                withDistance: NSNumber(value: distance.value),
                dgisObjectId: $0.dgisObjectId
            )
        }
        completion(response ,nil)
    }

    private func buildWeekTimeFilter(_ weekTimeMessage: WeekTimeSearchMessage?) -> WorkTimeFilter? {
        guard let weekTimeMessage = weekTimeMessage else { return nil }

        if weekTimeMessage.isOpenNow.boolValue {
            return WorkTimeFilter.isOpenNow(IsOpenNow())
        }

        if let weekDay = weekTimeMessage.weekDay.toWeekDay(), let time = weekTimeMessage.time {
            return WorkTimeFilter.workTime(
                WeekTime(
                    weekDay: weekDay,
                    time: time.toDayTime()
                ))
        }

        return nil
    }
}
