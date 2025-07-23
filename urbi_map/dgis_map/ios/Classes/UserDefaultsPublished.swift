import Combine
import Foundation

class UserDefaultsPublished {
    private let userDefaults = UserDefaults.standard

    @Published var languageString: String?

    var language: Language {
        Language(
            rawValue: languageString ?? "ar"
        ) ?? Language.ar
    }

    // CarPlay Settings Keys
    private enum CarPlaySettingsKeys {
        static let parkingEnabled = "carplay.parking.enabled"
        static let soundEnabled = "carplay.sound.enabled"
        static let trafficEnabled = "carplay.traffic.enabled"
    }

    init() {
        self.languageString = userDefaults.languageString

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userDefaultsDidChangeNotification),
            name: UserDefaults.didChangeNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func userDefaultsDidChangeNotification() {
        if userDefaults.languageString != languageString {
            Bundle.syncLanguage()
            languageString = userDefaults.languageString
        }
    }
    
    // MARK: - CarPlay Settings Save/Restore
    
    func saveParkingEnabled(_ enabled: Bool) {
        userDefaults.set(enabled, forKey: CarPlaySettingsKeys.parkingEnabled)
    }
    
    func saveSoundEnabled(_ enabled: Bool) {
        userDefaults.set(enabled, forKey: CarPlaySettingsKeys.soundEnabled)
    }
    
    func saveTrafficEnabled(_ enabled: Bool) {
        userDefaults.set(enabled, forKey: CarPlaySettingsKeys.trafficEnabled)
    }
    
    func getParkingEnabled() -> Bool {
        return userDefaults.bool(forKey: CarPlaySettingsKeys.parkingEnabled)
    }
    
    func getSoundEnabled() -> Bool {
        return userDefaults.bool(forKey: CarPlaySettingsKeys.soundEnabled)
    }
    
    func getTrafficEnabled() -> Bool {
        return userDefaults.bool(forKey: CarPlaySettingsKeys.trafficEnabled)
    }
}

extension UserDefaults {
    var languageString: String? {
        string(forKey: "flutter.settings.language")
    }
}
