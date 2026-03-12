import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/shared_prefs_manager.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../widgets/buttons/custom_buttons_widgets.dart';
import '../widgets/custom_svg_icon_widget.dart';
import '../widgets/texts/custom_text_widget.dart';

class LocationBackgroundConsentDialog extends StatelessWidget {
  const LocationBackgroundConsentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
            decoration: BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     GestureDetector(
                //       onTap: () {
                //         Navigator.of(context).pop();
                //       },
                //       child: Image.asset(
                //         IconPath.qrWhiteCloseIcon,
                //         height: 16.0,
                //         width: 16.0,
                //         color: Colors.black,
                //       ),
                //     ),
                //   ],
                // ),
                const CustomSvgIconWidget(IconPath.location, iconSize: 82),
                const SizedBox(height: 16),

                CustomTextWidget(
                  ("backgournd_location_consent").tr(),
                  fontColor: AppColor.blackModern500Light,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 18,
                  height: 1.5,
                  textAlign: TextAlign.center,
                  maxLines: null,
                ),
                const SizedBox(height: 16),
                EnhancedCustomElevatedButtonWidget(
                  btnPressed: () {
                    Navigator.of(context).pop();

                    //  sharedPrefs.setLocationConsent(true);

                    //    sl<WeatherAlertsCubit>().startTracking();
                  },
                  btnText: ("backgournd_location_consent_agree").tr(),
                  btnTextSize: 18,
                  btnTextWeight: AppFontWeight.bold,
                  btnTextColor: AppColor.white,
                  btnHeight: 56,
                  btnRadius: 8,
                ),
                const SizedBox(height: 12),
                EnhancedCustomElevatedButtonWidget(
                  btnPressed: () {
                    Navigator.of(context).pop();
                    sharedPrefs.setLocationConsent(false);
                  },
                  btnText: ("backgournd_location_consent_non_agree").tr(),
                  btnTextSize: 16,
                  btnTextWeight: AppFontWeight.bold,
                  btnTextColor: AppColor.primary900Light,
                  btnBorderWidth: 1,
                  btnColor: Colors.transparent,
                  btnBorderColor: AppColor.primary900Light,
                  btnHeight: 56,
                  btnRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
