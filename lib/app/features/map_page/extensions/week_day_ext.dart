import 'package:dgis_map/library.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

extension WeekDayName on WeekDayMessage {
  String displayName() {
    return switch (this) {
      WeekDayMessage.monday => "monday".tr(),
      WeekDayMessage.tuesday => "tuesday".tr(),
      WeekDayMessage.wednesday => "wednesday".tr(),
      WeekDayMessage.thursday => "thursday".tr(),
      WeekDayMessage.friday => "friday".tr(),
      WeekDayMessage.saturday => "saturday".tr(),
      WeekDayMessage.sunday => "sunday".tr()
    };
  }
}
