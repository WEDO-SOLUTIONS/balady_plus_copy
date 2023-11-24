import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/_features/poi_card/domain/model/contacts_info_model.dart';
import 'package:mapness/_features/poi_card/domain/model/opening_hours_model.dart';
import 'package:mapness/_features/poi_card/extensions/contacts_info_ext.dart';
import 'package:mapness/_features/poi_card/extensions/opening_hours_message_ext.dart';

extension DirectoryObjectMessageExt on DirectoryObjectMessage {
  OpeningHoursModel getOpeningHoursModel() {
    final displayOpenHours = openingHours?.getDisplayOpenHours();
    return OpeningHoursModel(
      isOpen24x7: openingHours?.isOpen24x7,
      openingHours: displayOpenHours,
      isDailySameOpenHours: openingHours?.defineIsDailySameOpenHours(),
    );
  }

  List<ContactsInfoModel> getContactsInfoModels() {
    return contactInfos
        .whereNotNull()
        .map(
          (e) => e.contactsInfo(),
        )
        .toList();
  }
}
