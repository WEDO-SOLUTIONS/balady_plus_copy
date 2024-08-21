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
            // Удаляем все категории, связанные с звуковыми уведомлениями
            self.navigationManager.soundNotificationSettings.enabledSoundCategories = currentCategories.subtracting(Self.allCategories)

        case SoundToggleType.all:
            // Добавляем все категории
            self.navigationManager.soundNotificationSettings.enabledSoundCategories = currentCategories.union(Self.allCategories)

        case SoundToggleType.important:
            // Удаляем только категорию инструкций, оставляя остальные
            self.navigationManager.soundNotificationSettings.enabledSoundCategories = currentCategories.subtracting([.instructions])

        @unknown default:
            // Добавляем все категории как запасной вариант
            self.navigationManager.soundNotificationSettings.enabledSoundCategories = currentCategories.union(Self.allCategories)
        }
    }
    
    func toggleRoadCameras(roadCameras: Bool) {
        let currentCategories = self.navigationManager.soundNotificationSettings.enabledSoundCategories

           if roadCameras {
               // При включении дорожных камер: исключаем из текущих категорий
               self.navigationManager.soundNotificationSettings.enabledSoundCategories = currentCategories.subtracting(roadCameraCategories)
           } else {
               // При выключении дорожных камер: возвращаем категории в текущие
               self.navigationManager.soundNotificationSettings.enabledSoundCategories = currentCategories.union(roadCameraCategories)
           }
    }

    func toggleOverSpeeding(overSpeeding: Bool) {
        let currentCategories = self.navigationManager.soundNotificationSettings.enabledSoundCategories

        if overSpeeding {
            // При включении превышения скорости: устанавливаем все категории
            self.navigationManager.soundNotificationSettings.enabledSoundCategories = currentCategories.union(.exceedSpeedLimits)
        } else {
            // При выключении превышения скорости: убираем категорию превышения скорости
            self.navigationManager.soundNotificationSettings.enabledSoundCategories = currentCategories.subtracting(.exceedSpeedLimits)
        }
    }


    func cancel() {
        self.cancelable.forEach { $0.cancel() }
        self.cancelable.removeAll()
    }
}
