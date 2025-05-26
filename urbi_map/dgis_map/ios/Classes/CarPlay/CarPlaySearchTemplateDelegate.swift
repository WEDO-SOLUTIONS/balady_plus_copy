import CarPlay
import DGis

class CarPlaySearchTemplateDelegate: NSObject, CPSearchTemplateDelegate {
    private let interfaceController: CPInterfaceController
    private let map: Map

    init(
        interfaceController: CPInterfaceController,
        map: Map
    ) {
        self.interfaceController = interfaceController
        self.map = map
        let sdk = DgisMapInitializer.shared.getSdkContainer()
        self.searchManager = try! SearchManager.createOnlineManager(
            context: try! sdk.context
        )
        self.searchHandler = SearchHandler(
            searchManager: searchManager,
            map: map,
            sdkContext: sdk
        )
        self.navigationManager = DgisMapInitializer.shared
            .getNavigationManager()
    }

    private let navigationManager: NavigationManager
    private let searchManager: SearchManager
    private let searchHandler: SearchHandler

    func searchTemplate(
        _ searchTemplate: CPSearchTemplate,
        updatedSearchText searchText: String,
        completionHandler: @escaping ([CPListItem]) -> Void
    ) {
        guard !searchText.isEmpty else {
            completionHandler([])
            return
        }

        searchHandler.fetchSuggests(
            queryText: searchText,
            allowedResultTypes: [],
            searchGeoRect: nil,
            locale: nil,
            suggestorType: SuggestorTypeEnum.routeEndpoint,
            limit: nil
        ) { result in
            switch result {
            case .success(let value):
                let cpListItems = value.suggests.map(
                    self.createSuggestMessageCPListItem
                )
                completionHandler(cpListItems)
            case .failure(let error):
                completionHandler(
                    [
                        CPListItem(
                            text: "failure",
                            detailText: "\(String(describing: error))"
                        )
                    ]
                )
            }
        }
    }

    private func createSuggestMessageCPListItem(suggestMessage: SuggestMessage)
        -> CPListItem
    {
        let item = CPListItem(
            text: suggestMessage.title.text,
            detailText: suggestMessage.subtitle.text
        )
        item.userInfo = suggestMessage
        return item
    }

    func searchTemplate(
        _ searchTemplate: CPSearchTemplate, selectedResult item: CPListItem,
        completionHandler: @escaping () -> Void
    ) {
        self.interfaceController.popTemplate(animated: true) { _, __ in }

        completionHandler()

        let suggestMessage = item.userInfo as! SuggestMessage

        guard
            let markerPosition = suggestMessage.handler.objectHandler?.item
                .markerPosition
        else { return }

        let geoPoint = GeoPoint(
            latitude: markerPosition.latitude,
            longitude: markerPosition.longitude
        )

        let finishPoint = RouteSearchPoint(coordinates: geoPoint)

        let carRouteSearchOptions = CarRouteSearchOptions()

        let routeSearchOptions = RouteSearchOptions.car(carRouteSearchOptions)

        let routeBuildOptions = RouteBuildOptions.init(
            finishPoint: finishPoint,
            routeSearchOptions: routeSearchOptions
        )

        try! navigationManager.start(routeBuildOptions: routeBuildOptions)
    }
}
