import 'package:mapness/l10n/generated/app_localizations.dart';

enum WeekDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

extension WeekDayExt on WeekDay {
  String localizedShortName(AppLocalizations l10n) => switch (this) {
        WeekDay.monday => l10n.weekdayNameShortMonday,
        WeekDay.tuesday => l10n.weekdayNameShortTuesday,
        WeekDay.wednesday => l10n.weekdayNameShortWednesday,
        WeekDay.thursday => l10n.weekdayNameShortThursday,
        WeekDay.friday => l10n.weekdayNameShortFriday,
        WeekDay.saturday => l10n.weekdayNameShortSaturday,
        WeekDay.sunday => l10n.weekdayNameShortSunday,
      };

  String localizedName(AppLocalizations l10n) => switch (this) {
        WeekDay.monday => l10n.monday,
        WeekDay.tuesday => l10n.tuesday,
        WeekDay.wednesday => l10n.wednesday,
        WeekDay.thursday => l10n.thursday,
        WeekDay.friday => l10n.friday,
        WeekDay.saturday => l10n.saturday,
        WeekDay.sunday => l10n.sunday,
      };
}
