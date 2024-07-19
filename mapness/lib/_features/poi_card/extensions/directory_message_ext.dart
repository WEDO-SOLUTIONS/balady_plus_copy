import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/_features/poi_card/domain/model/contacts_info_model.dart';
import 'package:mapness/_features/poi_card/domain/model/opening_hours_model.dart';
import 'package:mapness/_features/poi_card/extensions/contacts_info_ext.dart';
import 'package:mapness/_features/poi_card/extensions/opening_hours_message_ext.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

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
