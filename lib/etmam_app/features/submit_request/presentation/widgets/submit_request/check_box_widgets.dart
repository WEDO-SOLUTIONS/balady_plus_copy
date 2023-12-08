import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomHorizontalSpace,
        CustomIconButtonWidget,
        CustomSvgIconWidget,
        CustomTextButtonWidget,
        CustomTextWidget,
        EtmamProviderLogoIcon,
        EtmamRatingEvaluationWidget;
import 'package:balady_plus/etmam_app/features/services/domain/entities/services/service_item.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppColorsTheme, AppFontWeight, IconPath, trans;

class CheckBoxButton extends StatelessWidget {
  final Function onPress;

  const CheckBoxButton({Key? key, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomIconButtonWidget(
        padding: EdgeInsets.zero,
        btnPressed: () => onPress(),
        icon: WhiteContainerWidget(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextWidget(trans('choose_service_provider'),
                      fontWeight: AppFontWeight.medium,
                      fontSize: 16,
                      fontColor: AppColor.green1),
                ),
                CustomSvgIconWidget(
                  IconPath.arrowLeft,
                  iconWidth: 13,
                  iconHeight: 10,
                  iconColor: AppColorsTheme.primary700,
                )
              ],
            ),
          ),
        ));
  }
}

class SelectedProviderWidget extends StatelessWidget {
  final ServiceItems serviceItem;
  final Function onPressChanged;

  const SelectedProviderWidget(
      {Key? key, required this.serviceItem, required this.onPressChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteContainerWidget(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            EtmamProviderLogoIcon(
                imageUrl: serviceItem.logoImageUrl ?? "", imageSize: 38),
            const CustomHorizontalSpace(width: 13),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextWidget(
                  serviceItem.serviceProviderName ?? "",
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                  fontSize: 14,
                  fontWeight: AppFontWeight.medium,
                ),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Expanded(
                //         flex: 2,
                //         child: CustomTextWidget(
                //           name,
                //           maxLines: 1,
                //           textOverflow: TextOverflow.ellipsis,
                //           fontSize: 14,
                //           fontWeight: AppFontWeight.medium,
                //         )),
                //     // Expanded(
                //     //     flex: 1,
                //     //     child: CustomTextWidget(
                //     //       price,
                //     //       maxLines: 1,
                //     //       textOverflow: TextOverflow.ellipsis,
                //     //       fontSize: 12,
                //     //       fontWeight: AppFontWeight.medium,
                //     //       fontColor: AppColor.inProgressOrderTextColor,
                //     //     )),
                //   ],
                // ),
                EtmamRatingEvaluationWidget(
                  rating: serviceItem.ratingAverage,
                  totalEvaluation: serviceItem.ratingsCount,
                ),
              ],
            )),
            CustomTextButtonWidget(
              btnText: trans('change'),
              btnPressed: () => onPressChanged(),
              btnTextSize: 16,
              haveUnderline: true,
              btnTextWeight: AppFontWeight.bold,
              alignment: AlignmentDirectional.centerEnd,
            ),
          ],
        ),
      ),
    );
  }
}

class WhiteContainerWidget extends StatelessWidget {
  final Widget child;

  const WhiteContainerWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 87,
        decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(
              width: 0.5,
              color: AppColor.bottomNavigationShadow,
            )),
        child: child);
  }
}
