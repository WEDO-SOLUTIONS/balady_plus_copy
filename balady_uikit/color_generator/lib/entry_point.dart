import 'package:balady_color_generator/base_colors.dart';

void colorGeneratorStart() async {
  // Path to the core data of the colors
  const coreFile = 'color_generator/lib/data/core.text';

  // Path to the variations of the themes with core colors
  const themesDirectory = 'color_generator/lib/data/themes';

  await BaseColorsGenerator.init(coreFile, themesDirectory);
}
