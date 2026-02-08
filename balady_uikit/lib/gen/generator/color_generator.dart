import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:balady_uikit/gen/generator/palette_entity.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

typedef Collection = Map<String, dynamic>;

Builder colorConstantsBuilder(BuilderOptions options) => ColorConstantsGenerator();

class ColorConstantsGenerator implements Builder {
  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final content = await buildStep.readAsString(inputId);
    final ext = buildStep.inputId.extension;
    final colorSchemeName = buildStep.inputId.pathSegments.last.replaceAll(ext, '');
    final jsonData = json.decode(content);
    final colorPalette = ColorPalette.fromJson(jsonData as Map<String, dynamic>);
    for (final collection in colorPalette.collections) {
      if (kDebugMode) {
        print('>>>COLLECTION>>>: ${collection.name}');
      }
      await generatePallette(
        colorPalette.collections,
        collection,
        inputId,
        collection.name,
        colorSchemeName,
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
    String colorSchemeName, {
    required bool isStatic,
  }) {
    final StringBuffer buffer = StringBuffer();

    final name = mode.name;
    buffer
      ..writeln('import "dart:ui";')
      ..writeln('import "../../core/colors/${isStatic ? 'static_' : ''}palette.dart";')
      ..writeln()
      ..writeln('class ${_toCamelCase('${name}_$colorSchemeName')} extends ${isStatic ? 'Static' : ''}Palette {');

    final modeName = mode.name;
    final variables = mode.variables;
    for (final variable in variables) {
      final name = makeColorName(modeName, variable);
      final colorValue = variable.value;

      ///if colors are 'dynamic'(figma term) and get their values
      ///from base palette by name
      if (colorValue case {'collection': final String collectionName, 'name': final String colorName}) {
        final targetCollection = collections.firstWhereOrNull((element) => element.name == collectionName);
        if (targetCollection != null) {
          final colorVariable = targetCollection.modes
              .expand((element) => element.variables)
              .firstWhereOrNull((element) => element.name == colorName);
          if (colorVariable != null) {
            writeColor(colorVariable.value as String, buffer, name);
          }
        }
      } else {
        writeColor(colorValue as String, buffer, name);
      }
    }

    buffer.writeln('}');
    return buffer.toString();
  }

  String makeColorName(String modeName, ColorVariable variable) {
    final name = variable.name
        .replaceAll('/', '_')
        .replaceAll(' ', '_')
        .replaceAll('-', '_')
        .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '')
        .toLowerCase();
    return name;
  }

  void writeColor(String value, StringBuffer buffer, String name) {
    String? parse;
    if (value.length == 7) {
      parse = '0xFF${value.substring(1)}';
    } else if (value.length == 9) {
      final stringBuffer = StringBuffer();
      final substring = value.substring(1);
      stringBuffer
        ..write(substring.substring(6))
        ..write(substring.substring(0, 6));
      final string = stringBuffer.toString();
      parse = '0x$string';
    }
    buffer
      ..writeln('  @override')
      ..writeln('  final ${_toCamelCase(name, false)} = const Color($parse);');
  }

  String _toCamelCase(String text, [bool capitalizeFirst = true]) {
    final words = text.replaceAll('_', ' ').split(' ');
    final wordsBuffer = StringBuffer();
    for (var i = 0; i < words.length; i++) {
      if (i == 0) {
        if (capitalizeFirst) {
          wordsBuffer
            ..write(words[i][0].toUpperCase())
            ..write(words[i].substring(1).toLowerCase());
        } else {
          wordsBuffer.write(words[i].toLowerCase());
        }
      } else {
        wordsBuffer
          ..write(words[i][0].toUpperCase())
          ..write(words[i].substring(1).toLowerCase());
      }
    }

    return wordsBuffer.toString();
  }

  Future<void> generatePallette(List<ColorCollection> collections, ColorCollection collection, AssetId inputId,
      String collectionName, String colorSchemeName) async {
    for (final mode in collection.modes) {
      if (kDebugMode) {
        print('*******************************************************');
        print('>>>>>>>>>>MODE>>>>>>>:${mode.name}---------$collectionName');
      }
      final name = mode.name;

      switch (name) {
        case 'Dark':
        case 'Light':
        case 'Static':
        case 'Dynamic':
          final directory = 'lib/gen/$colorSchemeName';
          final path = "$directory/${name.toLowerCase().replaceAll(' ', '_')}_$colorSchemeName.dart";
          final file = File(path);
          final exists = await file.exists();

          if (!exists) {
            await Directory(directory).create();
          }
          final output = file;
          final generateString = generateColorConstants(
            mode,
            collections,
            colorSchemeName,
            isStatic: name == 'Static',
          );
          await output.writeAsString(generateString);
          if (kDebugMode) {
            print('*******************************************************');
          }
          break;
        default:

          /// NOOP
          break;
      }
    }
  }
}
