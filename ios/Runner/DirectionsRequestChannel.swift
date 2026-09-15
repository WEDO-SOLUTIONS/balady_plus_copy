import CoreLocation
import Flutter
import MapKit
import UIKit

/// Captures Apple Maps / Find My directions hand-offs for pre-warmed Flutter engines.
final class DirectionsRequestChannel {
    static let channelName = "momra.balady/directions_request"

    private static var pendingRequest: [String: Any]?
    private static var methodChannel: FlutterMethodChannel?

    static func register(messenger: FlutterBinaryMessenger) {
        methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
        methodChannel?.setMethodCallHandler { call, result in
            switch call.method {
            case "consumePendingDirectionsRequest":
                result(consumePending())
            case "peekPendingDirectionsRequest":
                result(peekPending())
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    /// Returns `true` when the URL was a MapKit directions request, so the caller stops routing it elsewhere.
    /// A request without a usable destination is still ours: it is swallowed, not forwarded as a deep link.
    @discardableResult
    static func handle(url: URL) -> Bool {
        guard MKDirectionsRequest.isDirectionsRequest(url) else { return false }

        let request = MKDirectionsRequest(contentsOf: url)
        guard let payload = makePayload(from: request) else { return true }

        pendingRequest = payload
        methodChannel?.invokeMethod("onDirectionsRequest", arguments: payload)
        return true
    }

    private static func makePayload(from request: MKDirectionsRequest) -> [String: Any]? {
        guard let destination = request.destination else { return nil }

        let destinationCoordinate = destination.placemark.coordinate
        guard CLLocationCoordinate2DIsValid(destinationCoordinate) else { return nil }

        let sourceIsCurrentLocation = request.source?.isCurrentLocation == true
        var payload: [String: Any] = [
            "destinationLatitude": destinationCoordinate.latitude,
            "destinationLongitude": destinationCoordinate.longitude,
            "sourceIsCurrentLocation": sourceIsCurrentLocation,
            "transportType": transportTypeName(request.transportType),
        ]

        if let destinationName = destination.name, !destinationName.isEmpty {
            payload["destinationName"] = destinationName
        }

        if !sourceIsCurrentLocation, let source = request.source {
            let sourceCoordinate = source.placemark.coordinate
            if CLLocationCoordinate2DIsValid(sourceCoordinate) {
                payload["sourceLatitude"] = sourceCoordinate.latitude
                payload["sourceLongitude"] = sourceCoordinate.longitude

                if let sourceName = source.name, !sourceName.isEmpty {
                    payload["sourceName"] = sourceName
                }
            }
        }

        return payload
    }

    private static func transportTypeName(_ transportType: MKDirectionsTransportType) -> String {
        // `.any` is a bit mask covering the other modes, so it has to be matched before them.
        if transportType == .any {
            return "any"
        }
        if transportType.contains(.automobile) {
            return "automobile"
        }
        if transportType.contains(.walking) {
            return "walking"
        }
        if transportType.contains(.transit) {
            return "transit"
        }
        return "any"
    }

    private static func peekPending() -> [String: Any]? {
        pendingRequest
    }

    private static func consumePending() -> [String: Any]? {
        defer { pendingRequest = nil }
        return pendingRequest
    }
}
