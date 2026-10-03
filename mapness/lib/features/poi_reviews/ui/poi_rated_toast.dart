import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:provider/provider.dart';

/// Texts and colour of the "Rated this place" toast. Built in a tap handler, so the theme is read without
/// listening: `context.colors` is a listening Provider lookup and asserts outside build.
class PoiRatedToast {
  final String title;
  final String closeLabel;
  final Color starColor;

  PoiRatedToast.of(BuildContext context)
    : title = context.l10n.poiReviewsRatedToast,
      closeLabel = context.l10n.feedbackBreaksSheetClose,
      starColor = context.read<ThemeController>().colors.warningDefault;
}
