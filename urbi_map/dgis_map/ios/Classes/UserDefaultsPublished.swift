import Combine
import Foundation

class UserDefaultsPublished {
    private let userDefaults = UserDefaults.standard

    @Published var languageString: String?

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
}

extension UserDefaults {
    var languageString: String? {
        string(forKey: "flutter.settings.language")
    }
}
