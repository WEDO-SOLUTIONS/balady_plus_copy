import 'package:flutter/material.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/features/special_themes/core/theme_splash_config.dart';
import 'package:mapness/pages/stories/stories_page.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

/// Generic themed splash screen page.
///
/// Replaces the hardcoded [SaudiDaySplashPage] with a theme-aware implementation.
///
/// **Usage:**
/// ```dart
/// Navigator.of(context).push(
///   MaterialPageRoute(
///     builder: (_) => ThemeSplashPage(
///       theme: SpecialThemeMode.nationalDay,
///       onClose: () => Navigator.of(context).pop(),
///     ),
///   ),
/// )
/// ```
///
/// The page automatically determines which story to show based on the theme's
/// [ThemeSplashConfig.storyType].
///
/// NOTE: Not using @RoutePage() because auto_route has issues with enum parameters.
/// This page is used programmatically via MaterialPageRoute instead.
class ThemeSplashPage extends StatefulWidget {
  const ThemeSplashPage({
    required this.theme,
    this.onClose,
    super.key,
  });

  /// The theme mode for which to show the splash screen.
  final SpecialThemeMode theme;

  /// Callback invoked when the user closes the splash screen.
  final Function()? onClose;

  @override
  State<ThemeSplashPage> createState() => _ThemeSplashPageState();
}

class _ThemeSplashPageState extends State<ThemeSplashPage> {
  @override
  void initState() {
    super.initState();
    // Track splash shown
    Metrics.logEventAdvanced(
      MetricsConstants.themesKeys.splashShown,
      group: MetricsConstants.themesTag,
      props: {'theme': widget.theme.name},
    );
  }

  void _handleClose() {
    // Track splash closed
    Metrics.logEventAdvanced(
      MetricsConstants.themesKeys.splashClosed,
      group: MetricsConstants.themesTag,
      action: MetricAction.tap.name,
      props: {'theme': widget.theme.name},
    );
    widget.onClose?.call();
  }

  @override
  Widget build(BuildContext context) {
    final splashConfig = widget.theme.splashConfig;

    // Hide sound icon for Makkah theme since the overlay covers the tap area
    final hideSoundIcon = widget.theme == SpecialThemeMode.mekkahBase;

    return Stack(
      children: [
        // Video background
        StoriesPage(
          type: splashConfig.storyType,
          onClose: _handleClose,
          showSoundIcon: !hideSoundIcon,
          useNavigatorPop: true,
        ),
        // Theme-specific overlay
        if (widget.theme == SpecialThemeMode.mekkahBase) const _MakkahSplashOverlay(),
      ],
    );
  }
}

/// Overlay widget for Makkah theme splash screen.
///
/// Shows welcome text and icon on top of the video.
class _MakkahSplashOverlay extends StatelessWidget {
  const _MakkahSplashOverlay();

  static const _textColor = Color(0xFF131311);

  String _fontFamily(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return isArabic ? 'packages/balady_design_system/IBMPlexSansArabic' : 'packages/balady_uikit/Golos';
  }

  @override
  Widget build(BuildContext context) {
    final fontFamily = _fontFamily(context);

    return IgnorePointer(
      child: SafeArea(
        child: SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              // Icon
              Center(
                child: Image.asset(
                  'assets/icons/makkah/splash.webp',
                  width: 121,
                  height: 121,
                ),
              ),
              const SizedBox(height: 12),
              // Title
              Center(
                child: Text(
                  context.l10n.makkahSplashTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                    height: 30 / 24,
                    color: _textColor,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              Center(
                child: Text(
                  context.l10n.makkahSplashSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    height: 22 / 16,
                    color: _textColor,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              const Spacer(),
              // Bottom text
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Text(
                    context.l10n.makkahSplashBottomText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      height: 20 / 16,
                      color: _textColor,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
