/*import 'package:flutter/material.dart';
 
class MunicipalityMSRDialog extends StatelessWidget {
  const MunicipalityMSRDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg = Helpers.translatingWord("service_not_available");
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        Constants.whiteCloseImg,
                        height: 16.0,
                        width: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  "assets/images/emptyState@3x.png",
                  height: 80.0,
                  width: 128.0,
                ),
                Constants.verticalSpaceLarge,
                CustomTextWidget(
                  Helpers.translatingWord("region_coverage_error"),
                  fontColor: AppColor.black,
                  fontWeight: FONT_WEIGHT.medium,
                  fontSize: 22,
                ),
                Constants.verticalSpaceMedium,
                CustomTextWidget(
                  msg,
                  fontColor: AppColor.grey1000,
                  fontWeight: FONT_WEIGHT.medium,
                  fontSize: 16,
                ),
                Constants.verticalSpaceLarge,
                CustomElevatedButtonWidget(
                  btnPressed: () {
                    Helpers.backNavigationToHomeScreen();
                  },
                  btnText: Helpers.translatingWord("go_to_main_screen"),
                  btnTextSize: 16,
                  btnTextWeight: FONT_WEIGHT.regular,
                  btnHeight: 56,
                  btnWidth: 240,
                ),
                Constants.verticalSpaceSmall,
              ],
            )),
      ],
    );
  }
}
*/