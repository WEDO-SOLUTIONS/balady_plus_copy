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
            languageString = userDefaults.languageString
        }
    }
    
    // MARK: - Flutter SharedPreferences Keys
    // Flutter stores sound settings with prefix "flutter."
    private enum FlutterKeys {
        // voice_instruction_index: 0 = none, 1 = important, 2 = all
        static let voiceInstructionIndex = "flutter.voice_instruction_index"
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

    /// Reads the phone-side voice instruction setting from Flutter SharedPreferences.
    /// Returns: 0 = none (sound off), 1 = important, 2 = all (sound on).
    /// Defaults to 0 (off) if not set.
    func getFlutterVoiceInstructionIndex() -> Int {
        let hasKey = userDefaults.object(forKey: FlutterKeys.voiceInstructionIndex) != nil
        return hasKey ? userDefaults.integer(forKey: FlutterKeys.voiceInstructionIndex) : 0
    }
}

extension UserDefaults {
    var languageString: String? {
        string(forKey: "flutter.settings.language")
    }
}
