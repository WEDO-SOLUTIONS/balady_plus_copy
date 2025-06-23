import CarPlay
import Combine
import DGis

class SearchScreen: SearchNavigation {
    private let interfaceController: CPInterfaceController
    private let map: Map
    private let userDefaultsPublished: UserDefaultsPublished

    init(
        interfaceController: CPInterfaceController,
        map: Map,
        userDefaultsPublished: UserDefaultsPublished
    ) {
        self.interfaceController = interfaceController
        self.map = map
        self.userDefaultsPublished = userDefaultsPublished
        let sdk = DgisMapInitializer.shared.getSdkContainer()
        self.searchManager = try! SearchManager.createOnlineManager(
            context: try! sdk.context
        )
        self.searchHistory = SearchHistory(context: try! sdk.context)
    }
    
    deinit {
        languageCancellable?.cancel()
        languageCancellable = nil
    }

    private lazy var gridTemplate = CPGridTemplate(
        title: nil,
        gridButtons: makeGridButtons()
    )

    private let searchManager: SearchManager
    private let searchHistory: SearchHistory
    private let navigationManager = DgisMapInitializer.shared
        .getNavigationManager()
    private var searchTemplateDelegate: KeyboardSearchScreen?
    private var searchDirectoryObjectCancellable: DGis.Cancellable?
    private var languageCancellable: Combine.AnyCancellable?

    func createTemplate() -> CPGridTemplate {
        languageCancellable = userDefaultsPublished.$languageString.sink { _ in
            self.buildViews()
        }
        return gridTemplate
    }

    private func buildViews() {
        gridTemplate.trailingNavigationBarButtons = [
            CPBarButton(
                image: UIImage(named: "Keyboard")!,
                handler: onKeyboardTap
            )
        ]
        
        gridTemplate.backButton = CPBarButton(
            title: NSLocalizedString("anyScreenBackButton", comment: ""),
            handler: onBackTap
        )

        if #available(iOS 15, *) {
            gridTemplate.updateGridButtons(makeGridButtons())
        }
    }

    private func onHistoryTap(_: CPGridButton) {
        let screen = HistoryScreen(
            interfaceController: interfaceController,
            searchHistory: searchHistory,
            searchNavigation: self,
            userDefaultsPublished: userDefaultsPublished
        )
        screen.createTemplate().show(with: interfaceController)
    }

    private func onKeyboardTap(_: CPBarButton) {
        self.searchTemplateDelegate = KeyboardSearchScreen(
            interfaceController: interfaceController,
            searchManager: searchManager,
            searchHistory: searchHistory,
            searchNavigation: self,
            map: map
        )
        let searchTemplate = CPSearchTemplate()
        searchTemplate.delegate = self.searchTemplateDelegate
        interfaceController.pushTemplate(searchTemplate, animated: true) {
            _, __ in
        }
    }
    
    private func onBackTap(_: CPBarButton) {
        interfaceController.popTemplate(animated: true) { _, __ in }
    }

    private func makeGridButtons() -> [CPGridButton] {
        return [
            CPGridButton(
                titleVariants: [
                    NSLocalizedString("searchScreenGridHistory", comment: "")
                ],
                image: UIImage(named: "History")!,
                handler: onHistoryTap
            ),
        ]
    }

    func navigate(to directoryObject: DirectoryObject) {
        guard let geoPoint = directoryObject.markerPosition?.point else {
            return
        }

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

protocol SearchNavigation {
    func navigate(to directoryObject: DirectoryObject)
}
