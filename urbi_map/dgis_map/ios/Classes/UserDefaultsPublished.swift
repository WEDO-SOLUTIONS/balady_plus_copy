import Combine
import Foundation

class UserDefaultsPublished {
    private let userDefaults = UserDefaults.standard

    @Published var languageString: String?
    
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
        let mobileKey = "flutter.voice_instruction_index"
        // It is value that set up from mobile. It is important to keep in mind that
        // a) key could be changed without changing it here
        // b) Order of the [SoundToggleType] could be changed inside mobile app
        // (e.g. it was .all, .importnat, .none but now it is .none, .important, .all
        // and here we will get different value
        let mobileValue = userDefaults.integer(forKey: mobileKey)
        let soundEnableValue = SoundToggleType(rawValue: mobileValue) == .all
        
        // Value from mobile is more important then from CarPlay
        // After initialization we take this value from mobile first
        saveSoundEnabled(soundEnableValue)
        return soundEnableValue
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
