import 'package:flutter/cupertino.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import '../../../../../features/_shared_feature_/presentation/components/texts/label_icon_subtitle_component.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';

class SocailContactWidget extends StatelessWidget {
  String? twitterContact;
  String? snapchatContact;
  String? instegramContact;
  String? facebookContact;
  String? whatsappContact;
  SocailContactWidget(
      {super.key,
      required this.twitterContact,
      required this.snapchatContact,
      required this.instegramContact,
      required this.whatsappContact,
      required this.facebookContact});

  @override
  Widget build(BuildContext context) {
    if ((twitterContact != null &&
            twitterContact!.isNotEmpty &&
            twitterContact!.contains("twitter")) ||
        (snapchatContact != null &&
            snapchatContact!.isNotEmpty &&
            snapchatContact!.contains("snapchat")) ||
        (instegramContact != null &&
            instegramContact!.isNotEmpty &&
            instegramContact!.contains("instagram")) ||
        (whatsappContact != null && whatsappContact!.isNotEmpty) ||
        (facebookContact != null &&
            facebookContact!.isNotEmpty &&
            facebookContact!.contains("facebook"))) {
      return LabelIconSubtitleComponent(
          text: ("qr_social").tr(),
          icon: IconPath.share,
          padding:
              const EdgeInsetsDirectional.only(start: 20, top: 10, bottom: 10),
          subWidget: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (twitterContact != null &&
                  twitterContact!.isNotEmpty &&
                  twitterContact!.contains("twitter"))
                CustomIconButtonWidget(
                  icon: IconPath.qrTwitterIcon, //MM
                  iconSize: 35,

                  onPressed: () {
                    String url = twitterContact!;
                    if (url.contains("https") == false ||
                        url.contains("http") == false) {
                      url = "https://$url";
                    }
                    launch(url);
                  },
                  btnHeight: 42,
                  btnWidth: 42,
                ),
              if (snapchatContact != null &&
                  snapchatContact!.isNotEmpty &&
                  snapchatContact!.contains("snapchat"))
                CustomIconButtonWidget(
                  iconSize: 35,
                  icon: IconPath.qrSnapChatIcon,
                  onPressed: () {
                    if (snapchatContact!.contains("https") == false ||
                        snapchatContact!.contains("http") == false) {
                      snapchatContact = "https://$snapchatContact";
                    }
                    launch(snapchatContact!);
                  },
                  btnHeight: 42,
                  btnWidth: 42,
                ),
              if (instegramContact != null &&
                  instegramContact!.isNotEmpty &&
                  instegramContact!.contains("instagram"))
                CustomIconButtonWidget(
                  icon: IconPath.qrInstagramIcon,
                  iconSize: 35,
                  onPressed: () {
                    if (instegramContact!.contains("https") == false ||
                        instegramContact!.contains("http") == false) {
                      instegramContact = "https://$instegramContact";
                    }
                    launch(instegramContact!);
                  },
                  btnHeight: 42,
                  btnWidth: 42,
                ),
              if (whatsappContact != null && whatsappContact!.isNotEmpty)
                CustomIconButtonWidget(
                  icon: IconPath.qrWhatsupIcon,
                  iconSize: 35,
                  onPressed: () {
                    String mobileNumber = whatsappContact!;
                    if (mobileNumber.isNotEmpty) {
                      mobileNumber = "http://wa.me/$mobileNumber";
                      launch(mobileNumber);
                    }
                  },
                  btnHeight: 42,
                  btnWidth: 42,
                ),
              if (facebookContact != null &&
                  facebookContact!.isNotEmpty &&
                  facebookContact!.contains("facebook"))
                CustomIconButtonWidget(
                  icon: IconPath.qrFaceBookIcon,
                  iconSize: 35,
                  onPressed: () {
                    if (facebookContact!.contains("https") == false ||
                        facebookContact!.contains("http") == false) {
                      facebookContact = "https://$facebookContact";
                    }

                    launch(facebookContact!);
                  },
                  btnHeight: 42,
                  btnWidth: 42,
                ),
            ],
          ));
    }
    return const SizedBox();
  }
}
