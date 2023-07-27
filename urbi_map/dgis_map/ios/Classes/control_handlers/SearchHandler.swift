import Foundation
import DGis
import CoreLocation

class SearchHandler: NSObject {
    private let map: Map
    private let sdkContext: Container

    private let searchManager: SearchManager

    private let imageFactory: IImageFactory
    private lazy var searchMarkerImage: Image = self.imageFactory.make(image: UIImage(named: "ic_search_marker")!)

    private lazy var objectManager: MapObjectManager = MapObjectManager.withGeneralization(
        map: map,
        logicalPixel: LogicalPixel(floatLiteral: 30),
        maxZoom: Zoom(18.0)
    )

    private var objectSearchCancelable: Cancellable?
    private var searchCancelable: Cancellable?
    private var suggestCancelable: Cancellable?
    private var searchMarkerCancelable: Cancellable?

    private var page: Page?
    private var availableFlagFilters: Set<FlagFilter> = []
    private var lastQuery: SearchQuery?

    init(searchManager: SearchManager, map: Map, sdkContext: Container, imageFactory: IImageFactory) {
        self.searchManager = searchManager
        self.map = map
        self.sdkContext = sdkContext
        self.imageFactory = imageFactory
    }

    func cancel() {
        self.objectSearchCancelable?.cancel()
        self.searchCancelable?.cancel()
        self.suggestCancelable?.cancel()
    }

    func searchByDirectoryObjectId(objectId: DgisObjectId, completion: @escaping (ObjectInfoMessage?, FlutterError?) -> Void) {
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
            completion(response.toMessage(), nil)
        } failure: { error in
            completion(nil, FlutterError(code: "FutureError", message: error.description, details: nil))
        }
    }

    func search(
        _ queryText: String,
        searchGeoRect: DGis.GeoRect,
        weekTimeMessage: WeekTimeSearchMessage?,
        sortingType: SortingTypeMessage,
        pageSize: Int32,
        completion: @escaping ([ObjectInfoMessage]?, FlutterError?) -> Void
    ) {
        var builder = SearchQueryBuilder.fromQueryText(queryText: queryText)

        self.performSearch(
            builder,
            weekTime: weekTimeMessage,
            sortingType: sortingType,
            pageSize: pageSize,
            searchGeoRect: searchGeoRect,
            completion: completion
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

    func getNextPage(completion: @escaping ([ObjectInfoMessage]?, FlutterError?) -> Void) {
        self.searchCancelable = self.page?.fetchNextPage().sink(receiveValue: {
            [weak self] page in
            guard let self = self else { return }
            self.handleSearchResponse(page, completion)
        }, failure: { error in
            completion(nil, FlutterError(code: "FutureError", message: error.description, details: nil))
        })
    }

    private var suggests: [Suggest] = []

    func fetchSuggests(
        queryText: String,
        searchGeoRect: DGis.GeoRect,
        completion: @escaping ([SuggestMessage]?, FlutterError?) -> Void
    ) {
        let suggestQuery = SuggestQueryBuilder.fromQueryText(queryText: queryText)
            .setAreaOfInterest(rect: searchGeoRect)
            .build()

        suggestCancelable = searchManager.suggest(query: suggestQuery).sink(
            receiveValue: {
                [weak self] response in
                guard let self = self else {
                    completion(nil, FlutterError(code: "Self is nil", message: nil, details: nil))
                    return
                }
                self.suggests.removeAll()
                self.suggests.append(contentsOf: response.suggests)
                let result = response.suggests.enumerated().map {
                    (index, suggest) in
                    suggest.toMessage(index)
                }

                completion(result, nil)
            },
            failure: { error in
                completion(nil, FlutterError(code: "FutureError", message: error.description, details: nil))
            }
        )
    }

    func getSuggestObject(
        _ index: Int,
        completion: @escaping (ObjectInfoMessage?, FlutterError?) -> Void
    ) {
        guard case .objectHandler(let handler) = suggests[index].handler,
              let item = handler?.item else {
            completion(
                nil,
                FlutterError(code: "Suggest with index \(index) is not ObjectHandler", message: nil, details: nil)
            )
            return
        }
        completion(item.toMessage(), nil)
    }

    func getDirectoryDynamicFilters(_ completion: @escaping ([FlagFilterMessage]?, FlutterError?) -> Void) {
        completion(
            availableFlagFilters.map { flagFilter in
                FlagFilterMessage.make(
                    withTagName: flagFilter.tagName,
                    displayName: getFlagFilterDisplayName(filter: flagFilter),
                    flagValue: NSNumber(value: flagFilter.flagValue ?? false))
            },
            nil
        )
    }

    func applyDirectoryFiltersFilters(
        filters: [FlagFilterMessage],
        isOpenFilter: WorkingFilterMessage,
        sortingType: SortingTypeMessage,
        completion: @escaping ([ObjectInfoMessage]?, FlutterError?) -> Void
    ) {
        guard let lastQuery = self.lastQuery else {
            completion(nil, FlutterError(code: "No query to apply filters", message: nil, details: nil))
            return
        }

        let timeFilter = isOpenFilter.toFilter()

        let query = SearchQueryBuilder.fromQuery(query: lastQuery)
            .setSortingType(sortingType: sortingType.toSortingType())
            .setDirectoryFilter(filter: DirectoryFilter(
                workTime: timeFilter,
                dynamic: filters
                    .filter { $0.flagValue.boolValue }
                    .map { filter in
                        DynamicFilter.flagFilter(
                            FlagFilter(
                                tagName: filter.tagName,
                                displayName: filter.displayName,
                                flagValue: filter.flagValue.boolValue
                            ))})
            )
            .build()

        self.searchCancelable = self.searchManager.search(query: query).sink(receiveValue: {
            [weak self] response in
            guard let self = self else { return }
            self.drawSearchMarkers(response)
            self.parseDynamicFilters(response.dynamicFilters)
            self.lastQuery = query
            self.handleSearchResponse(response.firstPage, completion)
        }, failure: {
            error in
            completion(nil, FlutterError(code: "FutureError", message: error.description, details: nil))
        })
    }

    func search(
        bySuggestIndex index: Int,
        weekTime: WeekTimeSearchMessage?,
        sortingType: SortingTypeMessage,
        pageSize: Int32,
        searchGeoRect: DGis.GeoRect,
        completion: @escaping ([ObjectInfoMessage]?, FlutterError?) -> Void
    ) {
        guard case .performSearchHandler(let handler) = suggests[index].handler,
              let searchQuery = handler?.searchQuery else {
            completion(
                nil,
                FlutterError(code: "Suggest with index \(index) is not PerformSearchHandler", message: nil, details: nil)
            )
            return
        }
        let builder = SearchQueryBuilder.fromQuery(query: searchQuery)

        self.performSearch(
            builder,
            weekTime: weekTime,
            sortingType: sortingType,
            pageSize: pageSize,
            searchGeoRect: searchGeoRect,
            completion: completion
        )
    }

    func removeSearchMarkers() {
        self.objectManager.removeAll()
    }

    private func getFlagFilterDisplayName(filter: FlagFilter) -> String {
        if filter.tagName == "general_payment_type_card" {
            return "Payment by card through the terminal"
        }
        return filter.displayName
    }

    private func performSearch(
        _ builder: SearchQueryBuilder,
        weekTime: WeekTimeSearchMessage?,
        sortingType: SortingTypeMessage,
        pageSize: Int32,
        searchGeoRect: DGis.GeoRect,
        completion: @escaping ([ObjectInfoMessage]?, FlutterError?) -> Void
    ) {
        let query = builder.setPageSize(pageSize: pageSize)
            .setSortingType(sortingType: sortingType.toSortingType())
            .setDirectoryFilter(filter: DirectoryFilter(
                workTime: buildWeekTimeFilter(weekTime),
                dynamic: [])
            )
            .setAreaOfInterest(rect: searchGeoRect)
            .build()

        self.searchCancelable = self.searchManager.search(query: query).sink(receiveValue: {
            [weak self] response in
            guard let self = self else { return }
            self.drawSearchMarkers(response)
            self.parseDynamicFilters(response.dynamicFilters)
            self.lastQuery = query
            self.handleSearchResponse(response.firstPage, completion)
        }, failure: {
            error in
            completion(
                nil,
                FlutterError(
                    code: "FutureError",
                    message: error.description,
                    details: nil
                ))
        })
    }

    private func parseDynamicFilters(_ filters: [DynamicFilter]) {
        self.availableFlagFilters.removeAll()
        for filter in filters {
            if case .flagFilter(let flagFilter) = filter {
                self.availableFlagFilters.insert(flagFilter)
            }
        }
    }

    private func drawSearchMarkers(_ searchResult: SearchResult) {
        self.removeSearchMarkers()
        searchMarkerCancelable = searchResult.itemMarkerInfos.sink {
            [weak self] itemMarkerInfo in
            guard let self = self, let itemMarkerInfo = itemMarkerInfo else { return }

            let markers = itemMarkerInfo.map { markerInfo in
                Marker(
                    options: MarkerOptions(
                        position: markerInfo.geoPoint,
                        icon: self.searchMarkerImage,
                        userData: markerInfo.objectId
                    )
                )
            }
            self.objectManager.addObjects(objects: markers)
        } failure: { e in }
    }

    private func handleSearchResponse(_ page: Page?, _ completion: @escaping ([ObjectInfoMessage]?, FlutterError?) -> Void) {
        self.page = page
        guard let items = page?.items else {
            completion([], nil)
            return
        }
        completion(items.map({ $0.toMessage()}), nil)
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
