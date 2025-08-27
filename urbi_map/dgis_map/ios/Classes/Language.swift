enum Language: String {
    case en
    case ar

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

extension Locale {
    var languageOrDefault: dgis_map.Language {
        let languageCode =
            if #available(iOS 16.0, *) {
                Locale.current.language.languageCode?.identifier
            } else {
                Locale.current.languageCode
            }

        return dgis_map.Language(rawValue: languageCode ?? "ar") ?? dgis_map.Language.ar
    }
}
