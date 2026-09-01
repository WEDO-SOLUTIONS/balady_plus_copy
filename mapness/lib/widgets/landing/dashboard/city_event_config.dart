import 'package:dgis_map/library.dart' as sdk;
import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

/// Logo configuration for event widgets
class EventLogoConfig {
  final String imagePath;
  final double width;
  final Alignment alignment;
  final EdgeInsets padding;
  final Offset? imageOffset;
  final bool hasShimmer;
  final LinearGradient? shimmerGradient;
  final Duration shimmerPeriod;
  final Duration shimmerInterval;
  final bool supportsFireworks;

  const EventLogoConfig({
    required this.imagePath,
    this.width = 90.0,
    this.alignment = Alignment.bottomLeft,
    this.padding = const EdgeInsets.only(left: 24.0, bottom: 6.0), // Spacing.$6x, Spacing.$1_5x
    this.imageOffset,
    this.hasShimmer = true,
    this.shimmerGradient,
    this.shimmerPeriod = const Duration(seconds: 4), // Durations.extralong4
    this.shimmerInterval = const Duration(seconds: 20),
    this.supportsFireworks = false,
  });
}

/// Configuration for city event visual presentation and resources
abstract class CityEventConfig {
  const CityEventConfig();

  // ========== Visual Configuration ==========

  /// Background color for the event banner
  Color getBackgroundColor(BuildContext context);

  /// Text to display on the event banner
  String getText(AppLocalizations l10n);

  /// Optional formatted date range to display
  String? getFormattedDate(BuildContext context) => null;

  /// Vertical offset for the banner
  double get verticalOffset;

  // ========== Map Resources ==========

  /// Custom pin path for POI cards (if applicable)
  String? get customPinPath => null;

  /// Custom marker path for map (if applicable)
  String? get customMarkerPath => null;

  /// Default marker path (if applicable)
  String? get defaultMarkerPath => null;

  /// Global/dashboard image (if applicable)
  String? get globalImagePath => null;

  /// Dashboard logo image (if applicable)
  String? get dashboardImagePath => null;

  // ========== Location Data ==========

  /// Center coordinates for the event (if applicable)
  sdk.GeoPointWithElevationMessage? get center => null;

  /// Object ID for the main event location (if applicable)
  int? get objectId => null;

  Set<int> get additionalObjectIds => const {};

  /// Global marker ID (if applicable)
  String? get globalMarkerId => null;

  // ========== Logo Widget Configuration ==========

  /// Whether to show a logo widget
  bool get hasLogo => false;

  /// Whether to show a dashboard logo
  bool get hasDashboardLogo => false;

  /// Logo configuration (if hasLogo is true)
  EventLogoConfig? get logoConfig => null;

  // ========== Factory ==========

  /// Factory method to create config from event type
  static CityEventConfig? fromEventType(CityEventType? eventType) => switch (eventType) {
    CityEventType.saudiNationalDay => const SaudiNationalDayConfig(),
    CityEventType.cityscape => const CityscapeConfig(),
    CityEventType.foundingDay => const FoundingDayConfig(),
    CityEventType.leap => const LeapConfig(),
    null => null,
  };
}

class SaudiNationalDayConfig extends CityEventConfig {
  const SaudiNationalDayConfig();

  @override
  Color getBackgroundColor(BuildContext context) => const Color(0xFF00343A);

  @override
  String getText(AppLocalizations l10n) => l10n.happy95thYears;

  @override
  double get verticalOffset => -10.0;

  @override
  bool get hasLogo => true;

  @override
  String get globalImagePath => Assets.images.saudiNationalFlag.keyName;

  @override
  EventLogoConfig get logoConfig => EventLogoConfig(
    imagePath: Assets.images.saudiNationalFlag.keyName,
    width: 97.8,
    shimmerGradient: const LinearGradient(
      colors: [Color(0x00C5FFD6), Color(0x00C5FFD6), Color(0xffC5FFD6), Color(0x00C5FFD6), Color(0x00C5FFD6)],
      stops: [0.0, 0.4, 0.5, 0.6, 1.0],
    ),
    supportsFireworks: true,
  );
}

class CityscapeConfig extends CityEventConfig {
  const CityscapeConfig();

  @override
  Color getBackgroundColor(BuildContext context) => const Color(0xFF6B57E0);

  @override
  String getText(AppLocalizations l10n) => l10n.visualCityScape;

  @override
  String? getFormattedDate(BuildContext context) => '17-20 Nov';

  @override
  double get verticalOffset => 10.0;

  @override
  bool get hasLogo => true;

  @override
  String get customPinPath => Assets.icons.svg.icCityscapePin.keyName;

  @override
  String get customMarkerPath => Assets.icons.svg.cityscapeUniqueMarker.keyName;

  @override
  String get defaultMarkerPath => Assets.icons.svg.cityscapeUniqueMarker.keyName;

  @override
  String get globalImagePath => Assets.images.cityscapeGlobal.keyName;

  @override
  sdk.GeoPointWithElevationMessage get center =>
      sdk.GeoPointWithElevationMessage(latitude: 25.252325164174778, longitude: 46.38741921633482, elevation: 0);

  @override
  int get objectId => 70030076677108076;

  @override
  String get globalMarkerId => 'cityscape_global';

  @override
  EventLogoConfig get logoConfig => EventLogoConfig(
    imagePath: globalImagePath,
    padding: const EdgeInsets.only(left: 24.0),
    imageOffset: const Offset(0, 30),
    shimmerGradient: const LinearGradient(
      colors: [Color(0x00C5FFD6), Color(0x00C5FFD6), Color(0xffC5FFD6), Color(0x00C5FFD6), Color(0x00C5FFD6)],
      stops: [0.0, 0.4, 0.5, 0.6, 1.0],
    ),
  );
}

class LeapConfig extends CityEventConfig {
  const LeapConfig();

  @override
  Color getBackgroundColor(BuildContext context) => const Color(0xFF12091C);

  @override
  String getText(AppLocalizations l10n) => l10n.leapDashboard;

  @override
  double get verticalOffset => 10.0;

  @override
  bool get hasLogo => true;

  @override
  String get globalImagePath => Assets.images.leapLogo.keyName;

  @override
  String get customMarkerPath => Assets.icons.svg.leapUniqueMarker.keyName;

  @override
  String get defaultMarkerPath => Assets.icons.svg.leapUniqueMarker.keyName;

  @override
  sdk.GeoPointWithElevationMessage get center =>
      sdk.GeoPointWithElevationMessage(latitude: 25.2515625, longitude: 46.3869375, elevation: 0);

  @override
  int get objectId => 70030076677108076;

  @override
  Set<int> get additionalObjectIds => const {
    70030076677108076,
    40722022671692732,
    49852393786060074,
  };

  @override
  String get globalMarkerId => 'leap_global';

  @override
  EventLogoConfig get logoConfig => EventLogoConfig(
    imagePath: globalImagePath,
    width: 144,
    padding: EdgeInsets.zero,
    imageOffset: const Offset(-10, 17),
  );
}

class FoundingDayConfig extends CityEventConfig {
  const FoundingDayConfig();

  @override
  Color getBackgroundColor(BuildContext context) => const Color(0xFF523B32);

  @override
  String getText(AppLocalizations l10n) => l10n.foundingDayDashboard;

  @override
  double get verticalOffset => 10.0;

  @override
  bool get hasDashboardLogo => true;

  @override
  String get customMarkerPath => Assets.icons.svg.historicDiriyahFort.keyName;

  @override
  String get defaultMarkerPath => Assets.icons.svg.historicDiriyahFort.keyName;

  @override
  String get globalImagePath => Assets.images.foundingDayLogo.keyName;

  @override
  sdk.GeoPointWithElevationMessage get center =>
      sdk.GeoPointWithElevationMessage(latitude: 24.73329, longitude: 46.574939, elevation: 0);

  @override
  int get objectId => 70030076209992609;

  @override
  Set<int> get additionalObjectIds => const {
    70030076676985563,
    70030076209992979,
    70030076209992995,
    70030076209992609,
    70030076209992704,
    70030076209992635,
    70030076527609092,
    70030076676985002,
    70030076676985436,
    70030076209992983,
    70030076676983761,
    70030076676983790,
    70030076209992629,
    70030076209992634,
    70030076567999453,
    70000001101604698,
    70030076209990811,
    70000001094445934,
    70000001097009979,
  };

  @override
  String get globalMarkerId => 'founding_day_global';

  @override
  EventLogoConfig get logoConfig => EventLogoConfig(
    imagePath: globalImagePath,
    width: 130,
    padding: EdgeInsets.zero,
    supportsFireworks: true,
    imageOffset: const Offset(0, -45),
  );
}
