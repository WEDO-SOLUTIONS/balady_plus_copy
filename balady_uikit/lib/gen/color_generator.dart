import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:balady_uikit/gen/palette_entity.dart';
import 'package:collection/collection.dart';
import 'package:build/build.dart';

typedef Collection = Map<String, dynamic>;

Builder colorConstantsBuilder(BuilderOptions options) =>
    ColorConstantsGenerator();

class ColorConstantsGenerator implements Builder {
  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final content = await buildStep.readAsString(inputId);

    final jsonData = json.decode(content);
    final collections = jsonData['collections'];

    var colorPalette = ColorPalette.fromJson(jsonData);

    for (final collection in colorPalette.collections) {
      generatePallette(
        colorPalette.collections,
        collection,
        inputId,
        collection.name,
      );
    }
  }

  @override
  final buildExtensions = const {
    '.json': ['.g.dart']
  };

  String generateColorConstants(
    ColorMode mode,
    List<ColorCollection> collections,
  ) {
    final StringBuffer buffer = StringBuffer();

    final name = mode.name;
    buffer.writeln('import "dart:ui";');
    buffer.writeln('class ${_toCamelCase(name)} {');


      final modeName = mode.name;
      buffer.writeln('  // $modeName');
      final variables = mode.variables;
      for (final variable in variables) {
        var name = makeColorName(modeName, variable);
        var colorValue = variable.value;

        ///если цвета динамические и берут значения из основной палитры
        if (colorValue
            case {
              "collection": String collectionName,
              "name": String colorName
            }) {

          var targetCollection = collections
              .firstWhereOrNull((element) => element.name == collectionName);
          if (targetCollection != null) {
            var colorVariable = targetCollection.modes
                .expand((element) => element.variables)
                .firstWhereOrNull((element) => element.name == colorName);
            if (colorVariable != null) {
              writeColor(colorVariable.value, buffer, name);
            }
          }
        } else {
          writeColor(colorValue, buffer, name);
        }
      }

    buffer.writeln('}');
    return buffer.toString();
  }

  makeColorName(String modeName, ColorVariable variable) {
    final name = variable.name
        .replaceAll('/', '_')
        .replaceAll(' ', '_')
        .replaceAll('-', '_')
        .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '').toLowerCase();
    return name;
  }

  void writeColor(String value, StringBuffer buffer, name) {
    String? parse;
    if (value.length == 7) {
      parse = '0xFF${value.substring(1)}';
    } else if (value.length == 9) {
      parse = '0x${value.substring(1)}';
    }
    buffer.writeln('  static const $name = Color($parse);');
  }

  String _toCamelCase(String text) {
    final words = text.split(' ');
    final camelCaseWords = words.map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    });
    return camelCaseWords.join('');
  }

  void generatePallette(
      List<ColorCollection> collections,
      ColorCollection collection,
      AssetId inputId,
      String collectionName) async {

    for (var mode in collection.modes) {

      var path =
          "lib/gen/${mode.name
          .toLowerCase()
          .replaceAll(' ', '_')}.dart";
      final output = File(path);
      var generateString = generateColorConstants(mode, collections);
      await output.writeAsString(generateString);
    }
  }
}
