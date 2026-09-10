import 'package:balady_uikit/balady_uikit.dart' show ConfettiGeneratorConfig, ShiningShape;
import 'package:flutter/material.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';

/// Per-club confetti for the champions ribbon.
///
/// Keyed by [tifoResultColorKeys] — the same five keys the penalty-result hero
/// art uses — and resolved through [tifoResultColorKeyFor], which matches a
/// club id, slug or display name by substring. That is what lets Remote Config
/// keep sending a free-form `teamName` (`"Blue Team"`, `"blue-team"`, `"Blue"`)
/// without the ribbon needing a separate identifier field.
abstract final class TifoChampionConfetti {
  /// Shared across every club: only the palette differs.
  static const Duration duration = Duration(milliseconds: 4000);
  static const int _count = 150;
  static const int _commonGradientAppearance = 6;
  static const int _commonShapeAppearance = 1;
  static const double _dissappearStartsAt = 0.4;

  /// Palette for [teamName].
  ///
  /// The name stays free-form on purpose — Remote Config may send anything —
  /// so a club is recognised by substring and an unrecognised one falls back
  /// to [_neutral] rather than to no confetti at all. A championship the app
  /// has never heard of still gets a burst.
  static ConfettiGeneratorConfig forTeamName(String? teamName) =>
      _config(_palettes[tifoResultColorKeyFor(teamName)] ?? _neutral);

  /// The club's own colour, for a ribbon body that has to stand in for one.
  ///
  /// Production takes the body colour from Remote Config, so this is only for
  /// the debug samples — without it every club previewed on the same default
  /// navy and the picker looked broken.
  static Color? ribbonColorFor(String? teamName) => _palettes[tifoResultColorKeyFor(teamName)]?.mostCommon.first;

  static ConfettiGeneratorConfig _config(_Palette palette) => ConfettiGeneratorConfig.confetti(
    count: _count,
    animationDuration: duration,
    gradientColors: palette.gradients,
    mostCommonGradientColors: palette.mostCommon,
    commonGradientAppearance: _commonGradientAppearance,
    commonShapeAppearance: _commonShapeAppearance,
    dissappearStartsAt: _dissappearStartsAt,
    mostCommonConfettiShape: (startPosition, velocity, scale, gradient, x, y, z) =>
        ShiningShape(startPosition, velocity, scale, gradient, x, y, z),
  );

  /// Used when the name matches no club: the ribbon's own teal-and-navy
  /// confetti colours, so an unknown champion's burst still belongs to the
  /// same artwork the flecks on the ribbon are drawn from.
  static const _Palette _neutral = _Palette(
    gradients: [
      [Color(0xff45EBA5), Color(0xff21ABA5)],
      [Color(0xff1D566E), Color(0xff163A5F)],
      [Color(0xffFFFFFF), Color(0xffE8F5EE)],
    ],
    mostCommon: [Color(0xff21ABA5), Color(0xff45EBA5), Color(0xff1D566E)],
  );

  static const Map<String, _Palette> _palettes = {
    'black': _Palette(
      gradients: [
        [Color(0xff6E6E78), Color(0xff9C9CA8)],
        [Color(0xffD9D9D9), Color(0xffABABAB)],
        [Color(0xffFFFFFF), Color(0xffE8E8E8)],
      ],
      mostCommon: [Color(0xff2B2B2B), Color(0xff4F4F4F), Color(0xff121212)],
    ),
    'blue': _Palette(
      gradients: [
        [Color(0xff7A86FF), Color(0xffB8C2FF)],
        [Color(0xff5B2EE5), Color(0xff8F6BFF)],
        [Color(0xffFFFFFF), Color(0xffE6E9FF)],
      ],
      mostCommon: [Color(0xff0101F9), Color(0xff3A3AFF), Color(0xff0000C4)],
    ),
    'yellow': _Palette(
      gradients: [
        [Color(0xffFFF2A0), Color(0xffFFF8D6)],
        [Color(0xffFFB300), Color(0xffFF8F00)],
        [Color(0xffFFFFFF), Color(0xffFFFBE8)],
      ],
      mostCommon: [Color(0xffFEDC00), Color(0xffFFE95C), Color(0xffE8C400)],
    ),
    'red': _Palette(
      gradients: [
        [Color(0xffFF8A70), Color(0xffFFB8A6)],
        [Color(0xff9E1006), Color(0xffED301E)],
        [Color(0xffFFFFFF), Color(0xffFFE3DC)],
      ],
      mostCommon: [Color(0xffED301E), Color(0xffFF5D42), Color(0xffC41708)],
    ),
    'sand': _Palette(
      gradients: [
        [Color(0xffF0E0CC), Color(0xffF8F0E4)],
        [Color(0xff8C6A43), Color(0xff6E4F2C)],
        [Color(0xffFFFFFF), Color(0xffF6EBDC)],
      ],
      mostCommon: [Color(0xffC9A985), Color(0xffE0C3A0), Color(0xffB08F68)],
    ),
  };
}

class _Palette {
  const _Palette({required this.gradients, required this.mostCommon});

  /// Two-stop gradients for the ordinary flecks.
  final List<List<Color>> gradients;

  /// The club's own colours, used for the flecks that dominate the burst.
  final List<Color> mostCommon;
}
