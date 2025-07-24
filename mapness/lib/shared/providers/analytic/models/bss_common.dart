/// Common Attributes Block
class BssCommon {
  const BssCommon({
    required this.appVersion,
    required this.appInstanceId,
    required this.product,
    required this.sessionId,
    required this.user,
    required this.deviceLocale,
    this.formatVersion = 3,
  });

  /// Message format version
  /// For now it is 3
  final int formatVersion;

  /// Version of the application
  /// Mobile - shell version
  final String appVersion;

  /// Unique identifier of the application installation (Application Instance Id).
  final String appInstanceId;

  /// Product ID (86 -Balady App iOS 87 -Balady App Android)
  final int product;

  /// Unique identifier of the user session. Session — user session.
  /// Mobile — session start: application launch, session end: application unloading from memory
  final String sessionId;

  /// Unique stable identifier of the "conditional user".
  /// The semantics of this attribute depends on the product:
  /// for Android, 4 identifies the device and is stable when
  /// reinstalling the application or changing the user on
  /// multi-user devices
  /// for iOS, 4 identifies the installation of the application (stable for 1
  /// installation)
  final String user;

  /// Device locale.
  /// The attribute is generated based on the selected device language, application and
  /// the selected region:
  /// - For iOS:
  /// 1). The first part of the locale is generated from the selected device language
  /// 2). The second part is from the selected region
  /// 3). When changing the language in the application, the first part changes. It can be,
  /// for example, ru_DE.
  /// (The application settings overwrite the first part if it differs from the
  /// system one)
  /// - For Andorid:
  /// 1) When first launched, the device language is viewed
  /// 2) The translation is selected based on the device language
  /// 3) The locale is selected according to the selected translation (ru_RU, en_EN)
  /// ru_DE
  /// 4) Non-existent locales are never used (for example):
  /// if there is no such official language in a given territory, then the territory
  /// is replaced with the default for the language, for example: ru_DE -> ru_RU
  final String deviceLocale;

  Map<String, dynamic> toJson() => {
        'formatVersion': formatVersion,
        'appVersion': appVersion,
        'appInstanceId': appInstanceId,
        'product': product,
      };
}
