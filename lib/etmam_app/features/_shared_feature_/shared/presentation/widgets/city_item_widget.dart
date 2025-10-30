import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomIconButtonWidget,
        CustomNetworkImageWidget,
        CustomSvgIconWidget,
        CustomTextWidget,
        CustomVerticalSpace;
import 'package:flutter/material.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppColorsTheme, AppFontWeight, IconPath;
import 'custom_text_widget.dart';

class CityWidget extends StatelessWidget {
  final String cityName;
  final String cityIcon;
  final VoidCallback btnPressed;
  late bool isSelected;

  CityWidget(
      {Key? key,
      required this.cityName,
      required this.cityIcon,
      required this.btnPressed,
      this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomIconButtonWidget(
          padding: EdgeInsets.zero,
          btnPressed: () {
            btnPressed();
          },
          icon: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 68,
                margin: const EdgeInsetsDirectional.only(end: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          isSelected ? AppColor.darkTurquoise : AppColor.white,
                      width: isSelected ? 1.5 : 0),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  color: isSelected ? AppColor.lightTurquoise : AppColor.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x14000000),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        spreadRadius: 0)
                  ],
                ),
                child: Center(
                    child: SizedBox(
                  height: 45,
                  width: 45,
                  child: CustomNetworkImageWidget(
                    cityIcon,
                    imageHeight: 45,
                    imageWidth: 45,
                    imageFit: BoxFit.contain,
                    // placeHolderWidget: CustomSvgIconWidget(
                    //   IconPath.otpLogo,
                    //   iconSize: 45,
                    //   iconFit: BoxFit.fill,
                    // ),
                  ),
                )),
              ),
              const CustomVerticalSpace(height: 4),
              SizedBox(
                //  width: 50,
                child: Center(
                  child: CustomAutoSizeTextWidget(
                    cityName,
                    textAlign: TextAlign.center,
                    maxFontSize: 13,
                    minFontSize: 9,
                    maxLines: 1,
                    // textOverflow: TextOverflow.ellipsis,
                    fontWeight: AppFontWeight.medium,
                    fontColor:
                        isSelected ? AppColor.darkTurquoise : AppColor.black,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
