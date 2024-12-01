import 'package:dgis_map/library.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension WeekDayName on WeekDayMessage {
  String displayName(AppLocalizations locale) => switch (this) {
        WeekDayMessage.monday => locale.monday,
        WeekDayMessage.tuesday => locale.tuesday,
        WeekDayMessage.wednesday => locale.wednesday,
        WeekDayMessage.thursday => locale.thursday,
        WeekDayMessage.friday => locale.friday,
        WeekDayMessage.saturday => locale.saturday,
        WeekDayMessage.sunday => locale.sunday,
      };
}
