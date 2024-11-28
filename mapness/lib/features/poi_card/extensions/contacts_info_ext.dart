import 'package:dgis_map/library.dart';
import 'package:mapness/features/poi_card/domain/model/contacts_info_model.dart';
import 'package:mapness/features/poi_card/enums/contacts_info_type.dart';

extension ContactInfoExt on ContactInfoMessage {
  ContactsInfoModel contactsInfo() => ContactsInfoModel(
        comment: comment,
        displayText: displayText,
        type: ContactsInfoTypeExt.fromString(type),
        value: value,
      );
}
