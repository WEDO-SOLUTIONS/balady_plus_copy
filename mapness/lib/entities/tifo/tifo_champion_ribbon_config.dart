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
///   "teamName": "AL SHABAB",
///   "teamNameAr": "الشباب",
///   "month": 9,
///   "year": 2026
/// }
/// ```
class TifoChampionRibbonConfig extends Equatable {
  const TifoChampionRibbonConfig({
    required this.enabled,
    required this.window,
    required this.color,
    required this.teamName,
    required this.month,
    required this.year,
    this.teamNameAr,
  });

  /// Nothing to show — what the app falls back to when Remote Config carries
  /// no `tifoChampionRibbon`, or carries one it cannot render.
  factory TifoChampionRibbonConfig.absent() => TifoChampionRibbonConfig(
    enabled: false,
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
  factory TifoChampionRibbonConfig.debugSample(String teamName, {Color? color}) => TifoChampionRibbonConfig(
    enabled: true,
    window: CityEventDateRange(DateTime.utc(1970), DateTime.utc(9999, 12, 31)),
    // Passed in rather than looked up here: the club palettes live in the
    // feature layer, and an entity must not reach up into it.
    color: color ?? defaultColor,
    teamName: teamName,
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
      final teamName = _readName(json['teamName']);
      final month = (json['month'] as num?)?.toInt();
      final year = (json['year'] as num?)?.toInt();
      // A partial payload has no sentence to render — better absent than a
      // ribbon reading " -  Champions!". `teamNameAr` is NOT required: it only
      // overrides one language, and an environment configured before it existed
      // has to keep working.
      if (teamName == null || month == null || year == null) {
        return TifoChampionRibbonConfig.absent();
      }
      return TifoChampionRibbonConfig(
        // Read here rather than taken from the parsed window: the shared
        // parser substitutes the *defaults* object's `enabled` when the key is
        // missing, so relying on it made an omitted flag mean whatever the
        // fallback happened to say.
        enabled: json['enabled'] as bool? ?? false,
        // `from`/`to` sit at the top level of the same object, in the
        // `dd-MM-yy` form every other event uses, so the window parses with
        // the shared code rather than a second date format to keep in step.
        window: CityEventDateRange.fromJson(json, _absentWindow()),
        color: parseColor(json['color'] as String?) ?? defaultColor,
        teamName: teamName,
        teamNameAr: _readName(json['teamNameAr']),
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

  /// Master switch. Nothing shows while this is false, however right the
  /// dates are — and an absent key counts as false, so the ribbon has to be
  /// switched on deliberately rather than by a window someone left behind.
  final bool enabled;

  /// Window the ribbon may appear in.
  final CityEventDateRange window;

  /// Flat ribbon body. The design's confetti flecks are deliberately not
  /// reproduced: the backend picks this colour per winning team, and a baked
  /// overlay would fight whatever it sends.
  final Color color;

  /// The team's name, rendered as-is. Also the default for Arabic when
  /// [teamNameAr] is not configured.
  ///
  /// Doubles as the lookup the confetti palette is resolved from
  /// (`TifoChampionConfetti.forTeamName`), which is why it stays the free-form
  /// string the backend already sends (`"AL SHABAB"`, `"Blue Team"`,
  /// `"blue-team"`) rather than becoming a translation key.
  final String teamName;

  /// Arabic reading of [teamName], substituted verbatim under an Arabic locale.
  ///
  /// Remote Config owns the translation because the app cannot produce one: it
  /// ships Arabic only for the five colour teams, so a real club
  /// ("AL SHABAB") used to stay Latin for an Arabic reader. Null when the key
  /// is absent, empty or blank — then [teamName] is used in both languages.
  final String? teamNameAr;

  /// Month and year the team won, as numbers.
  ///
  /// Numbers rather than a ready-made string on purpose: the month has to be
  /// named in the reader's language, and "September" from Remote Config would
  /// stay English under an Arabic locale.
  final int month;
  final int year;

  /// True while the ribbon should be on screen: [enabled] first, then the
  /// window.
  ///
  /// Both bounds of the window count, unlike [CityEventDateRange.isVisibleNow],
  /// which drops `from` as soon as `enabled` is set — that would announce a
  /// month before it had been won.
  bool get isVisibleNow => enabled && window.isNow;

  /// The month's name in [locale]'s language.
  String monthName(Locale locale) => DateFormat.MMMM(locale.toLanguageTag()).format(DateTime(year, month));

  /// The team's name for [locale] — [teamNameAr] under Arabic, [teamName]
  /// otherwise. Substituted as sent; the app does not translate it.
  String nameFor(Locale locale) => (locale.languageCode == 'ar' ? teamNameAr : null) ?? teamName;

  /// Trims a name and treats blank as absent, so a key left empty in Remote
  /// Config reads as "not configured" rather than as an empty label.
  static String? _readName(Object? value) {
    if (value is! String) {
      return null;
    }
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

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
  List<Object?> get props => [enabled, window, color, teamName, teamNameAr, month, year];
}
