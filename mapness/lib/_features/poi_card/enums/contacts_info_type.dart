import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';

enum ContactsInfoType {
  phone,
  website,
  email,
  twitter,
  mobile,
  instagram,
  facebook,
  whatsApp,
  youtube,
  telegram,
  linkedin,
}

extension ContactsInfoTypeExt on ContactsInfoType {
  IconData getIconResource(bool isLtr) => switch (this) {
        ContactsInfoType.phone => isLtr?GeneralIcons.phoneLTR:GeneralIcons.phoneRTL,
        ContactsInfoType.mobile => isLtr?GeneralIcons.phoneLTR:GeneralIcons.phoneRTL,
        ContactsInfoType.website => GeneralIcons.web,
        ContactsInfoType.email => GeneralIcons.email,
        ContactsInfoType.twitter => SocialIcons.twitter,
        ContactsInfoType.instagram => SocialIcons.instagram,
        ContactsInfoType.facebook => SocialIcons.facebook,
        ContactsInfoType.whatsApp => SocialIcons.whatsapp,
        ContactsInfoType.youtube => SocialIcons.youtube,
        ContactsInfoType.telegram => SocialIcons.telegram,
        ContactsInfoType.linkedin => SocialIcons.linkedin,
      };

  static ContactsInfoType fromString(String typeName) => switch (typeName) {
        'phone' => ContactsInfoType.phone,
        'website' => ContactsInfoType.website,
        'email' => ContactsInfoType.email,
        'twitter' => ContactsInfoType.twitter,
        'mobile' => ContactsInfoType.mobile,
        'instagram' => ContactsInfoType.instagram,
        'linkedin' => ContactsInfoType.linkedin,
        'facebook' => ContactsInfoType.facebook,
        'whatsApp' => ContactsInfoType.whatsApp,
        'youtube' => ContactsInfoType.youtube,
        'telegram' => ContactsInfoType.telegram,
        _ => ContactsInfoType.website
      };
}
