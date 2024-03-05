import 'package:flutter/material.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight;

import '../../../../../../app/core/utils/constants/constants.dart';
import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomInkWellButtonWidget,
        CustomTextWidget,
        SubServicePrimaryIconWidget,
        CustomNetworkImageWidget;

class EtmamSubServicePageCardWidget extends StatelessWidget {
  final String subServiceName;
  final String subServiceIcon;
  final VoidCallback btnPressed;
  final bool fromPage;
  final Color? containerColor;

  const EtmamSubServicePageCardWidget(
      {Key? key,
      required this.subServiceName,
      required this.btnPressed,
      required this.subServiceIcon,
      this.fromPage = false,
      this.containerColor = AppColor.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomInkWellButtonWidget(
        btnPressed: btnPressed,
        widget: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF4F4F5),
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          // margin: const EdgeInsets.only(bottom: Constants.smallPadding),
          padding: const EdgeInsets.symmetric(
            horizontal: Constants.semiMediumPadding,
            vertical: Constants.mediumPadding,
          ),
          child: Column(
            children: [
              // icon
              CustomNetworkImageWidget(
                subServiceIcon,
                imageHeight: 38,
                imageWidth: 38,
                imageFit: BoxFit.fill,
              ),
              Constants.verticalSpaceMedium,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // report title
                    CustomTextWidget(
                      subServiceName,
                      fontColor: AppColor.black,
                      fontSize: 14.0,
                      fontWeight: AppFontWeight.bold,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
