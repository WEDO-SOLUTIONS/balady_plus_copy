import 'package:balady_uikit/balady_uikit.dart' show Spacing;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/balady_uikit/components/text_input/models/input_models.dart';

/// The Input color background. We need to pass it into the Input to shade it from the background
enum BaladyInputBackground {
  white,
  color;

  Color getFillColor(BuildContext context) => switch (this) {
        BaladyInputBackground.white => context.colors.backgroundSurface4,
        BaladyInputBackground.color => context.colors.backgroundSurface1,
      };
}

/// The Input style. It changes font, padding and height
enum BaladyInputStyle {
  input(
    prefixPadding: EdgeInsetsDirectional.only(
      start: Spacing.$3x,
      top: Spacing.$3x,
      bottom: Spacing.$3x,
      end: Spacing.$2x,
    ),
    suffixPadding: EdgeInsetsDirectional.all(Spacing.$3x),
    defaultAlignment: BaladyInputAffixAlignment.center,
  ),
  search(
    prefixPadding: EdgeInsetsDirectional.only(
      start: Spacing.$2x,
      top: Spacing.$2x,
      bottom: Spacing.$2x,
      end: Spacing.$1_5x,
    ),
    suffixPadding: EdgeInsetsDirectional.all(Spacing.$2x),
    defaultAlignment: BaladyInputAffixAlignment.center,
  ),
  multiline(
    prefixPadding: EdgeInsetsDirectional.only(
      start: Spacing.$3x,
      top: Spacing.$2x,
      bottom: Spacing.$2x,
      end: Spacing.$2x,
    ),
    suffixPadding: EdgeInsetsDirectional.only(
      start: Spacing.$3x,
      top: Spacing.$2x,
      bottom: Spacing.$2x,
      end: Spacing.$3x,
    ),
    defaultAlignment: BaladyInputAffixAlignment.top,
  );

  final EdgeInsetsDirectional prefixPadding;
  final EdgeInsetsDirectional suffixPadding;
  final BaladyInputAffixAlignment defaultAlignment;

  const BaladyInputStyle({
    required this.prefixPadding,
    required this.suffixPadding,
    required this.defaultAlignment,
  });
}
