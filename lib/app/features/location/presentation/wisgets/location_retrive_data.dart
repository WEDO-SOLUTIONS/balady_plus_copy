import 'package:flutter/material.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class LocationRetriveData extends StatelessWidget {
  const LocationRetriveData({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColor.primary900Light, size: 100)),
                CustomVerticalSpace(height: 32),
                CustomTextWidget(
                  "location_retrive_data".tr(),
                  fontColor: Color(0xff52525B),
                  fontSize: 18,
                  fontWeight: AppFontWeight.bold,
                ),
                CustomVerticalSpace(height: 16),
                CustomTextWidget(
                  "location_retrive_data_desc".tr(),
                  fontColor: Color(0xff71717A),
                  fontSize: 15,
                  fontWeight: AppFontWeight.bold,
                  textAlign: TextAlign.center,
                  height: 1.6,
                  maxLines: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
