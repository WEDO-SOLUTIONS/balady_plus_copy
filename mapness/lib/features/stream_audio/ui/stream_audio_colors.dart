import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

/// Colors for MBC / stream audio — player chrome is always dark; catalog stays light.
class StreamAudioColors {
  const StreamAudioColors({
    required this.accent,
    required this.accentSoft,
    required this.onAccent,
    required this.brandAccent,
    required this.playerBackground,
    required this.playerText,
    required this.playerMutedText,
    required this.playerBorder,
    required this.playerShadow,
    required this.pageBackground,
    required this.catalogCard,
    required this.catalogText,
    required this.catalogMutedText,
    required this.placeholderIcon,
    required this.exploreCardStart,
    required this.exploreCardEnd,
    required this.exploreHighlight,
    required this.waveGradientStart,
    required this.waveGradientEnd,
  });

  final Color accent;
  final Color accentSoft;
  final Color onAccent;
  final Color brandAccent;
  final Color playerBackground;
  final Color playerText;
  final Color playerMutedText;
  final Color playerBorder;
  final Color playerShadow;
  final Color pageBackground;
  final Color catalogCard;
  final Color catalogText;
  final Color catalogMutedText;
  final Color placeholderIcon;
  final Color exploreCardStart;
  final Color exploreCardEnd;
  final Color exploreHighlight;
  final Color waveGradientStart;
  final Color waveGradientEnd;

  factory StreamAudioColors.of(BuildContext context) {
    final palette = context.colors;

    return StreamAudioColors(
      accent: palette.accentDefault,
      accentSoft: palette.accentSoft,
      onAccent: palette.accentOnAccent,
      brandAccent: const Color(0xFFF24A38),
      playerBackground: const Color(0xff0D121C),
      playerText: Colors.white,
      playerMutedText: const Color(0xB3FFFFFF),
      playerBorder: const Color(0x26FFFFFF),
      playerShadow: const Color(0x7F0D121C),
      pageBackground: palette.backgroundSurface4,
      catalogCard: Colors.white,
      catalogText: palette.foregroundDefault,
      catalogMutedText: palette.foregroundMuted,
      placeholderIcon: palette.accentDefault,
      exploreCardStart: const Color(0xFF1A4D3E),
      exploreCardEnd: const Color(0xFF0B2E1F),
      exploreHighlight: palette.accentSoft,
      waveGradientStart: const Color(0xFF47CD89),
      waveGradientEnd: const Color(0xFF079455),
    );
  }
}

extension StreamAudioColorsX on BuildContext {
  StreamAudioColors get streamAudioColors => StreamAudioColors.of(this);
}
