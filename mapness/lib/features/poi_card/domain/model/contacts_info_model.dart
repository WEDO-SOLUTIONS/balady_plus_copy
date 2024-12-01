import 'package:mapness/features/poi_card/enums/contacts_info_type.dart';

class ContactsInfoModel {
  final ContactsInfoType type;
  final String? displayText;
  final String? value;
  final String? comment;

  const ContactsInfoModel({
    required this.type,
    this.displayText,
    this.value,
    this.comment,
  });
}
