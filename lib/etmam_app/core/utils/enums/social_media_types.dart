//enum SocialMediaTypes { facebook, instagram, twitter, snapchat, whatsapp, none }

import 'package:balady_plus/etmam_app/core/utils/constants/icon_path.dart';

enum SocialMediaTypes {
  facebook(icon: IconPath.facebookIcon, width: 10.15, height: 18.25),
  instagram(icon: IconPath.instagramIcon, width: 18.38, height: 18.42),
  twitter(icon: IconPath.twitterIcon, width: 19.51, height: 16.28),
  snapchat(icon: IconPath.snapchatIcon, width: 22, height: 22),
  whatsapp(icon: IconPath.whatsappIcon, width: 10.15, height: 18.25),
  none(icon: "", width: 10.15, height: 18.25);

  const SocialMediaTypes(
      {required this.icon, required this.height, required this.width});

  final double width;
  final double height;
  final String icon;
}
