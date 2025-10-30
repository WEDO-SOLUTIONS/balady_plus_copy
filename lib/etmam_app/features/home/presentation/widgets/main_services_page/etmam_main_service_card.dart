import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomInkWellButtonWidget,
        CustomNetworkImageWidget,
        CustomTextWidget,
        CustomVerticalSpace;
import 'package:flutter/material.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight;

class EtmamMainServiceCardWidget extends StatelessWidget {
  final String serviceName;
  final String serviceIcon;
  final VoidCallback btnPressed;

  const EtmamMainServiceCardWidget(
      {Key? key,
      required this.serviceName,
      required this.btnPressed,
      required this.serviceIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomInkWellButtonWidget(
        btnPressed: btnPressed,
        widget: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border:
                Border.all(color: AppColor.black200, width: 0.5775000000000001),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x1a000000),
                  offset: Offset(0, 1),
                  blurRadius: 15,
                  spreadRadius: 0)
            ],
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // icon
              CustomNetworkImageWidget(
                serviceIcon,
                imageHeight: 52,
                imageWidth: 52,
                imageFit: BoxFit.contain,
                placeHolderWidget: Container(
                  color: AppColor.primary900,
                  width: 52,
                  height: 52,
                ),
              ),
              CustomVerticalSpace(height: 12),
              // service name
              CustomTextWidget(
                serviceName,
                fontColor: AppColor.black,
                fontSize: 15.0,
                textAlign: TextAlign.center,
                fontWeight: AppFontWeight.bold,
              ),
            ],
          ),
        ));
  }
}
