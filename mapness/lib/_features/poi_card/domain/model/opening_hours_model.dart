import 'package:collection/collection.dart';
import 'package:mapness/_features/poi_card/extensions/date_time_ext.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

class OpeningHoursModel {
  final bool? isOpen24x7;
  final bool? isDailySameOpenHours;
  final List<OpenHours>? openingHours;

  const OpeningHoursModel({
    required this.isOpen24x7,
    required this.isDailySameOpenHours,
    required this.openingHours,
  });

  OpenHours? getTodayOpeningInfo(AppLocalizations locale) {
    final todayName = DateTime.now().weekDayName(locale);

    return openingHours?.firstWhereOrNull(
      (e) => e.weekDay.toLowerCase() == todayName.toLowerCase(),
    );
  }
}

class OpenHours {
  final bool isWeekend;
  final String weekDay;
  final String? openHour;
  final String? closeHour;

  const OpenHours({
    required this.isWeekend,
    required this.weekDay,
    this.openHour,
    this.closeHour,
  });
}
