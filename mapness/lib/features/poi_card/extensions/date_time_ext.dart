import 'package:mapness/l10n/generated/app_localizations.dart';

extension DateTimeExt on DateTime {
  String weekDayName(AppLocalizations locale) => weekday.weekDayName(locale);

  static List<String> getAllWeekDayNames(AppLocalizations locale) => [
        locale.sunday,
        locale.monday,
        locale.tuesday,
        locale.wednesday,
        locale.thursday,
        locale.friday,
        locale.saturday,
      ];
}

extension IntExt on int {
  String weekDayName(AppLocalizations locale) => switch (this) {
        1 => locale.monday,
        2 => locale.tuesday,
        3 => locale.wednesday,
        4 => locale.thursday,
        5 => locale.friday,
        6 => locale.saturday,
        7 => locale.sunday,
        _ => '',
      };
}
