import 'dart:convert' show json;

extension JsonConversion<T extends Object, E> on T {
  /// Convert json string to specific data
  E fromJson() => json.decode(this as String);

  /// Convert data to json string
  String toJson() => json.encode(this);
}
