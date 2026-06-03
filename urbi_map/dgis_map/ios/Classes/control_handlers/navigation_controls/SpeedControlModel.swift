import Foundation
import DGis

class SpeedControlModel {
    private class SpeedEvents {
        // Speed event name
        static let speedEvent = "speedEvent"
        // Specific event names
        static let currentSpeedEvent = "currentSpeedEvent"
        static let speedLimitEvent = "speedLimitEvent"
        static let exceedSpeedLimitEvent = "exceedSpeedLimitEvent"
        static let cameraEvent = "cameraEvent"
    }
    
    private let model: Model
    private let eventChannel: DgisStreamHandler

    private var cancelable: Array<Cancellable> = []
    
    private var speedLimits: FloatRouteLongAttribute?
    private let cameraNotifier: CameraNotifier

    init(model: Model, eventChannel: DgisStreamHandler) {
        self.model = model
        self.eventChannel = eventChannel
        self.cameraNotifier = CameraNotifier(model: model)
        
        cancelable.append(contentsOf: [
            self.model.locationChannel.sinkOnMainThread(locationListener(_:)),
            self.model.routeChannel.sinkOnMainThread(routeInfoListener(_:)),
            self.model.routePositionChannel.sinkOnMainThread(positionListener(_:)),
            self.model.exceedingMaxSpeedLimitChannel.sinkOnMainThread(exceedLimitListener(_:)),
            self.cameraNotifier.cameraProgressChannel.sinkOnMainThread(cameraListener(_:))
        ])
    }
    
    func cancel() {
        self.cancelable.forEach { $0.cancel() }
        self.cancelable.removeAll()
    }
    
    private func locationListener(_ location: Location?) {
        guard let speed = location?.groundSpeed else { return }
        
        let kmph = speed.value * 3.6
        self.eventChannel.success([
                "event": SpeedEvents.speedEvent,
                "speedEvent": SpeedEvents.currentSpeedEvent,
                "value": Int(kmph),
        ])
    }
    
    private func routeInfoListener(_ routeInfo: RouteInfo) {
        self.speedLimits = routeInfo.route.maxSpeedLimits
    }

    private func positionListener(_ position: RoutePoint?) {
        guard let position = position else { return }
        
        guard let entry = self.speedLimits?.entry(point: position) else {
            self.eventChannel.success([
                "event": SpeedEvents.speedEvent,
                "speedEvent": SpeedEvents.speedLimitEvent,
                "value": nil,
            ])
            return
        }

        let maxAllowedSpeed = entry.value * 3.6
        self.eventChannel.success([
            "event": SpeedEvents.speedEvent,
            "speedEvent": SpeedEvents.speedLimitEvent,
            "value": Int(maxAllowedSpeed),
        ])
    }

    private func exceedLimitListener(_ isExceed: Bool) {
        self.eventChannel.success([
            "event": SpeedEvents.speedEvent,
            "speedEvent": SpeedEvents.exceedSpeedLimitEvent,
            "value": isExceed,
        ])
    }

    private func cameraListener(_ cameraInfo: CameraProgressInfo?) {
        guard let cameraInfo = cameraInfo else {
            self.eventChannel.success([
                "event": SpeedEvents.speedEvent,
                "speedEvent": SpeedEvents.cameraEvent,
                "value": nil,
                "direction": nil,
            ])

            return
        }

        if (!cameraInfo.camera.isSpeedCamera() && !cameraInfo.camera.isNoStoppingCamera()) {
            self.eventChannel.success([
                "event": SpeedEvents.speedEvent,
                "speedEvent": SpeedEvents.cameraEvent,
                "value": false,
                "direction": nil,
            ])

            return
        }

        self.eventChannel.success([
            "event": SpeedEvents.speedEvent,
            "speedEvent": SpeedEvents.cameraEvent,
            "value": true,
            "direction": cameraInfo.camera.direction.name(),
        ])
    }
}

private extension RouteCamera {
    func isSpeedCamera() -> Bool {
        return self.purposes.contains(.speedControl) || self.purposes.contains(.averageSpeedControl)
    }
    
    func isNoStoppingCamera() -> Bool {
        return self.purposes.contains(.noStoppingControl)
    }
}

private extension RouteCameraDirection {
    func name() -> String {
        switch self {
            case .against:
                return "AGAINST"
            case .along:
                return "ALONG"
            case .both:
                return "BOTH"
        }
    }
}
