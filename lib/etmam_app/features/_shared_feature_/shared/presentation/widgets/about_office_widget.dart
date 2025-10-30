import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CallButton,
        DrawLineWidget,
        SectionTitleWidget,
        SocialMediaWidget,
        SubTitleAndDescWidget,
        WorkingDayListWidget;
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show SocialMediaAccount, WorkDay;
import 'package:flutter/material.dart';
import '../../../../../core/utils/utils_exports.dart'
    show CommonFunctions, IconPath, PrimaryIcons, trans;

class AboutOfficeWidget extends StatelessWidget {
  final String? aboutOfficeDesc;
  final List<WorkDay>? workingHours;
  final String? website;
  final String? mobile;
  final List<SocialMediaAccount>? socialMedia;
  final bool showCallButton;
  final bool showDivider;

  const AboutOfficeWidget(
      {Key? key,
      this.aboutOfficeDesc,
      this.workingHours,
      this.website,
      this.mobile,
      this.socialMedia,
      this.showCallButton = false,
      this.showDivider = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionTitleWidget(
        title: trans('office_info2'),
        primaryIcon: PrimaryIcons.providerOfficeIcon,
      ),
      if (aboutOfficeDesc != null && aboutOfficeDesc!.isNotEmpty)
        SubTitleAndDescWidget(
            subTitle: trans('about_office'), desc: aboutOfficeDesc),
      if (workingHours != null && (workingHours?.length ?? 0) > 0)
        WorkingDayListWidget(
          workingHours: workingHours,
        ),
      if (website != null && website!.isNotEmpty)
        SubTitleAndDescWidget(
          subTitle: trans('office_website'),
          desc: website,
          descPressedAction: () {
            CommonFunctions.launch(website ?? "");
          },
          subTitleIcon: IconPath.websiteIcon,
        ),
      if (mobile != null && mobile!.isNotEmpty)
        SubTitleAndDescWidget(
          subTitle: trans('office_mobile'),
          desc: mobile,
          descPressedAction: () {
            CommonFunctions.call(mobile);
          },
          subTitleIcon: IconPath.phoneIcon,
        ),
      if (socialMedia != null && (socialMedia?.length ?? 0) > 0)
        SocialMediaWidget(socialMedia: socialMedia),
      if (showCallButton)
        CallButton(onPressed: () {
          CommonFunctions.call(mobile);
        }),
      if (showDivider)
        DrawLineWidget(
          lineColor: Color(0xff979797).withOpacity(0.2000000029802322),
          verticalMargin: 10,
        ),
    ]);
  }
}
