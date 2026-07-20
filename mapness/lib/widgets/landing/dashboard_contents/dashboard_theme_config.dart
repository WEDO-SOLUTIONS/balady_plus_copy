import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';

typedef ImageProviderBuilder = ImageProvider Function();

typedef ImageSizeCalculator = double Function(double imageWidth);

class DashboardThemeConfig {
  const DashboardThemeConfig({
    required this.useTopHeaderOffset,
    required this.offsetOutsideWidgetByTopHeader,
    required this.feedbackBannerAssetPath,
    required this.feedbackBannerGradient,
    required this.useThemedExploreBackground,
    required this.exploreBackgroundGradient,
    this.backgroundColor,
    this.exploreBackgroundImageBuilder,
    this.imageSizeCalculator,
    this.searchHintColor,
  });

  final bool useTopHeaderOffset;
  final bool offsetOutsideWidgetByTopHeader;

  final String feedbackBannerAssetPath;
  final List<Color> feedbackBannerGradient;

  final bool useThemedExploreBackground;
  final List<Color> exploreBackgroundGradient;
  final ImageProviderBuilder? exploreBackgroundImageBuilder;
  final Color? backgroundColor;
  final ImageSizeCalculator? imageSizeCalculator;

  final Color? searchHintColor;
}

DashboardThemeConfig dashboardThemeConfigFor(
  SpecialThemeMode mode,
  CityEventType? activeEvent, {
  bool isDark = false,
}) {
  debugPrint('[DarkThemeDebug] dashboardThemeConfigFor mode=$mode isDark=$isDark');
  switch (mode) {
    case SpecialThemeMode.nationalDay:
      return DashboardThemeConfig(
        useTopHeaderOffset: true,
        offsetOutsideWidgetByTopHeader: false,
        feedbackBannerAssetPath: Assets.images.feedbackDashboardSaudiday.keyName,
        feedbackBannerGradient: const [Color(0xFF014850), Color(0xFF00343A)],
        useThemedExploreBackground: true,
        exploreBackgroundGradient: const [
          Colors.transparent,
          Color(0xff00343A),
        ],
        exploreBackgroundImageBuilder: () => Assets.images.backgroundOrnamentSaudiday.provider(),
      );

    case SpecialThemeMode.mekkahBase:
      return DashboardThemeConfig(
        useTopHeaderOffset: true,
        offsetOutsideWidgetByTopHeader: true,
        feedbackBannerAssetPath: Assets.images.feedbackDashboard.keyName,
        feedbackBannerGradient: isDark
            ? const [Color(0xFF14706D), Color(0xFF0D4F4B)]
            : const [Color(0xFF4EC9C0), Color(0xFF2AB3A9)],
        useThemedExploreBackground: true,
        exploreBackgroundGradient: isDark
            ? const [Colors.transparent, Color(0xFF31CDC2)]
            : const [Colors.transparent, Color(0xFFD19D3F)],
        exploreBackgroundImageBuilder: isDark
            ? null
            : () => const AssetImage('assets/images/themes/makkah/places_makkah.webp'),
        backgroundColor: isDark ? const Color(0xFF00141C) : const Color(0xFFFAF5EE),
        searchHintColor: isDark ? const Color.fromRGBO(255, 255, 255, 0.8 * 255) : null,
      );

    case SpecialThemeMode.ramadan:
      return DashboardThemeConfig(
        useTopHeaderOffset: true,
        offsetOutsideWidgetByTopHeader: true,
        feedbackBannerAssetPath: Assets.images.feedbackDashboard.keyName,
        feedbackBannerGradient: isDark
            ? const [Color(0xFF14706D), Color(0xFF0D4F4B)]
            : const [Color(0xFF4EC9C0), Color(0xFF2AB3A9)],
        useThemedExploreBackground: true,
        exploreBackgroundGradient: isDark
            ? const [Colors.transparent, Color(0xFF00141C)]
            : const [Colors.transparent, Colors.transparent],
        exploreBackgroundImageBuilder: isDark
            ? null
            : () => const AssetImage('assets/images/themes/ramadan/places_ramadan.webp'),
        backgroundColor: isDark ? const Color(0xFF00141C) : const Color(0xFFFAF5EE),
      );

    case SpecialThemeMode.base:
      return DashboardThemeConfig(
        useTopHeaderOffset: false,
        offsetOutsideWidgetByTopHeader: true,
        feedbackBannerAssetPath: Assets.images.feedbackDashboard.keyName,
        feedbackBannerGradient: const [Color(0xFF4EC9C0), Color(0xFF2AB3A9)],
        useThemedExploreBackground: false,
        exploreBackgroundGradient: const [
          Colors.transparent,
          Colors.transparent,
        ],
      );
    case SpecialThemeMode.foundationDay:
      return DashboardThemeConfig(
        useTopHeaderOffset: false,
        offsetOutsideWidgetByTopHeader: true,
        feedbackBannerAssetPath: activeEvent.feedbackDashboard,
        feedbackBannerGradient: activeEvent.feedbackDashboardGradientColors,
        useThemedExploreBackground: false,
        imageSizeCalculator: (imageWidth) => imageWidth * 1.2,
        exploreBackgroundGradient: const [
          Colors.transparent,
          Colors.transparent,
        ],
      );
  }
}
