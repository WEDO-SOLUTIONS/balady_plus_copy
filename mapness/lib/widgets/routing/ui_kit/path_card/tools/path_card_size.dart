import 'package:balady_uikit/balady_uikit.dart';

class PathCardSize {
  static double getCardHeight({required bool isPedestrian}) => isPedestrian ? 96 : 64;
  static const fixedCardWidth = 264.0;
  static double get fixedCardWidthWithPadding => fixedCardWidth + 2 * Spacing.horizontalGapBetweenChips;
}
