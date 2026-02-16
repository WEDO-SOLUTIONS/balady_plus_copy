import 'package:flutter/material.dart';

import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/widgets/landing/dashboard/city_event_config.dart';

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
}

DashboardThemeConfig dashboardThemeConfigFor(SpecialThemeMode mode, CityEventType? activeEvent) {
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
        backgroundColor: null,
      );

    case SpecialThemeMode.mekkahBase:
      return DashboardThemeConfig(
        useTopHeaderOffset: true,
        offsetOutsideWidgetByTopHeader: true,
        feedbackBannerAssetPath: Assets.images.feedbackDashboard.keyName,
        feedbackBannerGradient: const [Color(0xFF4EC9C0), Color(0xFF2AB3A9)],
        useThemedExploreBackground: true,
        exploreBackgroundGradient: const [
          Colors.transparent,
          Colors.transparent,
        ],
        exploreBackgroundImageBuilder: () => const AssetImage('assets/images/themes/makkah/places_makkah.png'),
        backgroundColor: const Color(0xFFFAF5EE),
      );

    case SpecialThemeMode.ramadan:
      return DashboardThemeConfig(
        useTopHeaderOffset: true,
        offsetOutsideWidgetByTopHeader: true,
        feedbackBannerAssetPath: Assets.images.feedbackDashboard.keyName,
        feedbackBannerGradient: const [Color(0xFF4EC9C0), Color(0xFF2AB3A9)],
        useThemedExploreBackground: true,
        exploreBackgroundGradient: const [
          Colors.transparent,
          Colors.transparent,
        ],
        exploreBackgroundImageBuilder: () => const AssetImage('assets/images/themes/ramadan/places_ramadan.png'),
        backgroundColor: const Color(0xFFFAF5EE),
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
        exploreBackgroundImageBuilder: null,
        backgroundColor: null,
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
        exploreBackgroundImageBuilder: null,
        backgroundColor: null,
      );
  }
}
