import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
import 'package:mapness/features/poi_card/extensions/contacts_info_ext.dart';
import 'package:mapness/features/poi_card/extensions/date_time_ext.dart';
import 'package:mapness/features/poi_card/extensions/opening_hours_message_ext.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension PoiContentExt on OpeningHoursModel {
  OpenHours? getTodayOpeningInfo(AppLocalizations locale) {
    final todayName = DateTime.now().weekDayName(locale);

    return openingHours?.firstWhereOrNull(
      (e) => e.weekDay.toLowerCase() == todayName.toLowerCase(),
    );
  }
}

extension DirectoryObjectMessageExt on DirectoryObjectMessage {
  OpeningHoursModel getOpeningHoursModel(AppLocalizations locale) {
    final displayOpenHours = openingHours?.getDisplayOpenHours(locale);
    return OpeningHoursModel(
      isAlwaysOpen: openingHours?.isOpen24x7,
      openingHours: displayOpenHours,
      isDailySameOpenHours: openingHours?.defineIsDailySameOpenHours(locale),
    );
  }

  List<ContactsInfoModel> getContactsInfoModels() => contactInfos
      .whereNotNull()
      .map(
        (e) => e.contactsInfo(),
      )
      .toList();
}
