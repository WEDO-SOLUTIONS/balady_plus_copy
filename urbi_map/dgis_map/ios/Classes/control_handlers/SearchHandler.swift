import Foundation
import DGis
import CoreLocation

struct ApiResponse: Decodable {
    var meta: ResponseMeta
    var result: TwinsResult
}

struct ResponseMeta: Decodable {
    var code: Int
}

struct TwinsResult: Decodable {
    var items: [TwinsItem]
}

struct TwinsItem: Decodable {
    var twins: [Twin]
}

struct Twin: Decodable {
    var partnerId: String
    
    enum CodingKeys: String, CodingKey {
        case partnerId = "partner_id"
    }
}

let twinsApiUrl = "https://apiservices.balady.gov.sa/v1/urbi-services/twins-api/v1/search/dgis"

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
                response.toMessage(
                    externalIds: nil
                ),
                nil
            )
            
            return
            
            var url = URLComponents(string: twinsApiUrl)!
            url.queryItems = [
                URLQueryItem(name: "dgis_id", value: String(objectId.objectId)),
                URLQueryItem(name: "partner_code", value: "momrah"),
                URLQueryItem(name: "key", value: "28ed92f1-de4b-4060-b159-2dc19e9b8bf5")
            ]

            let request = URLRequest(url: url.url!)
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard error == nil, let data = data else {
                    completion(
                        response.toMessage(
                            externalIds: nil
                        ),
                        nil
                    )
                    return
                }
                
                let twinsResponse = try? self.jsonDecoder.decode(ApiResponse.self, from: data)
                
                guard let twinsResponse = twinsResponse, twinsResponse.meta.code == 200 else {
                    completion(
                        response.toMessage(
                            externalIds: nil
                        ),
                        nil
                    )
                    return
                }
                
                completion(
                    response.toMessage(
                        externalIds: twinsResponse.result.items.first?.twins.map {
                            $0.partnerId
                        }
                    ),
                    nil
                )
            }.resume()
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
            })
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
            })
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
            })
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
            })
            .build()

        performSearch(query, completion: completion)
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

                completion(
                    response.toMessage(withId: pageId, camera: self.map.camera, items: itemMarkerInfos),
                    nil
                )
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
        
        if let allowedResultTypes {
            suggestQueryBuilder = suggestQueryBuilder.setAllowedResultTypes(
                allowedResultTypes: allowedResultTypes.map { $0.type.suggestedType }
            )
        }
            
        let suggestQuery = suggestQueryBuilder.build()

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
        location: CLLocationCoordinate2D?,
        completion: @escaping ([DistanceResponseMessage], FlutterError?) -> Void
    ) {
        guard let location = location else {
            completion(
                [],
                FlutterError(code: "LocationError", message: "Cannot define last location", details: nil)
            )
            return
        }

        let current = GeoPoint(latitude: location.latitude, longitude: location.longitude)
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
