import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';

import '../../../../../../app/core/dependency_injection/injection_container.dart';
import '../../../../../../app/core/utils/constants/app_colors.dart';
import '../../../../../../app/core/utils/constants/constants.dart';
import '../../../../../../app/core/utils/enums/app_font_weights.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../../core/utils/constants/app_config.dart';
import '../../../../_shared_feature_/shared/presentation/widgets/custom_buttons_widgets.dart';
import '../../../../dynamic_form/presentation/dialogs/bidding_types_dialog.dart';

class EtmamBiddingWidget extends StatelessWidget {
  const EtmamBiddingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 197,
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      decoration: new BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
              color: Color(0x14000000),
              offset: Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 0)
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CustomSvgIconWidget(IconPath.Inq_11Icon, iconWidth: 58, iconHeight: 58),
        CustomVerticalSpace(height: 14),
        CustomTextWidget(trans("biddng_home_title"),
            fontColor: AppColor.black,
            fontSize: 17,
            fontWeight: AppFontWeight.bold),
        CustomVerticalSpace(height: 10),
        CustomTextWidget(trans("bidding_home_desc"),
            fontColor: AppColor.kGray115,
            fontSize: 13,
            fontWeight: AppFontWeight.medium),
        CustomGoToDetailsButtonWidget(
          padding: EdgeInsets.only(
              top: Constants.semiMediumPadding,
              bottom: Constants.semiMediumPadding),
          onPressed: () {
            if (CommonProperties.isLoggedIn) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => BiddingTypeDialog()));
            } else {
              sl<EntryPointCubit>().onLogin(isFromEtmam: true).then((value) {
                if (value == true) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BiddingTypeDialog()));
                }
              });
            }
          },
          label: trans('bidding_home_publish'),
        )
      ]),
    );
  }
}
