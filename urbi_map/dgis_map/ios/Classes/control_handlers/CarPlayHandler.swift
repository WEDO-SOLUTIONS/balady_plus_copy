import Foundation
import MediaPlayer
import DGis

class CarPlayHandler: CarPlayConnectionSceneDelegate {
    
    private class Events {
        static let carConnection = "carConnectionEvent"
    }
    
    private let eventChannel: DgisStreamHandler
    
    init(eventChannel: DgisStreamHandler) {
        self.eventChannel = eventChannel
        FlutterCarPlaySceneDelegate.delegate = self
    }
    
    func getConnectionState(completion: @escaping (Result<Bool, any Error>) -> Void) {
        let connected = FlutterCarPlaySceneDelegate.map != nil
        completion(Result.success(connected))
    }
    
    func onConnectionStateChanged(connected: Bool) {
        eventChannel.success([
            "event": Events.carConnection,
            "connected": connected,
        ])
    }
}
