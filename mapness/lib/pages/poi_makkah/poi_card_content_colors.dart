part of 'poi_makkah_widget_page.dart';

// Note: Color and layout constants are now centralized in MakkahPoiConstants
// for better maintainability and consistency across the codebase.
const double _makkahPhotosMaxHeight = MakkahPoiConstants.photosMaxHeight;

class _MakkahPoiColors {
  final Color cardBackground;
  final Color headerBackground;
  final Color contentCardBackground;
  final Color featureTileBackground;
  final Color titleColor;
  final Color secondaryTextColor;
  final Color iconBackground;
  final Color closeButtonBackground;
  final Color closeButtonIcon;
  final Color directionsButtonBackground;
  final Color directionsButtonForeground;
  final Color actionButtonBackground;
  final Color actionButtonIconColor;
  final bool isDark;

  const _MakkahPoiColors({
    required this.cardBackground,
    required this.headerBackground,
    required this.contentCardBackground,
    required this.featureTileBackground,
    required this.titleColor,
    required this.secondaryTextColor,
    required this.iconBackground,
    required this.closeButtonBackground,
    required this.closeButtonIcon,
    required this.directionsButtonBackground,
    required this.directionsButtonForeground,
    required this.actionButtonBackground,
    required this.actionButtonIconColor,
    this.isDark = false,
  });
}

_MakkahPoiColors _resolveMakkahPoiColors(
  BuildContext context,
  SpecialThemeMode mode, {
  bool isDark = false,
}) {
  if (mode == SpecialThemeMode.mekkahBase || mode == SpecialThemeMode.ramadan) {
    if (isDark) {
      return _MakkahPoiColors(
        cardBackground: MakkahPoiConstants.darkSheet,
        headerBackground: MakkahPoiConstants.darkSunken,
        contentCardBackground: MakkahPoiConstants.darkSunken,
        featureTileBackground: MakkahPoiConstants.darkSheet,
        titleColor: MakkahPoiConstants.darkPrimaryTextColor,
        secondaryTextColor: MakkahPoiConstants.darkSecondaryTextColor,
        // overriden because icons from bucket return this color only
        // iconBackground: MakkahPoiConstants.darkAccentTeal,
        // TODO: replace this back when update the bucket
        iconBackground: const Color(0xffD19D3F),
        closeButtonBackground: MakkahPoiConstants.darkSheet,
        closeButtonIcon: MakkahPoiConstants.darkPrimaryTextColor,
        directionsButtonBackground: MakkahPoiConstants.darkAccentTeal,
        directionsButtonForeground: MakkahPoiConstants.darkPrimaryTextColor,
        actionButtonBackground: MakkahPoiConstants.darkSheet,
        actionButtonIconColor: MakkahPoiConstants.darkPrimaryTextColor,
        isDark: true,
      );
    }
    return const _MakkahPoiColors(
      cardBackground: MakkahPoiConstants.cardBackground,
      headerBackground: MakkahPoiConstants.headerBackground,
      contentCardBackground: MakkahPoiConstants.contentCardBackground,
      featureTileBackground: MakkahPoiConstants.featureTileBackground,
      titleColor: MakkahPoiConstants.primaryTextColor,
      secondaryTextColor: MakkahPoiConstants.secondaryTextColor,
      iconBackground: MakkahPoiConstants.iconBackground,
      closeButtonBackground: MakkahPoiConstants.closeButtonBackground,
      closeButtonIcon: MakkahPoiConstants.closeButtonIcon,
      directionsButtonBackground: MakkahPoiConstants.directionsButtonBackground,
      directionsButtonForeground: Color(0xFFFFFFFF),
      actionButtonBackground: MakkahPoiConstants.actionButtonBackground,
      actionButtonIconColor: MakkahPoiConstants.normalActionIconColor,
    );
  }

  return _MakkahPoiColors(
    cardBackground: context.colors.backgroundSurface1,
    headerBackground: context.colors.backgroundSurface1,
    contentCardBackground: context.colors.backgroundSurface1,
    featureTileBackground: context.colors.backgroundSurface2,
    titleColor: context.colors.foregroundDefault,
    secondaryTextColor: context.colors.foregroundDefault,
    iconBackground: context.colors.backgroundSurface3,
    closeButtonBackground: context.colors.backgroundSurface2,
    closeButtonIcon: context.colors.foregroundMuted,
    directionsButtonBackground: context.colors.accentDefault,
    directionsButtonForeground: context.colors.staticWhite,
    actionButtonBackground: context.colors.backgroundSurface2,
    actionButtonIconColor: context.colors.foregroundDefault,
  );
}

WorkingHours? _workingHoursFromMakkahJson(Map<String, dynamic>? json) {
  if (json == null || json.isEmpty) return null;

  final is24x7 = json['is_24x7'] == true;
  if (is24x7) {
    return WorkingHours(
      Map.fromEntries(
        [
          for (int day = DateTime.monday; day <= DateTime.sunday; day++)
            MapEntry(Duration(days: day), const Duration(hours: 24)),
        ],
      ),
    );
  }

  int? dayToWeekday(String day) => switch (day) {
    'Mon' => DateTime.monday,
    'Tue' => DateTime.tuesday,
    'Wed' => DateTime.wednesday,
    'Thu' => DateTime.thursday,
    'Fri' => DateTime.friday,
    'Sat' => DateTime.saturday,
    'Sun' => DateTime.sunday,
    _ => null,
  };

  Duration? parseTime(int weekday, String? hhmm) {
    if (hhmm == null || hhmm.isEmpty) return null;
    final parts = hhmm.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return Duration(days: weekday, hours: h, minutes: m);
  }

  final map = <Duration, Duration>{};

  for (final entry in json.entries) {
    final weekday = dayToWeekday(entry.key);
    if (weekday == null) continue;
    final dayObj = entry.value;
    if (dayObj is! Map) continue;
    final workingHours = dayObj['working_hours'];
    if (workingHours is! List) continue;

    for (final interval in workingHours) {
      if (interval is! Map) continue;
      final from = parseTime(weekday, interval['from']?.toString());
      final to = parseTime(weekday, interval['to']?.toString());
      if (from == null || to == null) continue;

      final effectiveTo = to < from ? to + const Duration(days: 1) : to;
      final duration = effectiveTo - from;
      if (duration <= Duration.zero) continue;
      map[from] = duration;
    }
  }

  if (map.isEmpty) return null;
  return WorkingHours(map);
}
