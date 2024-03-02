import 'package:dgis_map/library.dart';
import 'package:intl/intl.dart';
import 'package:mapness/_features/poi_card/extensions/week_day_ext.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension WeekTimeIntervalData on WeekTimeIntervalMessage {
  String displayStartTime({bool? format24}) {
    final startHours = startTime.time.hours.toString().padLeft(2, '0');
    final startMinutes = startTime.time.minutes.toString().padLeft(2, '0');
    final startTemp = DateFormat('hh:mm').parse('$startHours:$startMinutes');

    return format24 == true
        ? DateFormat('hh:mm').format(startTemp)
        : DateFormat('hh:mm a').format(startTemp);
  }

  String displayFinishTime({bool? format24}) {
    final finishHours = finishTime.time.hours.toString().padLeft(2, '0');
    final finishMinutes = finishTime.time.minutes.toString().padLeft(2, '0');
    final finishTemp = DateFormat('hh:mm').parse('$finishHours:$finishMinutes');

    return format24 == true
        ? DateFormat.Hm().format(finishTemp)
        : DateFormat.jm().format(finishTemp);
  }

  String displayStartFinishTime({bool? format24}) {
    final startTime = displayStartTime(format24: true);
    final finishTime = displayFinishTime(format24: true);
    return '$startTime-$finishTime';
  }

  String displayWeekDayName(AppLocalizations locale) => startTime.weekDay.displayName(locale);
}
