import 'package:balady_color_generator/utils/capitalize.dart';

extension ToCamelCase on String {
  String toCamelCase() {
    if (contains('-')) {
      var parts = split('-');
      var result = StringBuffer();
      for (var i = 0; i < parts.length; i++) {
        var part = parts[i];
        if (i > 0) {
          result.write('${part[0].toUpperCase()}${part.substring(1)}');
        } else {
          result.write(part);
        }
      }
      return result.toString();
    }
    return this;
  }

  String toCamelCaseCapitalized() {
    return toCamelCase().capitalize();
  }

  String toSnakeCase() {
    if (contains('-')) {
      var parts = split('-');
      var result = StringBuffer();
      for (var i = 0; i < parts.length; i++) {
        var part = parts[i];
        if (i > 0) {
          result.write('_${part.toLowerCase()}');
        } else {
          result.write(part.toLowerCase());
        }
      }
      return result.toString();
    }
    return this;
  }
}
