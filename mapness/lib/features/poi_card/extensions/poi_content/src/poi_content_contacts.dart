import 'package:dgis_map/library.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
import 'package:mapness/features/poi_card/enums/contacts_info_type.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension PoiContentContactsExt on DirectoryObjectMessage {
  PoiContentContactsModel? getContacts(
    void Function(String) onPhoneTap,
    void Function(String) onEmailTap,
    void Function(String) onSocialMediaTap,
    AppLocalizations locale,
  ) {
    if (contactInfos.isEmpty) {
      return null;
    }

    final phones = contactInfos
        .where(
          (e) => ContactsInfoTypeExt.fromString(e.type) == ContactsInfoType.phone,
        )
        .map((e) => e.displayText)
        .toList();
    final emails = contactInfos
        .where(
          (e) => ContactsInfoTypeExt.fromString(e.type) == ContactsInfoType.email,
        )
        .map((e) => e.displayText)
        .toList();
    final socialMedias = contactInfos
        .map((e) {
          final type = ContactsInfoTypeExt.fromString(e.type);
          final v = type.poiContentSocialMediaType;
          if (v != null) {
            return PoiContentSocialMediaModel(
              type: v,
              link: e.value,
              displayText: e.displayText,
            );
          }
          return null;
        })
        .nonNulls
        .toList();

    return PoiContentContactsModel(
      phones: phones,
      onPhoneTap: (phone) => onPhoneTap(phone),
      emails: emails,
      onEmailTap: (email) => onEmailTap(email),
      socialMediaList: socialMedias,
      onSocialMediaTap: onSocialMediaTap,
    );
  }

  List<ContactsInfoModel> get getContactsInfoModels => contactInfos.nonNulls
      .map(
        (e) => ContactsInfoModel(
          comment: e.comment,
          displayText: e.displayText,
          type: ContactsInfoTypeExt.fromString(e.type),
          value: e.value,
        ),
      )
      .toList();
}
