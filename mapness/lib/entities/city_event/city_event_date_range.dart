part of 'city_event.dart';

class CityEventDateRange extends Equatable {
  final DateTime from;
  final DateTime to;
  final bool? enabled;

  const CityEventDateRange(this.from, this.to, {this.enabled});

  factory CityEventDateRange.cityscapeDefault() =>
      CityEventDateRange(DateTime(DateTime.now().year, 11, 17), DateTime(DateTime.now().year, 11, 20));

  factory CityEventDateRange.wrcDefault() => CityEventDateRange(DateTime(2025, 11, 25), DateTime(2025, 11, 29));

  factory CityEventDateRange.saudiNationalDayDefault() =>
      CityEventDateRange(DateTime(DateTime.now().year, 9, 18), DateTime(DateTime.now().year, 9, 27, 23, 59, 59));

  factory CityEventDateRange.foundingDayDefault() =>
      CityEventDateRange(DateTime(DateTime.now().year, 2, 22), DateTime(DateTime.now().year, 2, 22));

  factory CityEventDateRange.leapDefault() =>
      CityEventDateRange(DateTime(DateTime.now().year, 8, 31), DateTime(DateTime.now().year, 9, 3, 23, 59, 59));

  /// TIFO isn't a city event, but shares this same Remote Config shape.
  /// Default window: 12 Aug 2026 through end of Oct 2026 — a placeholder
  /// until the backend actually ships its own `tifoDateRange` value.
  factory CityEventDateRange.tifoDefault() =>
      CityEventDateRange(DateTime(2026, 8, 12), DateTime(2026, 10, 31, 23, 59, 59));

  factory CityEventDateRange.fromJson(Map<String, dynamic>? json, CityEventDateRange defaults) {
    try {
      final fromValue = json?['from'] as String?;
      final toValue = json?['to'] as String?;
      final enabledValue = json?['enabled'] as bool?;
      if (fromValue == null || toValue == null) {
        return defaults;
      }

      DateTime? tryParse(String date) => DateFormat('dd-MM-yy').tryParse(date);

      return CityEventDateRange(
        tryParse(fromValue) ?? defaults.from,
        tryParse(toValue) ?? defaults.to,
        enabled: enabledValue ?? defaults.enabled,
      );
    } catch (e) {
      debugPrint('Failed to parse CityEventDateRange: $e');
      return defaults;
    }
  }

  @override
  List<Object?> get props => [from, to, enabled];

  bool get isNow => isDateInRange(DateTime.now());
  bool get isVisibleNow {
    final enabled = this.enabled;
    if (enabled == null) {
      return isNow;
    }

    return enabled && DateTime.now().isBefore(to.add(const Duration(days: 1)));
  }

  bool isDateInRange(DateTime dateTime) {
    final endDate = to.add(const Duration(days: 1));
    return dateTime == from || (dateTime.isAfter(from) && dateTime.isBefore(endDate));
  }
}
