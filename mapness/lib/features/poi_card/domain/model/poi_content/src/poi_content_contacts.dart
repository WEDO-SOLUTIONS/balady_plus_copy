import 'package:mapness/features/poi_card/enums/contacts_info_type.dart';

/// [PoiContentContactsModel] is a model for the contacts section of a POI card.
class PoiContentContactsModel {
  /// List of phone numbers
  final List<String>? phones;

  /// Callback for phone number tap
  final void Function(String phone) onPhoneTap;

  /// List of emails
  final List<String>? emails;

  /// Callback for email tap
  final void Function(String email) onEmailTap;

  /// List of social media
  final List<PoiContentSocialMediaModel>? socialMediaList;

  /// Callback for social media tap
  final Function(String link) onSocialMediaTap;

  const PoiContentContactsModel({
    required this.onPhoneTap,
    required this.onEmailTap,
    required this.onSocialMediaTap,
    this.phones,
    this.emails,
    this.socialMediaList,
  });
}

/// [PoiContentSocialMedia] is a model for the social media section of a POI card.
class PoiContentSocialMediaModel {
  /// Type of the social media
  final PoiContentSocialMediaTypes type;

  /// Display text (username, website address, etc.)
  final String? displayText;

  /// Link to the social media
  final String link;

  const PoiContentSocialMediaModel({required this.type, required this.link, this.displayText});
}

/// [ContactsInfoModel] is a model for the contacts info section of a POI card.
class ContactsInfoModel {
  /// Type of the contact info. This value is received from the SDK.
  final ContactsInfoType type;

  /// Display text of the contact info
  final String? displayText;

  /// Value of the contact info
  final String? value;
  final String? comment;

  const ContactsInfoModel({required this.type, this.displayText, this.value, this.comment});
}

enum PoiContentSocialMediaTypes { website, instagram, facebook, youtube, linkedin, whatsapp, telegram, twitter, tiktok }
