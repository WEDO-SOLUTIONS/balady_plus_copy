import 'package:mapness/_features/poi_card/enums/contacts_info_type.dart';

class ContactsInfoModel {

  ContactsInfoModel({
    required this.type,
    this.displayText,
    this.value,
    this.comment,
  });
  ContactsInfoType type;
  String? displayText;
  String? value;
  String? comment;
}
