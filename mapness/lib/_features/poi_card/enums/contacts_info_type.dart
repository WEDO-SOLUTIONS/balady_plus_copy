enum ContactsInfoType {
  phone,
  website,
  email,
  twitter,
  mobile,
  instagram,
  snapchat,
  facebook,
  whatsApp,
  vkontakte,
  youtube,
  telegram,
  unknown,
}

extension ContactsInfoTypeExt on ContactsInfoType {
  String getIconResource() {
    return switch (this) {
      ContactsInfoType.phone => 'assets/icons/svg/ic_phone.svg',
      ContactsInfoType.mobile => 'assets/icons/svg/ic_phone.svg',
      ContactsInfoType.website => 'assets/icons/svg/ic_web.svg',
      ContactsInfoType.email => 'assets/icons/svg/ic_email.svg',
      ContactsInfoType.twitter => 'assets/icons/svg/social/Twitter-new.svg',
      ContactsInfoType.instagram => 'assets/icons/svg/social/Instagram.svg',
      ContactsInfoType.snapchat => 'assets/icons/svg/ic_web.svg',
      ContactsInfoType.facebook => 'assets/icons/svg/social/Facebook.svg',
      ContactsInfoType.whatsApp => 'assets/icons/svg/social/Whatsapp.svg',
      ContactsInfoType.vkontakte => 'assets/icons/svg/social/VK.svg',
      ContactsInfoType.youtube => 'assets/icons/svg/social/Youtube.svg',
      ContactsInfoType.telegram => 'assets/icons/svg/social/Telegram.svg',
      ContactsInfoType.unknown => 'assets/icons/svg/ic_web.svg',
    };
  }

  static ContactsInfoType fromString(String typeName) {
    return switch (typeName) {
      'phone' => ContactsInfoType.phone,
      'website' => ContactsInfoType.website,
      'email' => ContactsInfoType.email,
      'twitter' => ContactsInfoType.twitter,
      'mobile' => ContactsInfoType.mobile,
      'instagram' => ContactsInfoType.instagram,
      'snapchat' => ContactsInfoType.snapchat,
      'facebook' => ContactsInfoType.facebook,
      'whatsApp' => ContactsInfoType.whatsApp,
      'vkontakte' => ContactsInfoType.vkontakte,
      'youtube' => ContactsInfoType.youtube,
      'telegram' => ContactsInfoType.telegram,
      _ => ContactsInfoType.unknown
    };
  }
}
