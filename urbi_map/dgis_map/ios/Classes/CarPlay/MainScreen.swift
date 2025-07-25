import CarPlay
import DGis

class MainScreen: NSObject, CPMapTemplateDelegate, SearchNavigation {
    private let map: Map
    private let interfaceController: CPInterfaceController
    private let dgisCarPlayMapView: DgisCarPlayMapView
    private let window: CPWindow
    private let eventProcessor: IMapEventProcessor
    private let userDefaultsPublished: UserDefaultsPublished
    unowned private let navigationManager: NavigationManager
    private let eventChannel: DgisStreamHandler?
    private let container: DGis.Container
    unowned private let hostFlutterApi: HostFlutterApi

    init(
        map: Map,
        container: DGis.Container,
        interfaceController: CPInterfaceController,
        dgisCarPlayMapView: DgisCarPlayMapView,
        window: CPWindow,
        eventProcessor: IMapEventProcessor,
        navigationManager: NavigationManager,
        userDefaultsPublished: UserDefaultsPublished,
        eventChannel: DgisStreamHandler?,
        hostFlutterApi: HostFlutterApi
    ) {
        self.map = map
        self.container = container
        self.routeEditor = RouteEditor(context: try! container.context)
        self.routeEditorSource = RouteEditorSource(
            context: try! container.context, routeEditor: routeEditor,
            calloutLabelDisplayMode: .relativeToActiveRouteValues
        )
        map.addSource(source: routeEditorSource)
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
        self.hostFlutterApi = hostFlutterApi
    }

    private let mapTemplate: CPMapTemplate
    private let routeEditor: RouteEditor
    private let routeEditorSource: RouteEditorSource
    private lazy var zoomControlModel = ZoomControlModel(map: map)
    private let trafficControlModel: TrafficControlModel
    private let model: Model
    private var navigatorStateCancellable: DGis.Cancellable?
    private var routesInfoChannelCancellable: DGis.Cancellable?
    private var activeRouteIndexCancellable: DGis.Cancellable?
    private var routeChannelCancelable: DGis.Cancellable?
    private var betterRouteChannelCancellable: DGis.Cancellable?
    private let navigationSessionManeuvers: NavigationSessionManeuvers
    private var currentSettingsScreen: SettingsScreen?
    private var isPanningInterfaceVisible: Bool = false
    private var startedTrip: CPTrip? = nil
    private var isRoutesShown = false
    private var everyMinuteTimer: Timer?

    func dispose() {
        navigatorStateCancellable?.cancel()
        routesInfoChannelCancellable?.cancel()
        activeRouteIndexCancellable?.cancel()
        routeChannelCancelable?.cancel()
        betterRouteChannelCancellable?.cancel()
        everyMinuteTimer?.invalidate()
        mapTemplate.leadingNavigationBarButtons = []
        mapTemplate.trailingNavigationBarButtons = []
        mapTemplate.mapButtons = []
        navigationSessionManeuvers.cancel()
        window.rootViewController = nil
    }

    func createTemplate() -> CPMapTemplate {
        if let maneuverColor = UIColor(named: "CarPlayManueverBackgroung") {
            mapTemplate.guidanceBackgroundColor = maneuverColor
        }

        mapTemplate.hidesButtonsWithNavigationBar = false

        window.rootViewController = dgisCarPlayMapView
        window.isUserInteractionEnabled = true
        window.isMultipleTouchEnabled = true

        buildMapButtons()

        buildLeadButtons()

        mapTemplate.trailingNavigationBarButtons = [
            makePanHeaderButton(),
            makeSettingsButton(),
        ]

        mapTemplate.mapDelegate = self

        navigatorStateCancellable = model.stateChannel.sinkOnMainThread(
            navigatorStateListener
        )

        routeChannelCancelable = model.routeChannel.sink(
            receiveValue: receiveRouteInfo
        )

        return mapTemplate
    }

    private func receiveRouteInfo(routeInfo: RouteInfo) {
        buildLeadButtons()
    }

    private func buildLeadButtons() {
        let factories = [
            makeFirstLeadButton(),
            makeSecondLeadButton(),
        ].compactMap { $0 }

        mapTemplate.leadingNavigationBarButtons = factories.map {
            function in function()
        }
    }

    private func buildMapButtons() {
        mapTemplate.mapButtons =
            isPanningInterfaceVisible
            ? [
                makeZoomInButton(),
                makeZoomOutButton(),
            ]
            : [
                makeZoomInButton(),
                makeZoomOutButton(),
                makeMyLocationButton(),
            ]
    }

    private func navigatorStateListener(state: State) {
        switch state {
        case .disabled:
            startedTrip = nil
            hideRoutes()
            navigationSessionManeuvers.disable()
            activeRouteIndexCancellable?.cancel()
            betterRouteChannelCancellable?.cancel()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dgisCarPlayMapView.myLocation()
                // await for following to be disabled in SDK when navigation is stopped
                FlutterCarPlayDashboardSceneDelegate.mapView?.myLocation()
            }
        case .navigation:
            navigationSessionManeuvers.navigate()
            betterRouteChannelCancellable = navigationManager.uiModel
                .betterRouteChannel.sinkOnMainThread(receiveBetterRouteInfo)
        case .routeSearch:
            navigationSessionManeuvers.routeSearch()
        case .finished:
            let alert = ArrivedNavigationAlert(
                mainScreen: self,
                navigationSessionManeuvers: navigationSessionManeuvers
            ).create()
            mapTemplate.present(navigationAlert: alert, animated: true)
        @unknown default:
            break
        }
        buildLeadButtons()
    }

    private func receiveBetterRouteInfo(betterRouteInfo: BetterRouteInfo?) {
        if let betterRouteInfo = betterRouteInfo {
            mapTemplate.dismissNavigationAlert(animated: false) { _ in }
            mapTemplate.present(
                navigationAlert: createBetterRouteAlert(for: betterRouteInfo),
                animated: true
            )
        } else {
            mapTemplate.dismissNavigationAlert(animated: true) { _ in }
        }
    }

    private func onBetterRouteStartTap(_: CPAlertAction) {
        model.betterRouteResponse(response: BetterRouteResponse.accept)
    }

    private func onBetterRouteCloseTap(_: CPAlertAction) {
        model.betterRouteResponse(response: BetterRouteResponse.reject)
    }

    private func onSearchBarTap(_: CPBarButton) {
        showSearchScreen()
    }

    func showSearchScreen() {
        let screen = SearchScreen(
            interfaceController: interfaceController,
            map: map,
            searchNavigation: self
        )
        screen.createTemplate().show(with: interfaceController)
    }
    
    private func onFavoritesTap(_: CPBarButton) {
        let template = FavoritesScreen.createTemplate()
        let screen = FavoritesScreen(
            listTemplate: template,
            interfaceController: interfaceController,
            hostFlutterApi: hostFlutterApi
        )
        screen.show()
    }

    private func onSettingsBarTap(_: CPBarButton) {
        let screen = SettingsScreen(
            onBackTap: { [weak self] _ in self?.closeSettingsScreen() },
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

    private func closeSettingsScreen() {
        interfaceController.popTemplate(animated: true, completion: nil)
        currentSettingsScreen?.dispose()
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
        isPanningInterfaceVisible = false
        mapTemplate.dismissPanningInterface(animated: true)
        mapTemplate.trailingNavigationBarButtons = [
            makePanHeaderButton(),
            makeSettingsButton(),
        ]
        buildLeadButtons()
        buildMapButtons()
    }

    private func onFinishBarTap(_: CPBarButton) {
        navigationManager.stop()
        navigationSessionManeuvers.finish()
    }

    private func onCancelBarTap(_: CPBarButton) {
        hideRoutes()
        buildLeadButtons()
    }

    private func onPanningBarTap(_: CPBarButton) {
        isPanningInterfaceVisible = true
        mapTemplate.showPanningInterface(animated: true)
        mapTemplate.trailingNavigationBarButtons = [
            makeMyLocationHeaderButton()
        ]
        buildLeadButtons()
        buildMapButtons()
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

    private func makeFirstLeadButton() -> () -> CPBarButton {
        if isPanningInterfaceVisible {
            return makeAcceptHeaderButton
        } else if model.state != .disabled && !model.isFreeRoam {
            return makeFinishHeaderButton
        } else if isRoutesShown {
            return makeCancelHeaderButton
        }
        return makeSearchButton
    }

    private func makeSecondLeadButton() -> (() -> CPBarButton)? {
        if isPanningInterfaceVisible { return nil }
        guard let trip = startedTrip else { return makeFavoritesButton }
        return makeRouteHeaderButton(trip)
    }

    private func makeSearchButton() -> CPBarButton {
        return CPBarButton(
            image: UIImage(named: "Search")!, handler: onSearchBarTap
        )
    }
    
    private func makeFavoritesButton() -> CPBarButton {
        return CPBarButton(
            image: UIImage(named: "Bookmark")!, handler: onFavoritesTap
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

    private func makeCancelHeaderButton() -> CPBarButton {
        return CPBarButton(
            title: NSLocalizedString("mainScreenBarCancelButton", comment: ""),
            handler: onCancelBarTap
        )
    }

    private func makeRouteHeaderButton(_ trip: CPTrip) -> () -> CPBarButton {
        func image() -> UIImage {
            UIImage(named: isRoutesShown ? "RouteOn" : "Route")!
        }

        func onRouteBarTap(barButton: CPBarButton) {
            if isRoutesShown {
                hideRoutes()
            } else {
                showRoutes(for: trip)
            }
            barButton.image = image()
        }

        func createButton() -> CPBarButton {
            CPBarButton(image: image(), handler: onRouteBarTap)
        }

        return createButton
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
        guard let geoPoint = directoryObject.markerPosition?.point
        else { return }

        let finishPoint = RouteSearchPoint(coordinates: geoPoint)
        let carRouteSearchOptions = CarRouteSearchOptions()
        let routeSearchOptions = RouteSearchOptions.car(carRouteSearchOptions)
        let locationService = try! container.locationService

        guard let lastLocation = locationService.lastLocation?.coordinates
        else { return }

        let startPoint = RouteSearchPoint(
            coordinates: GeoPoint(
                latitude: lastLocation.value.latitude,
                longitude: lastLocation.value.longitude
            ))

        let routeEditorRouteParams = RouteEditorRouteParams(
            startPoint: startPoint,
            finishPoint: finishPoint,
            routeSearchOptions: routeSearchOptions
        )

        routesInfoChannelCancellable = routeEditor.routesInfoChannel
            .sinkOnMainThread {
                [self]
                routeEditorRoutesInfo in
                showTripPreview(
                    to: directoryObject, with: routeEditorRoutesInfo
                )
            }

        routeEditor.setRouteParams(routeParams: routeEditorRouteParams)
    }

    private func showTripPreview(
        to directoryObject: DirectoryObject,
        with routeEditorRoutesInfo: RouteEditorRoutesInfo
    ) {
        guard !routeEditorRoutesInfo.routes.isEmpty else { return }

        routesInfoChannelCancellable?.cancel()

        let trip = createCPTrip(
            to: directoryObject, with: routeEditorRoutesInfo
        )

        showRoutes(for: trip)

        buildLeadButtons()

        everyMinuteTimer?.invalidate()
        everyMinuteTimer = Timer.everyMinuteStart {
            [self] _ in
            updateEstimates(for: trip)
        }

        activeRouteIndexCancellable = routeEditor.activeRouteIndexChannel
            .sinkOnMainThread {
                [self]
                _ in
                updateEstimates(for: trip)
            }
    }

    private func showRoutes(for trip: CPTrip) {
        isRoutesShown = true

        routeEditorSource.setRoutesVisible(visible: isRoutesShown)

        let textConfiguration = CPTripPreviewTextConfiguration(
            startButtonTitle: NSLocalizedString(
                "tripPreviewStartButton", comment: ""
            ),
            additionalRoutesButtonTitle: NSLocalizedString(
                "tripPreviewMoreRoutesButton", comment: ""
            ),
            overviewButtonTitle: NSLocalizedString(
                "tripPreviewBackButton", comment: ""
            )
        )

        if self.startedTrip == nil {
            mapTemplate.showTripPreviews(
                [trip],
                textConfiguration: textConfiguration
            )
        } else {
            mapTemplate.showRouteChoicesPreview(
                for: trip,
                textConfiguration: textConfiguration
            )
        }
    }

    private func hideRoutes() {
        isRoutesShown = false

        routeEditorSource.setRoutesVisible(visible: isRoutesShown)

        mapTemplate.hideTripPreviews()
    }

    private func updateEstimates(for trip: CPTrip) {
        let activeTrafficRoute = routeEditor.activeTrafficRoute
        let millimeters =
            activeTrafficRoute.traffic.durations.entries.last?.point.distance
            .millimeters ?? 0
        let distanceMeasurement = Measurement(
            value: Double(millimeters), unit: UnitLength.millimeters
        )
        mapTemplate.updateEstimates(
            CPTravelEstimates(
                distanceRemaining: distanceMeasurement.formatDistance,
                timeRemaining: activeTrafficRoute.traffic.durations.duration
            ),
            for: trip
        )
    }

    private func createCPTrip(
        to directoryObject: DirectoryObject,
        with routeEditorRoutesInfo: RouteEditorRoutesInfo
    ) -> CPTrip {
        let routeEditorRouteParams = routeEditorRoutesInfo.routeParams
        let coordinates = routeEditorRouteParams.finishPoint.coordinates
        let clLocationCoordinate2D = CLLocationCoordinate2D(
            latitude: coordinates.latitude.value,
            longitude: coordinates.longitude.value
        )
        let destination = MKMapItem(
            placemark: MKPlacemark(coordinate: clLocationCoordinate2D)
        )
        destination.name = directoryObject.title
        return CPTrip(
            origin: MKMapItem(),
            destination: destination,
            routeChoices: routeEditorRoutesInfo.routes.map {
                trafficRoute in
                createCPRouteChoice(trafficRoute, directoryObject)
            }
        )
    }

    private func createCPRouteChoice(
        _ trafficRoute: TrafficRoute, _ directoryObject: DirectoryObject
    )
        -> CPRouteChoice
    {
        let duration = trafficRoute.traffic.durations.duration

        let durationFormatter = DateComponentsFormatter()
        durationFormatter.allowedUnits =
            duration > 3600 ? [.hour, .minute] : [.minute]
        durationFormatter.unitsStyle = .short
        durationFormatter.zeroFormattingBehavior = [.default]
        let durationFormatted = durationFormatter.string(from: duration) ?? "--"

        let distance = trafficRoute.route.geometry.last?.point.distance
        let distanceMeasurement = Measurement(
            value: Double(distance?.millimeters ?? 0),
            unit: UnitLength.millimeters
        )

        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .medium
        measurementFormatter.unitOptions = .providedUnit
        measurementFormatter.numberFormatter.decimalSeparator = ","
        let distanceFormatted = measurementFormatter.string(
            from: distanceMeasurement.formatDistance
        )

        let addressFormatted = directoryObject.address?.addressToString() ?? ""

        return CPRouteChoice(
            summaryVariants: [durationFormatted],
            additionalInformationVariants: [addressFormatted],
            selectionSummaryVariants: [distanceFormatted]
        )
    }

    func mapTemplate(
        _ mapTemplate: CPMapTemplate,
        selectedPreviewFor trip: CPTrip,
        using routeChoice: CPRouteChoice
    ) {
        guard let index = trip.routeChoices.firstIndex(of: routeChoice) else {
            return
        }
        routeEditor.setActiveRouteIndex(index: RouteIndex(value: UInt64(index)))
    }

    func mapTemplate(
        _ mapTemplate: CPMapTemplate,
        startedTrip trip: CPTrip,
        using routeChoice: CPRouteChoice
    ) {
        self.startedTrip = trip

        hideRoutes()

        let routeEditorRouteParams = routeEditor.routesInfo.routeParams
        let routeBuildOptions = RouteBuildOptions(
            finishPoint: routeEditorRouteParams.finishPoint,
            routeSearchOptions: routeEditorRouteParams.routeSearchOptions
        )

        try! navigationManager.start(
            routeBuildOptions: routeBuildOptions,
            trafficRoute: routeEditor.activeTrafficRoute
        )
    }

    private func createBetterRouteAlert(for betterRouteInfo: BetterRouteInfo)
        -> CPNavigationAlert
    {
        let startTitle = NSLocalizedString(
            "betterRouteDialogStartButton", comment: ""
        )

        let closeTitle = NSLocalizedString(
            "betterRouteDialogCloseButton", comment: ""
        )

        let startButton =
            if hasFoundColorIssue, #available(iOS 16.0, *) {
                CPAlertAction(
                    title: startTitle, color: UIColor(10, 132, 255, 1.0),
                    handler: onBetterRouteStartTap
                )
            } else {
                CPAlertAction(
                    title: startTitle, style: CPAlertAction.Style.default,
                    handler: onBetterRouteStartTap
                )
            }

        let closeButton =
            if hasFoundColorIssue, #available(iOS 16.0, *) {
                CPAlertAction(
                    title: closeTitle, color: UIColor(192, 218, 243, 1.0),
                    handler: onBetterRouteCloseTap
                )
            } else {
                CPAlertAction(
                    title: closeTitle, style: CPAlertAction.Style.cancel,
                    handler: onBetterRouteCloseTap
                )
            }

        let profitSeconds = calculateDurationProfit(model, betterRouteInfo)

        // reference mapness/lib/widgets/path_nav/ui/navi_sheet_panel.dart:145
        let minutesRounded = max(
            (Double(profitSeconds) / 60).rounded(.toNearestOrAwayFromZero), 1
        )

        let timeInterval = TimeInterval(minutesRounded * 60)

        let durationFormatter = DateComponentsFormatter()
        durationFormatter.allowedUnits = [.minute]
        durationFormatter.unitsStyle = .short
        durationFormatter.zeroFormattingBehavior = [.default]
        let durationFormatted =
            durationFormatter.string(from: timeInterval) ?? "--"

        return CPNavigationAlert(
            titleVariants: [
                NSLocalizedString("betterRouteDialogTitle", comment: "")
            ],
            subtitleVariants: ["~ " + durationFormatted],
            image: nil,
            primaryAction: startButton,
            secondaryAction: closeButton,
            duration: TimeInterval(-1)
        )
    }
}

extension Address {
    func addressToString() -> String {
        let delimiter = ", "

        let addressComponents = components.reduce("") {
            partial, addressComponent in
            let componentString =
                switch addressComponent {
                case .streetAddress(let addressStreet):
                    addressStreet.number + delimiter + addressStreet.street
                case .number(let number):
                    number.number
                case .location(let location):
                    location.comment
                @unknown default:
                    ""
                }
            return partial + componentString + delimiter
        }

        let drillDownTypes: Set = ["city", "district"]

        let drillDown = drillDown.filter {
            addressAdmDiv in drillDownTypes.contains(addressAdmDiv.type)
        }.reduce("") {
            partial, addressAdmDiv in partial + addressAdmDiv.name + delimiter
        }

        let result = addressComponents + drillDown

        return result.hasSuffix(delimiter)
            ? String(result.dropLast(delimiter.count)) : result
    }
}

extension RouteEditor {
    var activeTrafficRoute: TrafficRoute {
        let activeRouteIndex = activeRouteIndex?.value ?? 0
        return routesInfo.routes[Int(activeRouteIndex)]
    }
}

extension UIColor {
    convenience init(
        _ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat = 1.0
    ) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }
}
