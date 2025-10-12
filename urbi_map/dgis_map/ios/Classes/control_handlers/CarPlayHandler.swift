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
        FlutterCarPlaySceneDelegate.eventChannel = eventChannel
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
    
    // We want to pass params from mobile to CarPlay
    // It could be expandable but for now it works only with sound settings
    func toggleSounds(toggleType: SoundToggleType) {
        FlutterCarPlaySceneDelegate.toggleSounds(toggleType: toggleType)
    }
    
    func onAuthorizationChanged(isAuthorized: Bool) {
        FlutterCarPlaySceneDelegate.onAuthorizationChanged(isAuthorized: isAuthorized)
    }

    
}
