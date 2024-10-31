import '../utils_exports.dart' show AppLanguage;

extension StringConversion on String {
  /// Check if text is hard-coded, it's benefit if you need to localize app
  /// in the future
  String get hardcoded => "$this 🧨";

  /// Convert only first character of phrase to UpperCase
  /// and the rest of characters to LowerCase
  /// e.g. hello World -> Hello world
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  /// Convert only first character of each word to UpperCase
  /// e.g. hello world -> Hello World
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');

  /// Convert only first character of phrase to UpperCase
  /// and put the rest of word as it is
  /// e.g. hello world -> Hello world
  String toPascalCase() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
}

// extension StringEnumConversion on String {
//   /// convert String to Enum
//   Enum toEnum(List<Enum> list) => list.firstWhere((e) => e.name == this);
//   AppLanguage get toAppLanguage =>
//       AppLanguage.values.firstWhere((e) => e.name == this);
// }

extension StringIconChecker on String? {
  bool get isSvgIcon => this != null && this!.contains(".svg");
  bool get isImgIcon => this != null && !this!.contains(".svg");
  bool get isUrl => this != null && this!.startsWith("http");
}
