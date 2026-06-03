import Foundation
import DGis

class IndoorControlHandler {
    private class Events {
        static let levelNames = "levelNames"
        static let hideLevels = "hideLevels"
        static let activeLevelIndex = "activeLevelIndex"
    }

    private let eventChannel: DgisStreamHandler?

    private let manager: IndoorManager
    private var focusedBuildingChannel = Cancellable()

    private var _lastKnownLevelId: LevelId?

    var currentLevelId: LevelId? {
        if let building = manager.focusedBuilding {
            let index = Int(building.defaultLevelIndex)
            if building.levels.indices.contains(index) {
                let levelId = building.levels[index].id
                _lastKnownLevelId = levelId
                return levelId
            }
        }
        return _lastKnownLevelId
    }

    private var focusedBuilding: IndoorBuilding? {
        didSet {
            self.focusedBuildingChannel.cancel()

            guard let building = self.focusedBuilding else { return }

            let index = Int(building.defaultLevelIndex)
            if building.levels.indices.contains(index) {
                _lastKnownLevelId = building.levels[index].id
            }

            self.focusedBuildingChannel = building.activeLevelIndexChannel.sinkOnMainThread {
                [weak self] index in
                self?.eventChannel?.success([
                    "event": Events.activeLevelIndex,
                    "value": index
                ])
            }
        }
    }
    private var cancelable: Array<Cancellable> = []

    init(manager: IndoorManager, eventChannel: DgisStreamHandler? = nil) {
        self.manager = manager
        self.eventChannel = eventChannel

        cancelable.append(manager.focusedBuildingChannel.sinkOnMainThread {
            [weak self] building in

            self?.focusedBuilding = building
            guard let building = building else {
                eventChannel?.success([
                    "event": Events.hideLevels,
                ])
                return
            }
            let levels = building.levels.map { $0.name }
            eventChannel?.success([
                "event": Events.levelNames,
                "value": levels,
                "objectId": building.id.objectId
            ])
        })
    }
    
    func selectIndoorLevel(index: UInt64) {
        self.focusedBuilding?.activeLevelIndex = index
    }
    
    func cancel() {
        cancelable.forEach { $0.cancel() }
        cancelable.removeAll()
    }
    
}
