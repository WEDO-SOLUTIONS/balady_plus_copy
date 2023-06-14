/// Means Headers in postman | Options -> headers in Dio package
enum ApiHeader {
  // language(customName: "accept-language"),
  language(customName: "lang"),
  source,
  requiresToken,
  verifyingKEY;

  const ApiHeader({this.customName});
  final String? customName;

  /// eName: enum name
  String get eName => customName ?? name;
}
