import CoreLocation
import DGis
import Foundation

/**
 Location source for the navigation SDK.

 The SDK's built-in provider never sets `allowsBackgroundLocationUpdates`, so iOS
 stops feeding it as soon as the screen locks — navigation (and with it the lock
 screen Live Activity) freezes until the app is reopened. This provider is the
 same thing with the background flags the app's `UIBackgroundModes` already
 allows, so guidance keeps running with the screen off.
 */
final class BackgroundLocationProvider: NSObject, ILocationProvider {

    private let locationManager = CLLocationManager()
    private var locationCallback: LocationCallback?
    private var availabilityCallback: AvailabilityCallback?
    private var isUpdating = false

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.activityType = .automotiveNavigation
        // The blue status bar pill while we track with the screen off.
        locationManager.showsBackgroundLocationIndicator = true
    }

    func setCallbacks(
        locationCallback: LocationCallback?,
        availabilityCallback: AvailabilityCallback?
    ) {
        self.locationCallback = locationCallback
        self.availabilityCallback = availabilityCallback

        if locationCallback == nil && availabilityCallback == nil {
            stopUpdates()
        } else {
            startUpdatesIfAuthorized()
        }
    }

    func setDesiredAccuracy(_ accuracy: DesiredAccuracy) {
        switch accuracy {
        case .low:
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        case .medium:
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        case .high:
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        @unknown default:
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        }
    }

    private func startUpdatesIfAuthorized() {
        let status = locationManager.authorizationStatus
        guard status == .authorizedAlways || status == .authorizedWhenInUse else {
            availabilityCallback?(false)
            return
        }

        // Only allowed once the app is authorized, and only meaningful with the
        // "location" background mode in Info.plist.
        locationManager.allowsBackgroundLocationUpdates = true

        guard !isUpdating else { return }
        isUpdating = true
        locationManager.startUpdatingLocation()
        availabilityCallback?(true)
    }

    private func stopUpdates() {
        guard isUpdating else { return }
        isUpdating = false
        locationManager.stopUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = false
    }
}

extension BackgroundLocationProvider: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            startUpdatesIfAuthorized()
        case .denied, .restricted:
            stopUpdates()
            availabilityCallback?(false)
        case .notDetermined:
            availabilityCallback?(false)
        @unknown default:
            availabilityCallback?(false)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locations.isEmpty else { return }
        availabilityCallback?(true)
        locationCallback?(locations)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // kCLErrorLocationUnknown is transient — CoreLocation keeps trying.
        if let clError = error as? CLError, clError.code == .locationUnknown {
            return
        }
        availabilityCallback?(false)
    }
}
