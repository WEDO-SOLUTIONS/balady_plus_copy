import 'package:balady_plus/app/features/ekram/ekram_exports.dart'
    show EkramBookingItem, EkramHeaderAndDescWidget, EkramStatusWidget;
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../etmam_app/core/utils/utils_exports.dart';
import '../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_buttons_widgets.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import 'ekram_driver_request_card_widget.dart';

class EkramBookingCardWidget extends StatelessWidget {
  final EkramBookingItem ekramBookingItem;

  const EkramBookingCardWidget({Key? key, required this.ekramBookingItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 274,
      padding: const EdgeInsets.only(top: Constants.mediumPadding),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: new BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
              color: Color(0x19000000),
              offset: Offset(0, 2),
              blurRadius: 10,
              spreadRadius: 0)
        ],
      ),
      child: Column(
        //   mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      DetailsInfoWithImgSvg(
                        img: IconPath.hashtag,
                        title: ekramBookingItem.orderNo ?? "",
                      ),
                      CustomHorizontalSpace(width: 12),
                      EkramStatusWidget(
                        status: ekramBookingItem.status ?? "",
                      ),
                    ],
                  ),
                ),
                CustomHorizontalSpace(width: 5),
                CustomIconButtonWidget(
                  btnPressed: () {},
                  icon: CustomSvgIconWidget(
                    "assets/icons/moreAction.svg",
                  ),
                )
              ],
            ),
          ),
          const CustomVerticalSpace(height: 16),
          DrawLineWidget(
            horizontalMargin: Constants.smallPadding,
            lineColor: AppColor.black200.withOpacity(0.2000000029802322),
          ),
          const CustomVerticalSpace(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: EkramHeaderAndDescWidget(
                      title: trans('deceasedName'),
                      details: ekramBookingItem.deceasedName ?? "",
                    )),
                    CustomHorizontalSpace(width: 12),
                    Expanded(
                        child: EkramHeaderAndDescWidget(
                      title: trans('cemeteryName'),
                      details: ekramBookingItem.cemeteryName ?? "",
                    ))
                  ],
                ),
                const CustomVerticalSpace(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: EkramHeaderAndDescWidget(
                      title: trans('burialDate'),
                      details: ekramBookingItem.burialDate ?? "",
                    )),
                    CustomHorizontalSpace(width: 12),
                    Expanded(
                        child: EkramHeaderAndDescWidget(
                      title: trans('burialTime'),
                      details: ekramBookingItem.burialTime ?? "",
                    ))
                  ],
                ),
              ],
            ),
          ),

          Spacer(),
          DrawLineWidget(
            lineColor: AppColor.black200.withOpacity(0.2000000029802322),
          ),
          // go to details button
          CustomGoToDetailsButtonWidget(
            onPressed: () {
              /*      if (onPress != null) {
                onPress!();
              }*/
            },
            label:
                "customerVoiceLatestRequestsSectionGoToDetailsButtonWord".tr(),
          ),
        ],
      ),
    );
  }
}
