import 'dart:convert' show json;

// extension FromJsonConversion<T> on String {
//   T fromJson() => json.decode(this);
// }

// extension ToJsonConversion on Map {
//   String toJson() => json.encode(this);
// }

extension JsonConversion<T extends Object, E> on T {
  /// Convert json string to specific data
  E fromJson() => json.decode(this as String);

  /// Convert data to json string
  String toJson() => json.encode(this);
}
