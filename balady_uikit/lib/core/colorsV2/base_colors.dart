import 'dart:ui';

class BaseColors {
  static const accent = Color(0xFF31CDC2);
  static const accentSecondary = Color(0xFF003449);
  static const neutral = Color(0xFF898989);
  static const success = Color(0xFF359748);
  static const warning = Color(0xFFF29100);
  static const error = Color(0xFFE0373D);
  static const extra01 = Color(0xFF9547E9);
  static const extra02 = Color(0xFFFFEF03);
  static List<ColorInfo> colorList() => [
        ColorInfo(
          name: 'accent',
          color: accent,
          opacity: (accent.opacity * 100).toInt(),
          hex: '#${accent.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
          parent: 'Color(0xFF31CDC2)',
        ),
        ColorInfo(
          name: 'accentSecondary',
          color: accentSecondary,
          opacity: (accentSecondary.opacity * 100).toInt(),
          hex: '#${accentSecondary.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
          parent: 'Color(0xFF003449)',
        ),
        ColorInfo(
          name: 'neutral',
          color: neutral,
          opacity: (neutral.opacity * 100).toInt(),
          hex: '#${neutral.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
          parent: 'Color(0xFF898989)',
        ),
        ColorInfo(
          name: 'success',
          color: success,
          opacity: (success.opacity * 100).toInt(),
          hex: '#${success.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
          parent: 'Color(0xFF359748)',
        ),
        ColorInfo(
          name: 'warning',
          color: warning,
          opacity: (warning.opacity * 100).toInt(),
          hex: '#${warning.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
          parent: 'Color(0xFFF29100)',
        ),
        ColorInfo(
          name: 'error',
          color: error,
          opacity: (error.opacity * 100).toInt(),
          hex: '#${error.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
          parent: 'Color(0xFFE0373D)',
        ),
        ColorInfo(
          name: 'extra01',
          color: extra01,
          opacity: (extra01.opacity * 100).toInt(),
          hex: '#${extra01.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
          parent: 'Color(0xFF9547E9)',
        ),
        ColorInfo(
          name: 'extra02',
          color: extra02,
          opacity: (extra02.opacity * 100).toInt(),
          hex: '#${extra02.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
          parent: 'Color(0xFFFFEF03)',
        ),
      ];
}
class ColorInfo {
  final String name;
  final Color color;
  final int opacity;
  final String hex;
  final String parent;

  const ColorInfo({
    required this.name,
    required this.color,
    required this.opacity,
    required this.hex,
    required this.parent,
  });
}
