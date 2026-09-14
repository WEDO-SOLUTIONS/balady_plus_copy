import 'package:app_settings/app_settings.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class LocationRetriveLocation extends StatelessWidget {
  final bool permission;
  const LocationRetriveLocation({super.key, required this.permission});

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
                const CustomSvgIconWidget(IconPath.location, iconSize: 82),
                CustomVerticalSpace(height: 32),
                /* CustomTextWidget(
                  "location_retrive_location_title".tr(),
                  fontColor: Color(0xff52525B),
                  fontSize: 18,
                  fontWeight: AppFontWeight.bold,
                ),
                CustomVerticalSpace(height: 16),*/
                CustomTextWidget(
                  "loaction_retrive_location_sub".tr(),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: EnhancedCustomElevatedButtonWidget(
              btnPressed: () {
                if (permission) {
                  Geolocator.openAppSettings();
                } else {
                  AppSettings.openAppSettings(type: AppSettingsType.location);
                }
              },
              btnText: ("settings").tr(),
              btnTextSize: 18,
              btnTextWeight: AppFontWeight.bold,
              btnTextColor: AppColor.white,
              btnHeight: 56,
              btnRadius: 8,
            ),
          ),
        ],
      ),
    );
  }
}
