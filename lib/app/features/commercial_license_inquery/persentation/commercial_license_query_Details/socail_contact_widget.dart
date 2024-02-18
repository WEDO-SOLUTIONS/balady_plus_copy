import 'package:flutter/cupertino.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../_shared_feature_/presentation/components/texts/label_icon_subtitle_component.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';

class SocailContactWidget extends StatelessWidget {
   String? twitterContact;
   String? snapchatContact;
   String? instegramContact;
   String? facebookContact;
  String? whatsappContact;
   SocailContactWidget({super.key,

     required this.twitterContact,
     required this.snapchatContact,
     required this.instegramContact,
     required this.whatsappContact,
     required this.facebookContact


});


  @override
  Widget build(BuildContext context) {

    if ((twitterContact != null &&twitterContact!.isNotEmpty) ||
        (snapchatContact != null && snapchatContact!.isNotEmpty) ||
        (instegramContact != null &&instegramContact!.isNotEmpty) ||
        (instegramContact != null && instegramContact!.isNotEmpty) ||
        (facebookContact != null && facebookContact!.isNotEmpty)) {
      return LabelIconSubtitleComponent(
          text: ("qr_social").tr(),
          icon: IconPath.share,
          padding: const EdgeInsetsDirectional.only(start: 20,top: 10,bottom: 10),
          subWidget: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (twitterContact != null && twitterContact!.isNotEmpty)
                CustomIconButtonWidget(
                  icon: IconPath.qrTwitterIcon, //MM
                  iconSize: 35,
                  onPressed: () async{

                    await launch(this.twitterContact!);
                  },
                  btnHeight: 42,
                  btnWidth: 42,
                ),
              if (snapchatContact != null && snapchatContact!.isNotEmpty)
                CustomIconButtonWidget(
                  iconSize: 35,
                  icon: IconPath.qrSnapChatIcon,
                  onPressed: () async {

                    await launch(snapchatContact!);
                  },
                  btnHeight: 42,
                  btnWidth: 42,
                ),
              if ( instegramContact != null&& instegramContact!.isNotEmpty)
                CustomIconButtonWidget(
                  icon: IconPath.qrInstagramIcon,
                  iconSize: 35,
                  onPressed: () async{
                    await launch(instegramContact!);

                  },
                  btnHeight: 42,
                  btnWidth: 42,
                ),
              if (whatsappContact != null && whatsappContact!.isNotEmpty)
                CustomIconButtonWidget(
                  icon: IconPath.qrWhatsupIcon,
                  iconSize: 35,
                  onPressed: () async{
                    String mobileNumber =whatsappContact!;
                    if (mobileNumber.isNotEmpty) {
                      mobileNumber = "http://wa.me/$mobileNumber";
                      await launch(mobileNumber);
                    }
                  },
                  btnHeight: 42,
                  btnWidth: 42,
                ),
              if (facebookContact != null &&facebookContact!.isNotEmpty)
                CustomIconButtonWidget(
                  icon: IconPath.qrFaceBookIcon,
                  iconSize: 35,
                  onPressed: () async{

                    await launch(facebookContact!);
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