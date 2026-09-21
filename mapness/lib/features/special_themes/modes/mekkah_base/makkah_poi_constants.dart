import 'package:flutter/material.dart';

/// Constants for Makkah POI (Places of Interest) UI theming and layout.
///
/// These constants are used across Makkah-themed POI cards, dashboards,
/// and related widgets to ensure visual consistency.
class MakkahPoiConstants {
  MakkahPoiConstants._();

  // ============================================================================
  // Color Palette
  // ============================================================================

  /// Primary card background color (warm beige)
  static const Color cardBackground = Color(0xFFFAF5EE);

  /// Header background color (white)
  static const Color headerBackground = Color(0xFFFFFFFF);

  /// Content card background color (white)
  static const Color contentCardBackground = Color(0xFFFFFFFF);

  /// Feature tile background color (warm beige)
  static const Color featureTileBackground = Color(0xFFFAF5EE);

  /// Primary text color (dark brown)
  static const Color primaryTextColor = Color(0xFF4A3016);

  /// Secondary text color (dark brown, same as primary)
  static const Color secondaryTextColor = Color(0xFF4A3016);

  /// Icon background color (golden)
  static const Color iconBackground = Color(0xFFDAB98A);

  /// Address icon background color (darker golden)
  static const Color addressIconBackground = Color(0xFFD19D3F);

  /// Clock icon background color (golden brown)
  static const Color clockIconBackgroundColor = Color(0xFFD19D3F);

  /// Close button background color (warm beige)
  static const Color closeButtonBackground = Color(0xFFFAF5EE);

  /// Close button icon color (brown)
  static const Color closeButtonIcon = Color(0xFF806E5C);

  /// Directions button background color (green)
  static const Color directionsButtonBackground = Color(0xFF307457);

  /// Action button background color (light grey-beige)
  static const Color actionButtonBackground = Color(0xFFE2DEDA);

  /// Filled action button icon color (golden)
  static const Color filledActionIconColor = Color(0xFFD4A574);

  /// Normal action button icon color (green)
  static const Color normalActionIconColor = Color(0xFF307457);

  /// Preview card gradient overlay color (brown)
  static const Color previewCardOverlayColor = Color(0xFF6E5945);

  // ============================================================================
  // Dark variant tokens (Figma "Makkah theme Dark", node 1412:36442)
  // ============================================================================

  /// Sheet / chrome surface (search bar, chip, quick-action tile, close button)
  static const Color darkSheet = Color(0xFF01222E);

  /// Sunken card surface (head card, body cards, bottom action bar)
  static const Color darkSunken = Color(0xFF00141C);

  /// Accent teal (fact-tile icon bg, Directions CTA, ribbon gradient peak)
  static const Color darkAccentTeal = Color(0xFF31CDC2);

  /// Muted slate (place-card pill tag bg, virtual-tour CTA text)
  static const Color darkMutedSlate = Color(0xFF809AA4);

  /// Dark variant title text
  static const Color darkPrimaryTextColor = Color(0xFFFFFFFF);

  /// Dark variant secondary/subtitle text (white at 0.8 alpha)
  static Color get darkSecondaryTextColor => const Color(0xFFFFFFFF).withOpacity(0.8);

  /// Place preview card bottom gradient overlay color (dark variant)
  static const Color darkPreviewCardOverlayColor = Color(0xFF00232F);

  // ============================================================================
  // Layout & Sizing
  // ============================================================================

  /// Maximum height of the POI photos header section
  static const double photosMaxHeight = 320.0;

  /// Width of place preview card in dashboard
  static const double placeCardWidth = 300.0;

  /// Width of map markers (SVG icons)
  static const double markerIconWidth = 48.0;

  /// Size of feature tile icons
  static const double featureTileIconSize = 28.0;

  /// Size of the icon slot container in feature tiles
  static const double featureTileIconSlotSize = 36.0;

  /// Size of address icon
  static const double addressIconSize = 20.0;

  /// Size of address icon container
  static const double addressIconContainerSize = 28.0;

  // ============================================================================
  // Asset Paths
  // ============================================================================

  /// Base path for Makkah marker icons
  static const String makkahMarkersPath = 'assets/icons/makkah_markers';

  /// Base path for Ramadan marker icons
  static const String ramadanMarkersPath = 'assets/icons/ramadan_markers';

  /// Path to Makkah places background image
  static const String makkahPlacesBackgroundImage = 'assets/images/themes/makkah/places_makkah.webp';

  /// Path to clock icon
  static const String clockIconPath = 'assets/icons/makkah/clock.svg';

  /// Path to pin icon
  static const String pinIconPath = 'assets/icons/makkah/pin.svg';

  /// Path to levels/features icon
  static const String levelsIconPath = 'assets/icons/makkah/levels.svg';

  /// Path to accessibility icon
  static const String accessibilityIconPath = 'assets/icons/makkah/person.svg';

  /// Path to car icon
  static const String carIconPath = 'assets/icons/makkah/car.svg';

  /// Path to walk icon
  static const String walkIconPath = 'assets/icons/makkah/walk.svg';

  /// Path to directions icon
  static const String directionsIconPath = 'assets/icons/makkah/directions.svg';

  /// Path to bookmark icon
  static const String bookmarkIconPath = 'assets/icons/makkah/bookmark.svg';

  /// Path to share icon
  static const String shareIconPath = 'assets/icons/makkah/share.svg';

  /// Path to parking add icon
  static const String parkingAddIconPath = 'assets/icons/makkah/parkingAdd.svg';

  /// Path to instagram icon
  static const String instagramIconPath = 'assets/icons/makkah/instagram.svg';

  /// Path to phone icon (LTR)
  static const String phoneIconPath = 'assets/icons/makkah/phoneLTR.svg';

  /// Path to web icon
  static const String webIconPath = 'assets/icons/makkah/web.svg';

  // ============================================================================
  // Helper Methods
  // ============================================================================

  /// Returns the appropriate marker icons directory based on theme mode.
  static String getMarkerIconsDirectory({required bool isRamadan}) =>
      isRamadan ? ramadanMarkersPath : makkahMarkersPath;
}
