/// Means Headers in postman | Options -> headers in Dio package
enum ApiHeader {
  // language(customName: "accept-language"),
  language(customName: "x-language"),
  source,
  requiresToken,
  ;

  const ApiHeader({this.customName});
  final String? customName;

  /// eName: enum name
  String get eName => customName ?? name;
}
