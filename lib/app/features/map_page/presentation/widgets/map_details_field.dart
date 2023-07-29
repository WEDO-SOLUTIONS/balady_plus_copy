import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';

class MapDetailsField extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool showMargin;
  final bool showTopRadius;
  final bool showBottomRadius;

  const MapDetailsField(
      {super.key,
      required this.subTitle,
      required this.title,
      this.showMargin = true,
      this.showTopRadius = true,
      this.showBottomRadius = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: showMargin
          ? const EdgeInsets.symmetric(vertical: 8)
          : EdgeInsets.zero,
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: showTopRadius && showBottomRadius
              ? BorderRadius.circular(16)
              : showTopRadius
                  ? BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))
                  : showBottomRadius
                      ? BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16))
                      : showTopRadius
                          ? BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16))
                          : BorderRadius.zero,
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CustomTextWidget(
          title,
          fontSize: 15,
          fontWeight: AppFontWeight.bold,
          fontColor: AppColor.blackModern600Light,
        ),
        const CustomVerticalSpace(height: 8),
        CustomTextWidget(
          subTitle,
          fontSize: 14,
          fontWeight: AppFontWeight.semiBold,
          fontColor: AppColor.blackModern600Light,
          height: 1.3,
          maxLines: 10,
        ),
      ]),
    );
  }
}
