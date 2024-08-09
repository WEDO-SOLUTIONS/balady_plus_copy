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
        if toggleType == SoundToggleType.all {
            self.navigationManager.soundNotificationSettings.enabledSoundCategories = Self.allCategories
        } else {
            self.navigationManager.soundNotificationSettings.enabledSoundCategories = []
        }
    }

    func cancel() {
        self.cancelable.forEach { $0.cancel() }
        self.cancelable.removeAll()
    }
}
