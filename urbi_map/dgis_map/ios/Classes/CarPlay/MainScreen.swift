import CarPlay
import Combine
import DGis

class MainScreen: NSObject, CPMapTemplateDelegate, SearchNavigation {
    private let map: Map
    private let interfaceController: CPInterfaceController
    private let dgisCarPlayMapView: DgisCarPlayMapView
    private let window: CPWindow
    private let eventProcessor: IMapEventProcessor
    private let userDefaultsPublished: UserDefaultsPublished
    private let navigationManager: NavigationManager
    private let eventChannel: DgisStreamHandler?

    init(
        map: Map,
        interfaceController: CPInterfaceController,
        dgisCarPlayMapView: DgisCarPlayMapView,
        window: CPWindow,
        eventProcessor: IMapEventProcessor,
        navigationManager: NavigationManager,
        userDefaultsPublished: UserDefaultsPublished,
        eventChannel: DgisStreamHandler?
    ) {
        self.map = map
        self.dgisCarPlayMapView = dgisCarPlayMapView
        self.interfaceController = interfaceController
        self.trafficControlModel = TrafficControlModel(map: map)
        self.window = window
        self.eventProcessor = eventProcessor
        self.userDefaultsPublished = userDefaultsPublished
        self.navigationManager = navigationManager
        self.model = navigationManager.uiModel
        self.eventChannel = eventChannel
        self.mapTemplate = CPMapTemplate()
        self.navigationSessionManeuvers = NavigationSessionManeuvers(
            model: model,
            mapTemplate: mapTemplate
        )
    }

    private let mapTemplate: CPMapTemplate
    private lazy var zoomControlModel = ZoomControlModel(map: map)
    private let trafficControlModel: TrafficControlModel
    private let model: Model
    private var trafficStateCancellable: DGis.Cancellable?
    private var rebuildUiCancellable: Combine.AnyCancellable?
    private var navigatorStateCancelable: DGis.Cancellable?
    private let navigationSessionManeuvers: NavigationSessionManeuvers
    private var currentSettingsScreen: SettingsScreen?

    deinit {
        rebuildUiCancellable?.cancel()
        navigatorStateCancelable?.cancel()
    }

    private var leadingNavigationBarButtonFactories = [() -> CPBarButton]() {
        didSet {
            mapTemplate.leadingNavigationBarButtons =
                leadingNavigationBarButtonFactories.map { make in make() }
        }
    }

    func createTemplate() -> CPMapTemplate {
        if let maneuverColor = UIColor(named: "CarPlayManueverBackgroung") {
            mapTemplate.guidanceBackgroundColor = maneuverColor
        }

        mapTemplate.hidesButtonsWithNavigationBar = false

        window.rootViewController = dgisCarPlayMapView
        window.isUserInteractionEnabled = true
        window.isMultipleTouchEnabled = true

        mapTemplate.mapButtons = [
            makeZoomInButton(),
            makeZoomOutButton(),
            makeMyLocationButton(),
        ]

        leadingNavigationBarButtonFactories = [
            makeSearchButton
        ]

        mapTemplate.trailingNavigationBarButtons = [
            makePanHeaderButton(),
            makeSettingsButton(),
        ]

        mapTemplate.mapDelegate = self

        rebuildUiCancellable = userDefaultsPublished.$languageString.sink(
            receiveValue: whenLanguageUpdated
        )

        navigatorStateCancelable = model.stateChannel.sink(
            receiveValue: navigatorStateListener
        )

        return mapTemplate
    }

    private func whenLanguageUpdated(language: String?) {
        let value = leadingNavigationBarButtonFactories
        leadingNavigationBarButtonFactories = value
    }

    private func buildFromFactories() {
        mapTemplate.leadingNavigationBarButtons =
            leadingNavigationBarButtonFactories.map { make in make() }
    }

    private func navigatorStateListener(state: State) {
        switch state {
        case .disabled:
            leadingNavigationBarButtonFactories = [
                makeSearchButton
            ]
            navigationSessionManeuvers.disable()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dgisCarPlayMapView.myLocation()
                // await for following to be disabled in SDK when navigation is stopped
                FlutterCarPlayDashboardSceneDelegate.mapView?.myLocation()
            }
        case .navigation:
            leadingNavigationBarButtonFactories = [
                makeFinishHeaderButton
            ]

            navigationSessionManeuvers.navigate()
        case .routeSearch:
            break
        case .finished:
            navigationSessionManeuvers.finish()
        @unknown default:
            break
        }
    }

    private func onSearchBarTap(_: CPBarButton) {
        let screen = SearchScreen(
            interfaceController: interfaceController,
            map: map,
            userDefaultsPublished: userDefaultsPublished,
            searchNavigation: self
        )
        screen.createTemplate().show(with: interfaceController)
    }

    private func onSettingsBarTap(_: CPBarButton) {
        let screen = SettingsScreen(
            onBackTap: onBackTap,
            userDefaultsPublished: userDefaultsPublished,
            eventChannel: eventChannel,
            map: map,
            traitStyle: window.traitCollection.userInterfaceStyle
        )
        screen.createTemplate().show(with: interfaceController)
        currentSettingsScreen = screen
    }

    func toggleSounds(toggleType: SoundToggleType) {
        // Update sound settings in the current settings screen if it exists
        currentSettingsScreen?.toggleSoundsFromMobile(toggleType: toggleType)
    }

    private func onBackTap(_: CPBarButton) {
        interfaceController.popTemplate(animated: true, completion: nil)
        currentSettingsScreen = nil
    }

    private func onZoomInTap(_: CPMapButton) {
        zoomControlModel.setPressed(button: .zoomIn, value: true)
        zoomControlModel.setPressed(button: .zoomIn, value: false)
    }

    private func onZoomOutTap(_: CPMapButton) {
        zoomControlModel.setPressed(button: .zoomOut, value: true)
        zoomControlModel.setPressed(button: .zoomOut, value: false)
    }

    private func onMyLocationBarTap(_: CPBarButton) {
        dgisCarPlayMapView.myLocation()
    }

    private func onMyLocationMapTap(_: CPMapButton) {
        dgisCarPlayMapView.myLocation()
    }

    private func onAcceptBarTap(_: CPBarButton) {
        mapTemplate.dismissPanningInterface(animated: true)
        leadingNavigationBarButtonFactories = [
            makeSearchButton
        ]
        mapTemplate.trailingNavigationBarButtons = [
            makePanHeaderButton(),
            makeSettingsButton(),
        ]
    }

    private func onFinishBarTap(_: CPBarButton) {
        navigationManager.stop()
    }

    private func onPanningBarTap(_: CPBarButton) {
        mapTemplate.showPanningInterface(animated: true)
        mapTemplate.trailingNavigationBarButtons = [
            makeMyLocationHeaderButton()
        ]
        leadingNavigationBarButtonFactories = [
            makeAcceptHeaderButton
        ]
    }

    private func processDirectEvent(event: DGis.Event) {
        eventProcessor.process(event: DirectMapControlBeginEvent())
        eventProcessor.process(event: event)
        eventProcessor.process(
            event: DirectMapControlEndEvent(
                timestamp: TimeInterval(CACurrentMediaTime())
            )
        )
    }

    func mapTemplate(
        _ mapTemplate: CPMapTemplate,
        panWith direction: CPMapTemplate.PanDirection
    ) {
        let carWindowScreenNativeBounds = window.screen.nativeBounds
        let dx = Float(carWindowScreenNativeBounds.width / 8)
        let dy = Float(carWindowScreenNativeBounds.height / 8)

        let screenShift: ScreenShift? =
            switch direction {
            case .left: ScreenShift(dx: dx, dy: 0)
            case .right: ScreenShift(dx: -dx, dy: 0)
            case .up: ScreenShift(dx: 0, dy: dy)
            case .down: ScreenShift(dx: 0, dy: -dy)
            default: nil
            }

        if let screenShift {
            let shiftedPoint = ScreenPoint(
                x: Float(carWindowScreenNativeBounds.width / 2),
                y: Float(carWindowScreenNativeBounds.height / 2)
            )
            processDirectEvent(
                event: DirectMapShiftEvent(
                    screenShift: screenShift,
                    shiftedPoint: shiftedPoint,
                    timestamp: TimeInterval(CACurrentMediaTime())
                )
            )
        }
    }

    func mapTemplate(
        _ mapTemplate: CPMapTemplate,
        didUpdatePanGestureWithTranslation translation: CGPoint,
        velocity: CGPoint
    ) {
        processDirectEvent(
            event: DirectMapShiftEvent(
                screenShift: ScreenShift(
                    dx: Float(translation.x) * 1.5,
                    dy: Float(translation.y) * 1.5
                ),
                shiftedPoint: ScreenPoint.init(translation),
                timestamp: TimeInterval(CACurrentMediaTime())
            )
        )
    }

    private func makeSearchButton() -> CPBarButton {
        return CPBarButton(
            image: UIImage(named: "Search")!, handler: onSearchBarTap
        )
    }

    private func makeZoomInButton() -> CPMapButton {
        let button = CPMapButton(handler: onZoomInTap)
        button.isHidden = false
        button.isEnabled = true
        button.image = UIImage(named: "ZoomIn")!
        button.focusedImage = UIImage(named: "ZoomIn")!

        return button
    }

    private func makeZoomOutButton() -> CPMapButton {
        let button = CPMapButton(handler: onZoomOutTap)
        button.isHidden = false
        button.isEnabled = true
        button.image = UIImage(named: "ZoomOut")!
        button.focusedImage = UIImage(named: "ZoomOut")!

        return button
    }

    private func makeMyLocationButton() -> CPMapButton {
        let button = CPMapButton(handler: onMyLocationMapTap)
        button.isHidden = false
        button.isEnabled = true
        button.image = UIImage(named: "FollowOn")!
        button.focusedImage = UIImage(named: "FollowOn")!
        return button
    }

    private func makeAcceptHeaderButton() -> CPBarButton {
        return CPBarButton(
            title: NSLocalizedString("mainScreenBarAccept", comment: ""),
            handler: onAcceptBarTap
        )
    }

    private func makeFinishHeaderButton() -> CPBarButton {
        return CPBarButton(
            title: NSLocalizedString("mainScreenBarFinishButton", comment: ""),
            handler: onFinishBarTap
        )
    }

    private func makePanHeaderButton() -> CPBarButton {
        let image = UIImage(named: "Pan")!.withRenderingMode(.alwaysOriginal)
        return CPBarButton(image: image, handler: onPanningBarTap)
    }

    private func makeMyLocationHeaderButton() -> CPBarButton {
        let image = UIImage(named: "MyLocation")!.withRenderingMode(
            .alwaysOriginal)
        let button = CPBarButton(image: image, handler: onMyLocationBarTap)
        return button
    }

    private func makeSettingsButton() -> CPBarButton {
        return CPBarButton(
            image: UIImage(named: "Settings")!.withRenderingMode(
                .alwaysOriginal),
            handler: onSettingsBarTap
        )
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
