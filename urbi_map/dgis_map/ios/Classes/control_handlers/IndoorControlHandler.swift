import Foundation
import DGis

class IndoorControlHandler {
    private class Events {
        static let levelNames = "levelNames"
        static let activeLevelIndex = "activeLevelIndex"
    }
    
    private let eventChannel: DgisStreamHandler
    
    private let manager: IndoorManager
    private var focusedBuildingChannel = Cancellable()
    private var focusedBuilding: IndoorBuilding? {
        didSet {
            self.focusedBuildingChannel.cancel()
            
            guard let building = self.focusedBuilding else { return }
            
            self.focusedBuildingChannel = building.activeLevelIndexChannel.sink {
                [weak self] index in
                self?.eventChannel.success([
                    "event": Events.activeLevelIndex,
                    "value": index
                ])
            }
        }
    }
    private var cancelable: Array<Cancellable> = []
    
    init(manager: IndoorManager, eventChannel: DgisStreamHandler) {
        self.manager = manager
        self.eventChannel = eventChannel
        
        cancelable.append(manager.focusedBuildingChannel.sink {
            [weak self] building in
            
            self?.focusedBuilding = building
            let levels = building?.levels.map { $0.name } ?? []
            eventChannel.success([
                "event": Events.levelNames,
                "value": levels
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
