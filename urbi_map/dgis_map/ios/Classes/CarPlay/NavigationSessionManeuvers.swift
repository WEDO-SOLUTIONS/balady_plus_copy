import CarPlay
import DGis

class NavigationSessionManeuvers {
    private let model: Model
    private let mapTemplate: CPMapTemplate
    private var navigationSession: CPNavigationSession?
    private let eventChannel: DgisStreamHandler?

    init(
        model: Model,
        mapTemplate: CPMapTemplate,
        eventChannel: DgisStreamHandler?
    ) {
        self.model = model
        self.mapTemplate = mapTemplate
        self.eventChannel = eventChannel
}

    private var routePositionChannelCancellable: Cancellable?
    private var routeChannelCancelable: DGis.Cancellable?
    private var everyMinuteTimer: Timer?

    func cancel() {
        routePositionChannelCancellable?.cancel()
        routeChannelCancelable?.cancel()
        everyMinuteTimer?.invalidate()
        navigationSession = nil
    }

    func routeSearch() {
        navigationSession?.pauseTrip(
            for: .rerouting,
            description: NSLocalizedString("navigationRerouting", comment: "")
        )
    }

    func navigate() {
        routeChannelCancelable?.cancel()
        routeChannelCancelable = model.routeChannel.sinkOnMainThread(
            receiveRouteInfo
        )
    }

    private func receiveRouteInfo(routeInfo: RouteInfo) {
        // isFreeRoam
        if routeInfo.routeBuildOptions == nil { return }

        let navigationSession = self.navigationSession ?? mapTemplate.startNavigationSession(
            for: model.route.trip
        )
        self.navigationSession = navigationSession
        
        everyMinuteTimer?.invalidate()
        everyMinuteTimer = Timer.everyMinuteStart {
            [self] _ in
            updateTripEstimates(navigationSession)
        }

        routePositionChannelCancellable?.cancel()
        routePositionChannelCancellable = model.routePositionChannel
            .sinkOnMainThread {
                [self] routePosition in
                updateRouteDetails()
                updateTripEstimates(navigationSession)
                guard let routePosition else { return }
                updateNextManeuver(
                    with: routePosition, navigationSession, routeInfo
                )
            }
    }
    
    private func updateRouteDetails() {
        guard let duration = self.model.duration, let distance = self.model.distance else {
            return
        }

        eventChannel?.success([
            "event": DashboardControlModel.Events.dashboardEvent,
            "duration": Int(duration),
            "distance": distance.value / 1000.0,
            "arrivalTime": DashboardControlModel.dateFormatter.string(from: Date().addingTimeInterval(duration))
        ])
    }

    func finish() {
        navigationSession?.finishTrip()
        cancel()
    }

    func disable() {
        navigationSession?.cancelTrip()
        cancel()
    }

    private func updateTripEstimates(_ navigationSession: CPNavigationSession) {
        let tripDistanceRemaining =
            model.distance ?? Measurement(value: -1, unit: .millimeters)
        let tripTimeRemaining = model.duration ?? TimeInterval(-1)

        mapTemplate.updateEstimates(
            CPTravelEstimates(
                distanceRemaining: tripDistanceRemaining.formatDistance,
                timeRemaining: tripTimeRemaining
            ),
            for: navigationSession.trip
        )
    }

    private func updateNextManeuver(
        with routePoint: RoutePoint,
        _ navigationSession: CPNavigationSession,
        _ routeInfo: RouteInfo
    ) {
        let instructionRouteAttribute = routeInfo.route.instructions

        guard
            let lastInstruction = instructionRouteAttribute.last,
            routePoint.distance.millimeters
                <= lastInstruction.point.distance.millimeters
        else { return }

        let allInstructions = instructionRouteAttribute.entries

        // returns [begin, end) exclusive end - append last
        var actualInstructions = instructionRouteAttribute.entries(
            begin: routePoint, end: lastInstruction.point
        )
        actualInstructions.append(lastInstruction)

        guard actualInstructions.count <= allInstructions.count else { return }

        if actualInstructions.count
            != navigationSession.upcomingManeuvers.count
        {
            navigationSession.upcomingManeuvers = actualInstructions.map(
                mapCPManeuver
            )
        }

        guard
            let nextInstruction = actualInstructions.first,
            let nextManeuver = navigationSession.upcomingManeuvers.first
        else { return }

        let millimetersRemaining =
            (nextInstruction.point.distance.millimeters
            - routePoint.distance.millimeters).millimeters

        navigationSession.updateEstimates(
            mapCPTravelEstimates(millimetersRemaining), for: nextManeuver
        )

        if #available(iOS 17.4, *) {
            navigationSession.maneuverState =
                switch millimetersRemaining.value {
                case ...0:
                    .continue
                case ...1:
                    .execute
                default:
                    .initial
                }
        }
    }

    private func mapCPManeuver(
        with instructionEntry: InstructionRouteEntry
    ) -> CPManeuver {
        let cpManeuver = CPManeuver()

        let instruction = instructionEntry.value

        cpManeuver.instructionVariants = [instruction.roadName]
        cpManeuver.userInfo = instructionEntry
        cpManeuver.initialTravelEstimates = mapCPTravelEstimates(
            instructionEntry.point.distance.millimeters.millimeters)

        if let iconName = mapIconName(instruction.extraInstructionInfo) {
            let raw = UIImage(named: iconName)!
            let desiredSize = CGSize(width: 15, height: 15)
            let resized = raw.resized(to: desiredSize).withRenderingMode(.alwaysOriginal)
            cpManeuver.symbolImage = resized
            cpManeuver.dashboardSymbolImage = resized
        }

        return cpManeuver
    }

    private func mapCPTravelEstimates(
        _ distanceRemaining: Measurement<UnitLength>
    ) -> CPTravelEstimates {
        return CPTravelEstimates(
            distanceRemaining: distanceRemaining.formatMeters,
            timeRemaining: TimeInterval(-1)
        )
    }

    private func mapIconName(_ extraInstructionInfo: ExtraInstructionInfo)
        -> String?
    {
        return
            switch getInstructionManeuver(
                extraInstructionInfo: extraInstructionInfo
            )
        {
        case .none:
            nil
        case .finish:
            "Road_finish"
        case .start, .crossroadStraight:
            "Crossroad_straight"
        case .crossroadSlightlyLeft:
            "Crossroad_slightly_left"
        case .crossroadLeft:
            "Crossroad_left"
        case .crossroadSharplyLeft:
            "Crossroad_sharply_left"
        case .crossroadSlightlyRight:
            "Crossroad_slightly_right"
        case .crossroadRight:
            "Crossroad_right"
        case .crossroadSharplyRight:
            "Crossroad_sharply_right"
        case .crossroadKeepLeft:
            "Crossroad_keep_left"
        case .crossroadKeepRight:
            "Crossroad_keep_right"
        case .roundaboutForward:
            "Ringroad_forward"
        case .roundaboutLeft45:
            "Ringroad_left_45"
        case .roundaboutLeft90:
            "Ringroad_left_90"
        case .roundaboutLeft135:
            "Ringroad_left_135"
        case .roundaboutRight45:
            "Ringroad_right_45"
        case .roundaboutRight90:
            "Ringroad_right_90"
        case .roundaboutRight135:
            "Ringroad_right_135"
        case .roundaboutBackward:
            "Ringroad_backward"
        case .roundaboutExit:
            "Ringroad_exit"
        case .uTurn, .crossroadUTurn:
            "Turn_over_right_hand"
        case .roadCrossing:
            nil
        @unknown default:
            nil
        }
    }
}

extension Measurement<UnitLength> {
    var meters: Double {
        converted(to: .meters).value
    }

    // meters rounded to decameters 420 410 400
    var decametersRounded: Measurement<UnitLength> {
        let tensOfMeters = max(1, meters / 10).rounded(.down)
        let distanceM = tensOfMeters * 10
        return Measurement(value: distanceM, unit: .meters)
    }

    var kilometersOneDecimalRounded: Measurement<UnitLength> {
        let hundredsOfMeters = (meters / 100).rounded(.down)
        let distanceKm = (hundredsOfMeters / 10)
        return Measurement(value: distanceKm, unit: .kilometers)
    }

    // correlated with Dart extension double.formatDistance()
    // mapness/lib/features/path_nav/lib/number_formatters.dart:6
    var formatDistance: Measurement<UnitLength> {
        return meters >= 1000
            ? kilometersOneDecimalRounded
            : decametersRounded
    }

    // correlated with Dart ManeuverEventHandler.formatMeters(int millis)
    // urbi_map/dgis_map_platform_interface/lib/src/control_handlers/navigation/maneuver_event_handler.dart:47
    var formatMeters: Measurement<UnitLength> {
        let measurement = self
        let meters = measurement.meters

        if meters > 3000 {
            // We show in kilometers with an accuracy of up to whole
            let kilometers = (meters / 1000).rounded(.down)
            return Measurement(value: kilometers, unit: .kilometers)
        }

        if meters > 1000 {
            // We show in kilometers with an accuracy of one decimal place
            return kilometersOneDecimalRounded
        }

        if meters > 500 {
            // We show with an accuracy of up to 100 m
            let hundredsOfMeters = (meters / 100).rounded(.down)
            let distanceM = hundredsOfMeters * 100
            return Measurement(value: distanceM, unit: .meters)
        }

        if meters > 250 {
            // We show with an accuracy of up to 50 m
            let fiftiesOfMeters = (meters / 50).rounded(.down)
            let distanceM = fiftiesOfMeters * 50
            return Measurement(value: distanceM, unit: .meters)
        }

        if meters == 0 {
            return Measurement(value: meters, unit: .meters)
        }

        // We show with an accuracy of up to 10 m
        return measurement.decametersRounded
    }
}

extension Int64 {
    var millimeters: Measurement<UnitLength> {
        return Measurement(value: Double(self), unit: UnitLength.millimeters)
    }
}

extension RouteInfo {
    var trip: CPTrip {
        return CPTrip(
            origin: MKMapItem(
                placemark: MKPlacemark(
                    coordinate: CLLocationCoordinate2D(
                        latitude: 0, longitude: 0
                    )
                )
            ),
            destination: MKMapItem(
                placemark: MKPlacemark(
                    coordinate: CLLocationCoordinate2D(
                        latitude: 1, longitude: 1
                    )
                )
            ),
            routeChoices: []
        )
    }
}

extension UIImage {
    /// Return a new UIImage scaled to `size` (points). Uses renderer so it respects scale.
    func resized(to size: CGSize, opaque: Bool = false) -> UIImage {
        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = opaque
        format.scale = self.scale
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        let img = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return img
    }
}




