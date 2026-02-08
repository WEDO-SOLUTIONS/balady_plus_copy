import 'dart:io';

import 'package:balady_color_generator/constants.dart';
import 'package:balady_color_generator/utils/capitalize.dart';
import 'package:balady_color_generator/utils/color_detector.dart';
import 'package:balady_color_generator/utils/creator_files.dart';
import 'package:balady_color_generator/utils/path_to_name.dart';
import 'package:balady_color_generator/utils/to_camel_case.dart';

class BaseColorsGenerator {
  static final listOfColorKeys = <String>[];
  static final List<String> themes = [];

  /// Base initial method that we need to call to generate the colors
  /// [filePath] is the path to the css core file
  static Future<void> init(String filePath, String directoryOfThemes) async {
    await createBaseColors(filePath);

    await createValuesBaseFolder(filePath);
    await createColorsEnum(directoryOfThemes);

    await createColorScheme(themes);
    await appColorTheme(themes);
  }

  /// Create the base colors from the core file
  /// [filePath] is the path to the css core file
  static Future<void> createBaseColors(String filePath) async {
    final file = await getFile(filePath);
    final lines = await file.readAsLines();

    final sb = StringBuffer();
    sb.writeln('import \'dart:ui\';');
    sb.writeln();
    sb.writeln('class ${baseColorKey.toCamelCaseCapitalized()}$colorClassSuffix {');
    // Collect base colors for list visualization
    final baseEntries = <MapEntry<String, String>>[];

    for (var line in lines) {
      line = line.trim();
      if (line.isNotEmpty && line.startsWith('--$baseColorKey')) {
        final parts = line.split(':');
        final firstPart = parts[0].trim();
        final secondPart = parts[1].trim();
        if (firstPart.isNotEmpty) {
          var nameOfLine = firstPart.replaceAll('--', '');
          if (nameOfLine.startsWith(baseColorKey)) {
            nameOfLine = nameOfLine.replaceFirst('$baseColorKey-', '');
            listOfColorKeys.add(nameOfLine);
            nameOfLine = nameOfLine.toCamelCase();
          }
          final color = secondPart.replaceAll('#', '').replaceAll(';', '');
          final colorToFile = color.getColorFromCSS(color);
          sb.writeln('  static const $nameOfLine = $colorToFile;');
          baseEntries.add(MapEntry(nameOfLine, colorToFile ?? ''));
        }
      }
    }

    // Add a colorList for BaseColors
    sb.writeln('  static List<ColorInfo> colorList() => [');
    for (final entry in baseEntries) {
      final name = entry.key;
      sb.writeln('        ColorInfo(');
      sb.writeln("          name: '$name',");
      sb.writeln('          color: $name,');
      sb.writeln('          opacity: ($name.opacity * 100).toInt(),');
      sb.writeln("          hex: '#\${$name.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',");
      // parent here is the literal source color expression
      sb.writeln("          parent: '${entry.value}',");
      sb.writeln('        ),');
    }
    sb.writeln('      ];');

    sb.writeln('}');

    // Local ColorInfo model for BaseColors file
    sb.writeln('class ColorInfo {');
    sb.writeln('  final String name;');
    sb.writeln('  final Color color;');
    sb.writeln('  final int opacity;');
    sb.writeln('  final String hex;');
    sb.writeln('  final String parent;');
    sb.writeln();
    sb.writeln('  const ColorInfo({');
    sb.writeln('    required this.name,');
    sb.writeln('    required this.color,');
    sb.writeln('    required this.opacity,');
    sb.writeln('    required this.hex,');
    sb.writeln('    required this.parent,');
    sb.writeln('  });');
    sb.writeln('}');

    await createFolder('$whereToPut/$baseColorsFolderName');
    await createFile('$whereToPut/$baseColorsFolderName/${baseColorKey}_colors.dart', sb.toString());
    print('Class generated at: ${baseColorKey}_colors.dart');
  }

  /// Create the folder for the others colors that generated from base colors
  /// For each color we will create a new file and create a class inside
  static Future<void> createValuesBaseFolder(String filePath) async {
    final fileValues = File('$whereToPut/$baseColorsFolderName/$variantColorsFolderName/values.dart');
    if (fileValues.existsSync()) {
      fileValues.deleteSync();
    }

    await fileValues.create(recursive: true);
    await fileValues.writeAsString('// ignore_for_file: directives_ordering\n');

    // Prepare aggregated values list file
    final valuesListFile = File('$whereToPut/$baseColorsFolderName/$variantColorsFolderName/value_color_list.dart');
    if (valuesListFile.existsSync()) {
      valuesListFile.deleteSync();
    }
    await valuesListFile.create(recursive: true);
    final listSB = StringBuffer();
    listSB.writeln('import \'../base_colors.dart\';');
    listSB.writeln('import \'values.dart\';');
    listSB.writeln();
    listSB.writeln('class ValuesColorList {');
    listSB.writeln('  static List<ColorInfo> list() => [');

    for (var colorKey in listOfColorKeys) {
      await createOtherColors(filePath, colorKey);
      final fileName = '${colorKey.toSnakeCase()}_colors.dart'.trim();
      fileValues.writeAsStringSync('export \'src/$fileName\';\n', mode: FileMode.append);

      // Aggregate entries for this colorKey
      final file = await getFile(filePath);
      final lines = await file.readAsLines();
      for (var line in lines) {
        line = line.trim();
        if (line.isNotEmpty && line.startsWith('--$colorKey')) {
          final parts = line.split(':');
          final firstPart = parts[0].trim();
          final colorTint = firstPart.replaceAll('--$colorKey-', '');
          final secondPart = parts[1].trim();

          final number = int.tryParse(colorTint);
          if (number == null) {
            continue;
          }
          final name = '${colorKey.toCamelCase()}.$number';

          String colorExpr;
          if (secondPart.contains('var')) {
            colorExpr = '${baseColorKey.capitalize()}$colorClassSuffix.${colorKey.toCamelCase()}';
          } else {
            final color = secondPart.replaceAll('#', '').replaceAll(';', '');
            colorExpr = color.getColorFromCSS(color) ?? '';
          }

          // Normalize parent string similar to base colors (drop leading const)
          final parentStr = colorExpr.replaceAll('const ', '');

          listSB.writeln('        ColorInfo(');
          listSB.writeln("          name: '$name',");
          listSB.writeln('          color: ${colorKey.toCamelCaseCapitalized()}$colorClassSuffix.\$$number,');
          listSB.writeln(
              '          opacity: (${colorKey.toCamelCaseCapitalized()}$colorClassSuffix.\$$number.opacity * 100).toInt(),');
          listSB.writeln(
              "          hex: '#\${${colorKey.toCamelCaseCapitalized()}$colorClassSuffix.\$$number.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',");
          listSB.writeln("          parent: '$parentStr',");
          listSB.writeln('        ),');
        }
      }
    }

    listSB.writeln('      ];');
    listSB.writeln('}');
    await valuesListFile.writeAsString(listSB.toString());
  }

  /// Create the class of colors inside the directory `values`
  /// [filePath] is the path to the css theme file
  /// [colorKey] is the name of the color, that we will use to create the class
  static Future<void> createOtherColors(String filePath, String colorKey) async {
    final file = await getFile(filePath);

    final lines = await file.readAsLines();

    final sb = StringBuffer();
    sb.writeln('import \'dart:ui\';');
    sb.writeln();
    sb.writeln('import \'../../${baseColorKey}_colors.dart\';');
    sb.writeln();
    sb.writeln('class ${colorKey.toCamelCaseCapitalized()}$colorClassSuffix {');

    for (var line in lines) {
      line = line.trim();

      if (line.isNotEmpty && line.startsWith('--$colorKey')) {
        final parts = line.split(':');
        final firstPart = parts[0].trim();
        final colorTint = firstPart.replaceAll('--$colorKey-', '');
        final secondPart = parts[1].trim();

        // Color tint should be a number if it is not a variable
        final number = int.tryParse(colorTint);
        var nameOfLine = '';
        if (number != null) {
          nameOfLine = '\$$number';
        } else {
          // Skip if it is not a number or other value
          continue;
        }

        var colorToFile = '';
        if (secondPart.contains('var')) {
          colorToFile = '${baseColorKey.capitalize()}$colorClassSuffix.${colorKey.toCamelCase()}';
        } else {
          var color = secondPart.replaceAll('#', '').replaceAll(';', '');
          colorToFile = color.getColorFromCSS(color) ?? '';
        }
        sb.writeln('  static const $nameOfLine = $colorToFile;');
      }
    }

    sb.writeln('}');
    await createFolder('$whereToPut/$baseColorsFolderName/$variantColorsFolderName');
    await createFolder('$whereToPut/$baseColorsFolderName/$variantColorsFolderName/src');
    await createFile(
      '$whereToPut/$baseColorsFolderName/$variantColorsFolderName/src/${colorKey.toSnakeCase()}_colors.dart',
      sb.toString(),
    );
    print('Class generated at: ${colorKey}_colors.dart');
  }

  /// Generate the enum for the themes
  /// Example: light, dark, festival, etc.
  static Future<void> createColorsEnum(String directory) async {
    final dir = Directory(directory);
    themes
      ..clear()
      ..addAll(await dir.list().map((e) => e.path).toList());
  }

  /// Create the color scheme for the themes. This is the main class that will
  /// contain all the colors for the themes
  static Future<void> createColorScheme(List<String> themes) async {
    final file = await getFile(themes.first);

    final lines = await file.readAsLines();

    final sb = StringBuffer();
    sb.writeln('import \'dart:ui\';');
    sb.writeln('import \'values/values.dart\';');
    sb.writeln();
    // -- 1. Create the abstract class
    sb.writeln('abstract class ColorSchemeV3 {');

    final listOfAllColors = <String>[];
    for (var line in lines) {
      line = line.trim();
      final splited = line.split(':');
      final firstPart = splited[0].trim();
      var nameOfLine = firstPart.replaceAll('--', '');
      listOfAllColors.add(nameOfLine.toCamelCase());
      sb.writeln('  final Color ${nameOfLine.toCamelCase()};');
    }

    sb.writeln();
    sb.writeln('  const ColorSchemeV3({');
    for (var color in listOfAllColors) {
      sb.writeln('    required this.$color,');
    }
    sb.writeln('  });');
    // Expose mapping of property name -> parent expression
    sb.writeln('  Map<String, String> parents();');
    sb.writeln('}');
    sb.writeln();

    final themeSB = StringBuffer();
    themeSB.writeln('enum $appThemesEnum {');
    for (var pathToTheme in themes) {
      final fileName = pathToTheme.nameOfFile;
      themeSB.writeln('  $fileName,');
    }
    themeSB.writeln('}');
    await createFile('$whereToPut/$baseColorsFolderName/themes.dart', themeSB.toString());

    for (var pathToTheme in themes) {
      final lightSB = await createTheme(pathToTheme);
      sb.write(lightSB.toString());
    }

    await createFile('$whereToPut/$baseColorsFolderName/scheme_colors.dart', sb.toString());
  }

  /// Create the theme for the themes: light, dark, festival, etc.
  static Future<StringBuffer> createTheme(String filePath) async {
    final sb = StringBuffer();
    final file = await getFile(filePath);
    final fileName = filePath.nameOfFile.capitalize();

    final lines = await file.readAsLines();
    sb.writeln('class ${fileName}ThemeV3 extends ColorSchemeV3 {');
    sb.writeln('  const ${fileName}ThemeV3({');

    final mapOfAllColors = <String, String>{};
    for (var line in lines) {
      line = line.trim();
      final divided = line.split(':');
      final firstPart = divided[0].trim();
      var nameOfLine = firstPart.replaceAll('--', '');
      var color = divided[1].trim().replaceAll('#', '').replaceAll(';', '');
      var colorToFile = '';
      colorToFile = color.getColorFromCSS(color, true) ?? '';
      if (color.contains('var') && colorToFile.isEmpty) {
        final nameAndColor = color.replaceAll('var(--', '').replaceAll(')', '');
        final parts = nameAndColor.split('-');
        parts.removeLast();
        final name = parts.join('-');
        if (listOfColorKeys.contains(name)) {
          final check = nameAndColor.split('-').last;
          if (int.tryParse(check) != null) {
            colorToFile = '${name.toCamelCaseCapitalized()}$colorClassSuffix.\$$check';
          }
        }
      }
      mapOfAllColors[nameOfLine.toCamelCase()] = colorToFile;
    }
    for (var color in mapOfAllColors.entries) {
      sb.writeln('    super.${color.key} = ${color.value},');
    }
    sb.writeln('  });');
    // Expose parents mapping for this theme
    sb.writeln('  @override');
    sb.writeln('  Map<String, String> parents() => {');
    for (var color in mapOfAllColors.entries) {
      final value = color.value.replaceAll('\$', '').replaceAll(')', '');
      sb.writeln("        '${color.key}': '$value',");
    }
    sb.writeln('    };');
    sb.writeln('}');
    sb.writeln();
    return sb;
  }

  /// Theme Extension for the app colors to use it in the app in extensions
  static Future<void> appColorTheme(List<String> themePaths) async {
    final file = await getFile(themePaths.first);

    final lines = await file.readAsLines();

    final sb = StringBuffer();
    sb.writeln('import \'package:flutter/material.dart\';');
    sb.writeln('import \'scheme_colors.dart\';');
    sb.writeln('import \'themes.dart\';');
    sb.writeln();
    sb.writeln('class ColorInfo {');
    sb.writeln('  final String name;');
    sb.writeln('  final Color color;');
    sb.writeln('  final int opacity;');
    sb.writeln('  final String hex;');
    sb.writeln('  final String parent;');
    sb.writeln();
    sb.writeln('  const ColorInfo({');
    sb.writeln('    required this.name,');
    sb.writeln('    required this.color,');
    sb.writeln('    required this.opacity,');
    sb.writeln('    required this.hex,');
    sb.writeln('    required this.parent,');
    sb.writeln('  });');
    sb.writeln();
    sb.writeln('  @override');
    sb.writeln('  String toString() {');
    sb.writeln(
        '    return \'ColorInfo(name: \$name, color: \$color, opacity: \$opacity, hex: \$hex, parent: \$parent)\';');
    sb.writeln('  }');
    sb.writeln('}');
    sb.writeln();
    sb.writeln('class $appColorsThemeClass extends ThemeExtension<$appColorsThemeClass> {');

    final listOfAllColors = <String>[];
    for (var line in lines) {
      line = line.trim();
      final splited = line.split(':');
      final firstPart = splited[0].trim();
      var nameOfLine = firstPart.replaceAll('--', '');
      listOfAllColors.add(nameOfLine.toCamelCase());
      sb.writeln('  final Color ${nameOfLine.toCamelCase()};');
    }

    // Parent sources mapping
    sb.writeln('  final Map<String, String> parents;');

    sb.writeln();
    sb.writeln('  const $appColorsThemeClass({');
    for (var color in listOfAllColors) {
      sb.writeln('    required this.$color,');
    }
    sb.writeln('    required this.parents,');
    sb.writeln('  });');

    sb.writeln('  @override');
    sb.writeln('  ThemeExtension<$appColorsThemeClass> copyWith({');
    for (var color in listOfAllColors) {
      sb.writeln('    Color? $color,');
    }
    sb.writeln('    Map<String, String>? parents,');
    sb.writeln('  }) {');
    sb.writeln('    return $appColorsThemeClass(');
    for (var color in listOfAllColors) {
      sb.writeln('      $color: $color ?? this.$color,');
    }
    sb.writeln('      parents: parents ?? this.parents,');
    sb.writeln('    );');
    sb.writeln('  }');
    sb.writeln();

    sb.writeln('  @override');
    sb.writeln(
        '  ThemeExtension<$appColorsThemeClass> lerp(covariant ThemeExtension<$appColorsThemeClass>? other, double t) {');
    sb.writeAll([
      '    if (other is! $appColorsThemeClass) {\n',
      '      return this;\n',
      '    }\n',
      '    return $appColorsThemeClass(\n',
    ]);
    for (var color in listOfAllColors) {
      sb.writeln('      $color: Color.lerp($color, other.$color, t)!,');
    }
    sb.writeln('      parents: parents,');
    sb.writeAll([
      '    );\n',
      '  }\n',
      '\n',
      '  factory $appColorsThemeClass.palette({required $appThemesEnum themes}) {\n',
      '    final scheme = switch (themes) {\n'
    ]);
    for (var val in themePaths) {
      final fileName = val.nameOfFile;
      sb.writeln('      $appThemesEnum.$fileName => const ${fileName.capitalize()}ThemeV3(),');
    }
    sb.writeln('    };');
    sb.writeln();
    sb.writeln('    return $appColorsThemeClass(');

    for (var color in listOfAllColors) {
      sb.writeln('      $color: scheme.$color,');
    }
    sb.writeln('      parents: scheme.parents(),');
    sb.writeln('    );');
    sb.writeln('  }');
    sb.writeln();

    // Add colorList method
    sb.writeln('  List<ColorInfo> colorList() => [');
    // Sort colors alphabetically by name
    final sortedColors = List<String>.from(listOfAllColors)..sort();
    for (var color in sortedColors) {
      sb.writeln('        ColorInfo(');
      sb.writeln("          name: '$color',");
      sb.writeln('          color: $color,');
      sb.writeln('          opacity: ($color.opacity * 100).toInt(),');
      sb.writeln("          hex: '#\${$color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',");
      sb.writeln("          parent: parents['$color'] ?? '',");
      sb.writeln('        ),');
    }
    sb.writeln('      ];');
    sb.writeln('}');

    await createFile('$whereToPut/$baseColorsFolderName/$appThemeFile.dart', sb.toString());
  }

  /// Generate a colorList method for the theme classes
  /// This method creates a Map<String, Color> that maps color names to their values
  static Future<void> generateColorListMethod(List<String> listOfAllColors) async {
    final sb = StringBuffer();
    sb.writeln('  Map<String, Color> colorList() => {');

    for (var color in listOfAllColors) {
      sb.writeln("        '$color': $color,");
    }

    sb.writeln('      };');

    // Write the colorList method to a separate file for reference
    await createFile('$whereToPut/$baseColorsFolderName/color_list_method.dart', sb.toString());
    print('ColorList method generated at: color_list_method.dart');
  }
}
