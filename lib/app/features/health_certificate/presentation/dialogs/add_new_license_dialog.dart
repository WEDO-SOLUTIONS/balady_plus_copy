/*import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class AddNewLicenseDialog extends StatefulWidget {
  const AddNewLicenseDialog({Key? key}) : super(key: key);

  @override
  _AddNewLicenseDialogState createState() => _AddNewLicenseDialogState();
}

class _AddNewLicenseDialogState extends State<AddNewLicenseDialog> {
  List<String> titles = [
    Helpers.translatingWord("issue_health_certificate"),
  ];
  List<String> image = [Constants.appointmentNewAppointmentIcon];
  List<String> desc = [
    Helpers.translatingWord('issue_health_certificate_desc')
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 26, bottom: 5),
      child: Column(
        children: [
          // header
          const NewHealthIssueHeader(),
          const CustomVerticalSpace(height: 20),
          // filter type list
          Expanded(
            child: ListView.builder(
                itemCount: titles.length,
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return NewHealthCardWidget(
                    title: titles[index],
                    image: image[index],
                    desc: desc[index],
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class NewHealthIssueHeader extends StatelessWidget {
  const NewHealthIssueHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // close button
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            alignment: AlignmentDirectional.topStart,
            margin: EdgeInsetsDirectional.only(
                top: MediaQuery.of(context).padding.top + 10),
            child: Image.asset(
              Constants.whiteCloseImg,
              height: 24.0,
              width: 24.0,
              color: AppColor.black,
            ),
          ),
        ),
        Constants.verticalSpaceMedium,
        // title
        CustomTextWidget(
          Helpers.translatingWord(
            "lbl_new_order",
          ),
          fontColor: AppColor.black,
          fontSize: 24.0,
          height: 1.3,
        ),
        const CustomVerticalSpace(height: 4.0),
        // subtitle
        CustomTextWidget(
          Helpers.translatingWord("select_order_type"),
          fontColor: AppColor.black400,
          fontWeight: AppFontWeight.medium,
          textAlign: TextAlign.start,
          height: 1.3,
        ),
      ],
    );
  }
}

class NewHealthCardWidget extends StatelessWidget {
  final String title;
  final String desc;
  final String image;

  const NewHealthCardWidget({
    required this.title,
    required this.desc,
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Constants.boxDecorationWithShadowAndRoundedCorner,
      padding: const EdgeInsets.all(Constants.mediumPadding),
      child: Column(
        children: [
          // icon
          CustomSvgIconWidget(
            image,
            iconHeight: 55.0,
            iconWidth: 55.0,
          ),
          Constants.verticalSpaceSmall,
          // title
          CustomTextWidget(
            title,
            fontColor: AppColor.black,
            height: 1.2,
          ),
          Constants.verticalSpaceSmall,
          // unreadable text
          CustomTextWidget(
            desc,
            fontColor: AppColor.black500,
            fontWeight: AppFontWeight.medium,
            fontSize: 13.0,
            height: 1.2,
          ),
          Constants.verticalSpaceMedium,
          // button
          CustomTextButtonWithIconWidget(
            btnEffectColor: AppColor.white,
            btnPressed: () => Navigator.of(context)
                .pushNamed(RouteName.issueCertificateRoute),
            btnText: Helpers.translatingWord("bookNewAppointmentSelectWord"),
            btnTextColor: AppColor.baladyDarkGreen2,
            btnTextSize: 13.0,
            btnTextWeight: AppFontWeight.medium,
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColor.baladyDarkGreen2,
              size: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
*/
