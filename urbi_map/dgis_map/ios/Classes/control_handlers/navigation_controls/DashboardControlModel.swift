import Foundation
import DGis

class DashboardControlModel {
    private class Events {
        static let dashboardEvent = "dashboardEvent"
    }
    
    private let model: Model
    private let navigationManager: NavigationManager
    private let eventChannel: DgisStreamHandler
    private var cancelable: Array<Cancellable> = []
    private static let allCategories: SoundCategoryOptionSet = [
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

    
    private static let dateFormatter = {
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
            }
        ])
    }
    
    private func update() {
        guard let duration = self.model.duration, let distance = self.model.distance else {
            return
        }
        
        eventChannel.success([
            "event": Events.dashboardEvent,
            "duration": Int(duration),
            "distance": distance.value / 1000.0,
            "arrivalTime": DashboardControlModel.dateFormatter.string(from: Date().addingTimeInterval(duration))
        ])
    }
    
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
