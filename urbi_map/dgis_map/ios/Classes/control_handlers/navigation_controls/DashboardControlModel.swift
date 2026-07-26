import Foundation
import DGis

class DashboardControlModel {
    class Events {
        static let dashboardEvent = "dashboardEvent"
    }
    
    private let model: Model
    private let navigationManager: NavigationManager
    private let eventChannel: DgisStreamHandler
    private var cancelable: Array<Cancellable> = []
    public static let allCategories: SoundCategoryOptionSet = [
        .crossroadCameras,
        .laneCameras,
        .noStoppingControlCameras,
        .roadMarkingCameras,
        .averageSpeedCameras,
        .maxSpeedCameras,
        .accidents,
        .roadWorks,
        .tolls,
        .exceedSpeedLimits,
        .intermediatePoints,
        .routeRebuild,
        .instructions,
        .obstacles,
        .roadSubtypes,
        .lostLocation,
        .routeEnd
    ]
    
    private let roadCameraCategories: SoundCategoryOptionSet = [
        .crossroadCameras,
        .laneCameras,
        .noStoppingControlCameras,
        .roadMarkingCameras,
        .averageSpeedCameras,
        .maxSpeedCameras
    ]

    
    static let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return formatter
    }()
    
    init(model: Model, eventChannel: DgisStreamHandler, navigationManager: NavigationManager) {
        self.model = model
        self.eventChannel = eventChannel
        self.navigationManager = navigationManager
        
        cancelable.append(contentsOf: [
            self.model.routePositionChannel.sink { [weak self] _ in
                self?.update()
            },
            // Traffic can change without the car moving — keep the timeline fresh.
            self.model.dynamicRouteInfoChannel.sink { [weak self] _ in
                self?.update()
            }
        ])
    }

    private func update() {
        guard let duration = self.model.duration, let distance = self.model.distance else {
            return
        }

        let arrivalTime = DashboardControlModel.dateFormatter.string(from: Date().addingTimeInterval(duration))

        eventChannel.success([
            "event": Events.dashboardEvent,
            "duration": Int(duration),
            "distance": distance.value / 1000.0,
            "arrivalTime": arrivalTime
        ])

        var userInfo: [String: Any] = [
            "duration": Int(duration),
            "distanceKm": distance.value / 1000.0,
            "arrivalTime": arrivalTime
        ]
        let timeline = buildTrafficTimeline()
        userInfo["progress"] = timeline.progress
        userInfo["trafficShares"] = timeline.shares
        userInfo["trafficLevels"] = timeline.levels

        NotificationCenter.default.post(
            name: .dgisNavigationDashboardTick,
            object: nil,
            userInfo: userInfo
        )
    }

    /// Traveled fraction of the route plus its traffic colouring, aggregated into
    /// a handful of segments the lock screen timeline can draw.
    private func buildTrafficTimeline() -> (progress: Double, shares: [Double], levels: [Int]) {
        let totalMm = Double(self.model.route.route.geometry.length.millimeters)
        guard totalMm > 0 else { return (0, [], []) }

        let passedMm = Double(self.model.routePosition?.distance.millimeters ?? 0)
        let progress = min(1, max(0, passedMm / totalMm))

        var shares: [Double] = []
        var levels: [Int] = []
        for entry in self.model.dynamicRouteInfo.traffic.speedColors.entries {
            let share = Double(entry.length.millimeters) / totalMm
            guard share > 0 else { continue }
            let level = Int(entry.value.rawValue)
            // Merge adjacent runs of the same colour and swallow slivers thinner
            // than a pixel of the widget's timeline.
            if let last = levels.last, last == level || share < Self.minSegmentShare {
                shares[shares.count - 1] += share
            } else {
                shares.append(share)
                levels.append(level)
            }
        }

        // Live Activity payloads are capped at 4 KB — keep the timeline compact
        // by folding the thinnest segments into their neighbour.
        while shares.count > Self.maxSegments {
            let index = shares.enumerated().min(by: { $0.element < $1.element })?.offset ?? 0
            let target = index == 0 ? 1 : index - 1
            shares[target] += shares[index]
            shares.remove(at: index)
            levels.remove(at: index)
        }

        return (progress, shares, levels)
    }

    /// ~1px of a 340pt-wide timeline.
    private static let minSegmentShare = 0.003
    private static let maxSegments = 32
    
    func toggleSounds(toggleType: SoundToggleType) {
        let currentCategories = self.navigationManager.soundNotificationSettings.enabledSoundCategories
        
        switch toggleType {
        case SoundToggleType.none:
            // Remove all categories related to sound notifications
            self.navigationManager.soundNotificationSettings.enabledSoundCategories = currentCategories.subtracting(Self.allCategories)

        case SoundToggleType.all:
            // Add all categories
            self.navigationManager.soundNotificationSettings.enabledSoundCategories = currentCategories.union(Self.allCategories)

        case SoundToggleType.important:
            // Remove only the instructions category, keeping the rest
            self.navigationManager.soundNotificationSettings.enabledSoundCategories = currentCategories.subtracting([.instructions])

        @unknown default:
            // Add all categories as a fallback option
            self.navigationManager.soundNotificationSettings.enabledSoundCategories = currentCategories.union(Self.allCategories)
        }
    }

    func toggleRoadCameras(roadCameras: Bool) {
        let currentCategories = self.navigationManager.soundNotificationSettings.enabledSoundCategories

        if roadCameras {
         // When road cameras are disabled: add them back to the current categories
         self.navigationManager.soundNotificationSettings.enabledSoundCategories = currentCategories.union(roadCameraCategories)
        } else {
         // When road cameras are enabled: exclude them from the current categories
         self.navigationManager.soundNotificationSettings.enabledSoundCategories = currentCategories.subtracting(roadCameraCategories)
        }
    }

    func toggleOverSpeeding(overSpeeding: Bool) {
        let currentCategories = self.navigationManager.soundNotificationSettings.enabledSoundCategories

        if overSpeeding {
            // When overspeeding is enabled: add the overspeeding category
            self.navigationManager.soundNotificationSettings.enabledSoundCategories = currentCategories.union(.exceedSpeedLimits)
        } else {
            // When overspeeding is disabled: remove the overspeeding category
            self.navigationManager.soundNotificationSettings.enabledSoundCategories = currentCategories.subtracting(.exceedSpeedLimits)
        }
    }

    func cancel() {
        self.cancelable.forEach { $0.cancel() }
        self.cancelable.removeAll()
    }
}
