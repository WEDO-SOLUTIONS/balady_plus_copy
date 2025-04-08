enum SearchRequestLang {
  arabic('ar-SA', 'ar_SA'),
  english('en-SA', 'en_SA'),
  unknown();

  final String? localeForSDK;
  final String? localeForMapness;

  const SearchRequestLang([this.localeForSDK, this.localeForMapness]);
}

class LanguageDetector {
  static bool _isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]');
    return arabicRegex.hasMatch(text);
  }

  static bool _isEnglish(String text) {
    final englishRegex = RegExp(r'[a-zA-Z]');
    return englishRegex.hasMatch(text);
  }

  static SearchRequestLang detectLanguage(String text) {
    if (_isArabic(text)) {
      return SearchRequestLang.arabic;
    } else if (_isEnglish(text)) {
      return SearchRequestLang.english;
    }
    return SearchRequestLang.unknown;
  }

  static SearchRequestLang detectLanguageConLocale(String text, String currentLocale) {
    final hasArabic = _isArabic(text);
    final hasEnglish = _isEnglish(text);
    if (hasArabic && !hasEnglish) {
      return SearchRequestLang.arabic;
    } else if (!hasArabic && hasEnglish) {
      return SearchRequestLang.english;
    }
    for (final value in SearchRequestLang.values) {
      if (value.localeForMapness == currentLocale) {
        return value;
      }
    }
    return SearchRequestLang.unknown;
  }
}
