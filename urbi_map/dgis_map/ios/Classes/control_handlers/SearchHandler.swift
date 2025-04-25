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
    
    private var pages: [String:Page] = [:]
    private var queries: [String:SearchQuery] = [:]
    
    private let jsonDecoder = JSONDecoder()
        
    private static let saRestrictions = [
        GeoPoint(latitude: 32.568765, longitude: 56.694472),
        GeoPoint(latitude: 32.568765, longitude: 32.61185),
        GeoPoint(latitude: 15.506104, longitude: 32.61185),
        GeoPoint(latitude: 15.506104, longitude: 56.694472),
    ];

    init(
        searchManager: SearchManager,
        map: Map,
        sdkContext: Container
    ) {
        self.searchManager = searchManager
        self.map = map
        self.sdkContext = sdkContext
    }

    func cancel() {
        self.objectSearchCancelable?.cancel()
        self.searchCancelable?.cancel()
        self.suggestCancelable?.cancel()
        self.itemMarkerInfosCancellable?.cancel()
    }

    func searchByDirectoryObjectId(objectId: DgisObjectId, completion: @escaping (Result<DirectoryObjectMessage, any Error>) -> Void) {
        self.objectSearchCancelable = searchManager.searchByDirectoryObjectId(objectId: objectId).sink {
            directoryObject in
            guard let response = directoryObject else {
                completion(
                    Result.failure(
                FlutterError(
                    code: "NotFoundException",
                    message: "Object with id \(objectId.objectId) not found",
                    details: nil
                )))
                return
            }
            
            completion(
                Result.success(
                response.toMessage())
            )
        } failure: { error in
            completion(Result.failure(FlutterError(code: "FutureError", message: error.description, details: nil)))
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
        locale: String?,
        completion: @escaping (Result<SearchResultMessage, any Error>) -> Void
    ) {
        guard queryText.count > 0 else {
            completion(
                Result.failure(
                FlutterError(
                    code: "InvalidQuery",
                    message: "Query text cannot be empty",
                    details: nil
                ))
            )
            return
        }
        
        var queryBuilder = categories != nil ?
            SearchQueryBuilder.fromQueryTextAndRubricIds(queryText: queryText, rubricIds: categories!) :
            SearchQueryBuilder.fromQueryText(queryText: queryText)
        
        let query = queryBuilder
            .setPageSize(pageSize: pageSize)
            .setLocale(locale: locale != nil ? Locale.makeLocale(localeStr: locale!) : nil)
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
        locale: String?,
        completion: @escaping (Result<SearchResultMessage, any Error>) -> Void
    ) {
        guard let searchQuery = self.queries[query.id] else {
            completion(
                Result.failure(
                FlutterError(
                    code: "NotFoundException",
                    message: "SearchQuery with given id not exists",
                    details: nil
                )
            ))
            return
        }
        
        var query = SearchQueryBuilder.fromQuery(query: searchQuery)
            .setPageSize(pageSize: pageSize)
            .setLocale(locale: locale != nil ? Locale.makeLocale(localeStr: locale!) : nil)
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
        locale: String?,
        completion: @escaping (Result<SearchResultMessage, any Error>) -> Void
    ) {
        let query = SearchQueryBuilder.fromRubricIds(rubricIds: categories)
            .setPageSize(pageSize: pageSize)
            .setLocale(locale: locale != nil ? Locale.makeLocale(localeStr: locale!) : nil)
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
        locale: String?,
        completion: @escaping (Result<SearchResultMessage, any Error>) -> Void
    ) {
        let query = SearchQueryBuilder.fromQueryText(queryText: "park")
            .setAllowedResultTypes(allowedResultTypes: [.attraction])
            .setPageSize(pageSize: pageSize)
            .setLocale(locale: locale != nil ? Locale.makeLocale(localeStr: locale!) : nil)
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
        locale: String?,
        completion: @escaping (Result<SearchResultMessage, any Error>) -> Void
    ) {
        let query = SearchQueryBuilder.fromQueryText(queryText: "beach")
            .setAllowedResultTypes(allowedResultTypes: [.attraction])
            .setPageSize(pageSize: pageSize)
            .setLocale(locale: locale != nil ? Locale.makeLocale(localeStr: locale!) : nil)
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


    func performSearch(
        _ query: SearchQuery,
        completion: @escaping (Result<SearchResultMessage, any Error>) -> Void
    ) {
        self.searchCancelable = self.searchManager.search(query: query).sink(receiveValue: {
            [weak self] response in
            guard let self = self else {
                completion(
                    Result.failure(
                    FlutterError(code: "Self is nil", message: nil, details: nil)))
                return
            }
            
            self.itemMarkerInfosCancellable = response.itemMarkerInfos.sink(receiveValue: { itemMarkerInfos in
                let pageId = UUID().uuidString
                if let page = response.firstPage {
                    self.pages[pageId] = page
                }

                guard let markersInfo = itemMarkerInfos else {
                    completion(
                        Result.success(
                            response.toMessage(withId: pageId, camera: self.map.camera, items: nil)
                        )
                    )
                    return
                }

                completion(Result.success( response.toMessage(withId: pageId, camera: self.map.camera, items: markersInfo)))
            }, failure: { error in
                completion(
                    Result.failure(
                    FlutterError(
                        code: "FutureError",
                        message: error.description,
                        details: nil
                    ))
                )
            })
        }, failure: {
            error in
            completion(
                Result.failure(
                FlutterError(
                    code: "FutureError",
                    message: error.description,
                    details: nil
                ))
            )
        })
    }
    
    func fetchNextPage(_ pageId: PageIdMessage, completion: @escaping (Result<PageMessage,any Error>) -> Void) {
        guard let page = self.pages[pageId.id] else {
            completion(
                Result.failure(
                FlutterError(
                    code: "NotFoundException",
                    message: "Page with given id not exists",
                    details: nil
                ))
            )
            return
        }
        
        self.searchCancelable = page.fetchNextPage().sink(receiveValue: { response in
            let pageId = UUID().uuidString
            self.pages[pageId] = response
            
            if let response = response {
                completion(
                    Result.success(
                    response.toMessage(withId: pageId))
                )
            } else {
                completion(
                    Result.failure(
                    FlutterError(
                        code: "NotFoundException",
                        message: "Failed to fetch page",
                        details: nil
                    )
                ))
            }
        }, failure: {
            error in
            completion(
                Result.failure(
                FlutterError(
                    code: "FutureError",
                    message: error.description,
                    details: nil
                )
            ))
        })
    }
    
    func fetchPrevPage(_ pageId: PageIdMessage, completion: @escaping (Result<PageMessage, any Error>) -> Void) {
        guard let page = self.pages[pageId.id] else {
            completion(
                Result.failure(
                FlutterError(
                    code: "NotFoundException",
                    message: "Page with given id not exists",
                    details: nil
                )
            ))
            return
        }
        
        self.searchCancelable = page.fetchPrevPage().sink(receiveValue: { response in
            let pageId = UUID().uuidString
            self.pages[pageId] = response
            
            if let response = response {
                completion(
                    Result.success(
                    response.toMessage(withId: pageId)
                    )
                )
            } else {
                completion(
                    Result.failure(
                    FlutterError(
                        code: "NotFoundException",
                        message: "Failed to fetch page",
                        details: nil
                    ))
                )
            }
        }, failure: {
            error in
            completion(
                Result.failure(
                FlutterError(
                    code: "FutureError",
                    message: error.description,
                    details: nil
                )
            ))
        })
    }

    func releasePage(_ pageId: PageIdMessage, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard self.pages.removeValue(forKey: pageId.id) != nil else {
            completion(
                Result.failure(FlutterError(
                    code: "NotFoundException",
                    message: "Page with given id not exists",
                    details: nil
                ))
            )
            return
        }

        completion(Result.success(()))
    }
    
    func fetchSuggests(
        queryText: String,
        allowedResultTypes: [SuggestedTypeMessage_]?,
        searchGeoRect: DGis.GeoRect?,
        locale: String?,
        suggestorType: SuggestorTypeEnum?,
        limit: Int64?,
        completion: @escaping (Result<SuggestResultMessage, any Error>) -> Void
    ) {
        var suggestQueryBuilder = SuggestQueryBuilder
            .fromQueryText(queryText: queryText)
            .setLocale(locale: locale != nil ? Locale.makeLocale(localeStr: locale!) : nil)
            .setAreaOfInterest(rect: searchGeoRect)
            .setSpatialRestriction(spatialRestriction: Self.saRestrictions)
        
        if let suggestorType {
            suggestQueryBuilder = suggestQueryBuilder.setSuggestorType(suggestorType: suggestorType.toSuggestorType())
        }
        if let allowedResultTypes {
            suggestQueryBuilder = suggestQueryBuilder.setAllowedResultTypes(
                allowedResultTypes: allowedResultTypes.map { $0.type.suggestedType }
            )
        }
        if let limit {
            if limit >= Int64(Int32.min) && limit <= Int64(Int32.max) {
                suggestQueryBuilder = suggestQueryBuilder.setLimit(limit: Int32(limit))
            } else {
                print("Value out of range for Int32")
            }
        }
            
        let suggestQuery = suggestQueryBuilder.build()

        suggestCancelable?.cancel()
        suggestCancelable = searchManager.suggest(query: suggestQuery).sink(
            receiveValue: {
                [weak self] response in
                guard let self = self else {
                    completion(  Result.failure( FlutterError(code: "Self is nil", message: nil, details: nil)))
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
                    Result.success(
                        SuggestResultMessage(
                            suggests: suggests
                        )
                    )              )
            },
            failure: { error in
                completion(  Result.failure(FlutterError(code: "FutureError", message: error.description, details: nil)))
            }
        )
    }

    func getDistanceTo(
        points: [DistanceRequestMessage],
        location: GeoPoint?,
        completion: @escaping (Result<[DistanceResponseMessage], any Error>) -> Void
    ) {
        guard let location = location else {
            completion(
                Result.failure(
                FlutterError(code: "LocationError", message: "Cannot define last location", details: nil)
            ))
            return
        }

        let current = location
        let response: [DistanceResponseMessage] = points.map {
            let distance =  current.distance(
                point: GeoPoint(
                    latitude: $0.geoPoint.latitude,
                    longitude: $0.geoPoint.longitude
                ))
            return DistanceResponseMessage(
                distance: Double(distance.value),
                dgisObjectId: $0.dgisObjectId
            )
        }
        completion(Result.success(response))
    }

    private func buildWeekTimeFilter(_ weekTimeMessage: WeekTimeSearchMessage?) -> WorkTimeFilter? {
        guard let weekTimeMessage = weekTimeMessage else { return nil }

        if weekTimeMessage.isOpenNow {
            return WorkTimeFilter.isOpenNow(IsOpenNow())
        }

        if let weekDay = weekTimeMessage.weekDay?.toWeekDay(), let time = weekTimeMessage.time {
            return WorkTimeFilter.workTime(
                WeekTime(
                    weekDay: weekDay,
                    time: time.toDayTime()
                ))
        }

        return nil
    }
}
