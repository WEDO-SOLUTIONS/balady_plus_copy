part of 'city_event.dart';

class CityEventDateRange extends Equatable {
  final DateTime from;
  final DateTime to;

  const CityEventDateRange(this.from, this.to);

  factory CityEventDateRange.cityscapeDefault() =>
      CityEventDateRange(DateTime(DateTime.now().year, 11, 17), DateTime(DateTime.now().year, 11, 20));

  factory CityEventDateRange.wrcDefault() => CityEventDateRange(DateTime(2025, 11, 25), DateTime(2025, 11, 29));

  factory CityEventDateRange.saudiNationalDayDefault() =>
      CityEventDateRange(DateTime(DateTime.now().year, 9, 18), DateTime(DateTime.now().year, 9, 27, 23, 59, 59));

  factory CityEventDateRange.foundingDayDefault() =>
      CityEventDateRange(DateTime(DateTime.now().year, 2, 22), DateTime(DateTime.now().year, 2, 22));

  /// TIFO isn't a city event, but shares this same Remote Config shape.
  /// Default window: 12 Aug 2026 through end of Oct 2026 — a placeholder
  /// until the backend actually ships its own `tifoDateRange` value.
  factory CityEventDateRange.tifoDefault() =>
      CityEventDateRange(DateTime(2026, 8, 12), DateTime(2026, 10, 31, 23, 59, 59));

  factory CityEventDateRange.fromJson(Map<String, dynamic>? json, CityEventDateRange defaults) {
    try {
      final fromValue = json?['from'] as String?;
      final toValue = json?['to'] as String?;
      if (fromValue == null || toValue == null) {
        return defaults;
      }

      DateTime? tryParse(String date) => DateFormat('dd-MM-yy').tryParse(date);

      return CityEventDateRange(tryParse(fromValue) ?? defaults.from, tryParse(toValue) ?? defaults.to);
    } catch (e) {
      debugPrint('Failed to parse CityEventDateRange: $e');
      return defaults;
    }
  }

  @override
  List<Object?> get props => [from, to];

  bool get isNow => isDateInRange(DateTime.now());

  bool isDateInRange(DateTime dateTime) {
    // we add one day to include the last day in range when checking
    final endDate = to.add(const Duration(days: 1));
    return dateTime == from || (dateTime.isAfter(from) && dateTime.isBefore(endDate));
  }
}
