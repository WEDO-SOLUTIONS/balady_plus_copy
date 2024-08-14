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
        switch toggleType {
        case .none:
            self.navigationManager.soundNotificationSettings.enabledSoundCategories = []

        case .all:
            self.navigationManager.soundNotificationSettings.enabledSoundCategories = Self.allCategories

        case .important:
            self.navigationManager.soundNotificationSettings.enabledSoundCategories = Self.allCategories.subtracting([.instructions])

        @unknown default:
            self.navigationManager.soundNotificationSettings.enabledSoundCategories = Self.allCategories
        }
    }
    
    func toggleRoadCameras(roadCameras: Bool) {
        self.navigationManager.soundNotificationSettings.enabledSoundCategories = roadCameras ?
            Self.allCategories.subtracting([.crossroadCameras,
                                                    .laneCameras,
                                                    .noStoppingControlCameras,
                                                    .roadMarkingCameras,
                                                    .averageSpeedCameras,
                                                    .maxSpeedCameras])
            : Self.allCategories
    }

    func toggleOverSpeeding(overSpeeding: Bool) {
        self.navigationManager.soundNotificationSettings.enabledSoundCategories = overSpeeding ?
              Self.allCategories
            : Self.allCategories.subtracting([.exceedSpeedLimits])
    }


    func cancel() {
        self.cancelable.forEach { $0.cancel() }
        self.cancelable.removeAll()
    }
}
