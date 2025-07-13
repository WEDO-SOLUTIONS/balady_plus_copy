import 'package:balady_uikit/balady_uikit.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/src/poi_content_contacts.dart';

/// SDK values that we receive. Mainly we will not use all of it but we have to
/// parse it to be sure that we can cover all possible cases
///
/// Link to SDK: https://docs.2gis.com/en/android/sdk/reference/10.5/ru.dgis.sdk.directory.ContactInfo
enum ContactsInfoType {
  email,
  website,
  phone,
  fax,
  pobox,
  icq,
  jabber,
  skype,
  vkontakte,
  twitter,
  odnoklassniki,
  youtube,
  linkedin,
  googleplus,
  pinterest,
  whatsapp,
  viber,
  telegram,

  /// Not in SDK documentation
  mobile,

  /// Not in SDK documentation
  /// Because in Russian Federation government prohibited to use this social networks and 2GIS SDK located
  /// in the jurisdiction of Russia they have to remove it from public SDK documentation
  instagram,
  facebook,
}

extension ContactsInfoTypeExt on ContactsInfoType {
  static ContactsInfoType fromString(String typeName) => switch (typeName) {
        'email' => ContactsInfoType.email,
        'website' => ContactsInfoType.website,
        'phone' => ContactsInfoType.phone,
        'fax' => ContactsInfoType.fax,
        'pobox' => ContactsInfoType.pobox,
        'icq' => ContactsInfoType.icq,
        'jabber' => ContactsInfoType.jabber,
        'skype' => ContactsInfoType.skype,
        'vkontakte' => ContactsInfoType.vkontakte,
        'twitter' => ContactsInfoType.twitter,
        'odnoklassniki' => ContactsInfoType.odnoklassniki,
        'youtube' => ContactsInfoType.youtube,
        'linkedin' => ContactsInfoType.linkedin,
        'googleplus' => ContactsInfoType.googleplus,
        'pinterest' => ContactsInfoType.pinterest,
        'whatsApp' => ContactsInfoType.whatsapp,
        'viber' => ContactsInfoType.viber,
        'telegram' => ContactsInfoType.telegram,
        'mobile' => ContactsInfoType.mobile,
        'instagram' => ContactsInfoType.instagram,
        'facebook' => ContactsInfoType.facebook,
        _ => ContactsInfoType.website
      };

  /// There are not present, for example, [ContactsInfoType.phone] because we want to show it in different place
  /// So if some of the types will not included in this list - return null
  PoiContentSocialMediaType? get socialMediaType => switch (this) {
        ContactsInfoType.email => PoiContentSocialMediaType.email,
        ContactsInfoType.website => PoiContentSocialMediaType.website,
        ContactsInfoType.instagram => PoiContentSocialMediaType.instagram,
        ContactsInfoType.facebook => PoiContentSocialMediaType.facebook,
        ContactsInfoType.youtube => PoiContentSocialMediaType.youtube,
        ContactsInfoType.linkedin => PoiContentSocialMediaType.linkedin,
        ContactsInfoType.whatsapp => PoiContentSocialMediaType.whatsapp,
        ContactsInfoType.telegram => PoiContentSocialMediaType.telegram,
        _ => null
      };

  PoiContentSocialMediaTypes? get poiContentSocialMediaType => switch (this) {
        ContactsInfoType.website => PoiContentSocialMediaTypes.website,
        ContactsInfoType.instagram => PoiContentSocialMediaTypes.instagram,
        ContactsInfoType.facebook => PoiContentSocialMediaTypes.facebook,
        ContactsInfoType.youtube => PoiContentSocialMediaTypes.youtube,
        ContactsInfoType.linkedin => PoiContentSocialMediaTypes.linkedin,
        ContactsInfoType.whatsapp => PoiContentSocialMediaTypes.whatsapp,
        ContactsInfoType.telegram => PoiContentSocialMediaTypes.telegram,
        _ => null
      };
}
