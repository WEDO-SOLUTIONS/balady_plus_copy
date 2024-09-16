enum AppLanguage {
  ar(languages: ['ar', 'en']),
  en(languages: ['en', 'ar']),
  ;

  const AppLanguage({required this.languages});
  final List<String> languages;
}
