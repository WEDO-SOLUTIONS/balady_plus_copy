import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapness/entities/city_event/city_event.dart';

/// Remote-config payload behind the TIFO "champions of the month" ribbon.
///
/// Unlike a city event this is not a fixed occasion the app knows in advance:
/// the backend names the winning team and the month it won, so the ribbon can
/// run at any time — including on top of a live city event, whose banner slot
/// it takes over.
///
/// Shape under `tifoChampionRibbon`:
/// ```json
/// {
///   "enabled": true,
///   "from": "01-10-26",
///   "to": "31-10-26",
///   "color": "#161C31",
///   "teamName": "Black Team",
///   "month": 9,
///   "year": 2026
/// }
/// ```
class TifoChampionRibbonConfig extends Equatable {
  const TifoChampionRibbonConfig({
    required this.window,
    required this.color,
    required this.teamName,
    required this.month,
    required this.year,
  });

  /// Nothing to show — what the app falls back to when Remote Config carries
  /// no `tifoChampionRibbon`, or carries one it cannot render.
  factory TifoChampionRibbonConfig.absent() => TifoChampionRibbonConfig(
    window: _absentWindow(),
    color: defaultColor,
    teamName: '',
    month: 1,
    year: 1970,
  );

  /// Built-in sample for the debug override.
  ///
  /// The point of the override is to show the ribbon on demand, so it cannot
  /// depend on Remote Config carrying a payload — on a fresh environment there
  /// is none, and the toggle would look broken. Values are fixed rather than
  /// derived from the clock so two testers always see the same ribbon.
  factory TifoChampionRibbonConfig.debugSample() => TifoChampionRibbonConfig(
    window: CityEventDateRange(DateTime.utc(1970), DateTime.utc(9999, 12, 31)),
    color: defaultColor,
    teamName: 'Black Team',
    month: 9,
    year: 2026,
  );

  /// Takes [Object?] rather than a map on purpose.
  ///
  /// Casting at the call site — `json['tifoChampionRibbon'] as Map?` — throws
  /// when the key exists but holds a string, a number or a list. That throw
  /// escapes before this factory can catch it, and the only handler above
  /// discards the WHOLE environment config: one typo in the ribbon would take
  /// the API endpoints and every other event window down with it. Checking
  /// the type here keeps a malformed ribbon to itself.
  factory TifoChampionRibbonConfig.fromJson(Object? raw) {
    if (raw is! Map) {
      return TifoChampionRibbonConfig.absent();
    }
    final json = raw.cast<String, dynamic>();
    try {
      final teamName = (json['teamName'] as String?)?.trim();
      final month = (json['month'] as num?)?.toInt();
      final year = (json['year'] as num?)?.toInt();
      // A partial payload has no sentence to render — better absent than a
      // ribbon reading " -  Champions!".
      if (teamName == null || teamName.isEmpty || month == null || year == null) {
        return TifoChampionRibbonConfig.absent();
      }
      return TifoChampionRibbonConfig(
        // `from`/`to`/`enabled` sit at the top level of the same object, in the
        // `dd-MM-yy` form every other event uses, so the window parses with
        // the shared code rather than a second date format to keep in step.
        window: CityEventDateRange.fromJson(json, _absentWindow()),
        color: parseColor(json['color'] as String?) ?? defaultColor,
        teamName: teamName,
        month: month.clamp(1, 12),
        year: year,
      );
    } catch (e) {
      debugPrint('Failed to parse TifoChampionRibbonConfig: $e');
      return TifoChampionRibbonConfig.absent();
    }
  }

  /// Ribbon body when Remote Config names no colour — the value the design
  /// ships with (Figma `dashboard_ribbon03`).
  static const Color defaultColor = Color(0xFF161C31);

  /// Window the ribbon may appear in, plus its `enabled` kill switch.
  final CityEventDateRange window;

  /// Flat ribbon body. The design's confetti flecks are deliberately not
  /// reproduced: the backend picks this colour per winning team, and a baked
  /// overlay would fight whatever it sends.
  final Color color;

  final String teamName;

  /// Month and year the team won, as numbers.
  ///
  /// Numbers rather than a ready-made string on purpose: the month has to be
  /// named in the reader's language, and "September" from Remote Config would
  /// stay English under an Arabic locale.
  final int month;
  final int year;

  /// True while the ribbon should be on screen.
  ///
  /// Stricter than [CityEventDateRange.isVisibleNow], which drops the `from`
  /// bound as soon as `enabled` is set — that would put a ribbon on screen for
  /// a month that has not been won yet.
  bool get isVisibleNow => (window.enabled ?? true) && window.isNow;

  /// The month's name in [locale]'s language.
  String monthName(Locale locale) => DateFormat.MMMM(locale.toLanguageTag()).format(DateTime(year, month));

  /// Parses `#RRGGBB` or `#AARRGGBB`, with or without the leading `#`.
  /// Returns null on anything else so the caller can fall back rather than
  /// paint a transparent ribbon.
  static Color? parseColor(String? value) {
    if (value == null) {
      return null;
    }
    final hex = value.trim().replaceFirst('#', '');
    final withAlpha = switch (hex.length) {
      6 => 'FF$hex',
      8 => hex,
      _ => null,
    };
    if (withAlpha == null) {
      return null;
    }
    final parsed = int.tryParse(withAlpha, radix: 16);
    return parsed == null ? null : Color(parsed);
  }

  static CityEventDateRange _absentWindow() =>
      CityEventDateRange(DateTime.utc(1970), DateTime.utc(1970), enabled: false);

  @override
  List<Object?> get props => [window, color, teamName, month, year];
}
