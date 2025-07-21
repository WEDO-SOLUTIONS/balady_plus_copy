import Combine
import Foundation

enum Language: String {
    case en = "english"
    case ar = "arabic"

    var identifier: String {
        switch self {
        case .en: "en_US"
        case .ar: "ar_SA"
        }
    }

    var locale: Locale {
        Locale(identifier: identifier)
    }
}

private var bundleKey: UInt8 = 0

extension Bundle {
    static func syncLanguage() {
        guard let languageString = UserDefaults.standard.languageString,
            let language = Language(rawValue: languageString)
        else { return }
        setBundle(for: language)
    }

    static func setBundle(for language: Language) {
        localizedBundle = getBundle(
            languageString: String(describing: language)
        )
    }

    static func swizzleLocalization() {
        guard self == Bundle.self else { return }

        let originalSelector = #selector(localizedString(forKey:value:table:))
        let swizzledSelector = #selector(
            swizzled_localizedString(forKey:value:table:))

        let originalMethod = class_getInstanceMethod(
            Bundle.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(
            Bundle.self, swizzledSelector)

        if let originalMethod = originalMethod,
            let swizzledMethod = swizzledMethod
        {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }

    static private var localizedBundle: Bundle? {
        get {
            objc_getAssociatedObject(Bundle.main, &bundleKey) as? Bundle
        }
        set {
            objc_setAssociatedObject(
                Bundle.main, &bundleKey, newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    static private func getBundle(languageString: String) -> Bundle {
        if let path = Bundle.main.path(
            forResource: languageString, ofType: "lproj"
        ),
            let langBundle = Bundle(path: path)
        {
            return langBundle
        } else {
            return Bundle.main
        }
    }

    @objc private func swizzled_localizedString(
        forKey key: String, value: String?, table tableName: String?
    ) -> String {
        // Use a custom bundle if specified
        if let bundle = Bundle.localizedBundle {
            return bundle.swizzled_localizedString(
                forKey: key, value: value, table: tableName)
        } else {
            // Calling the original method (after swizzling it's swizzled_localizedString)
            return swizzled_localizedString(
                forKey: key, value: value, table: tableName)
        }
    }
}
