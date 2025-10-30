import 'package:smart_advisor/app/core/utils/constants/language.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/custom_button.dart';

import '/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

class ReloadWidget extends StatelessWidget {
  final double widgetHeight;
  final VoidCallback onTab;

  const ReloadWidget({Key? key, this.widgetHeight = 150, required this.onTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTab,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "packages/smart_advisor/smart_advisor_assets/images/error_placeholder.png",
                width: 141,
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                "لا يوجد نتائج",
                style: AppStyle.calloutBoldStyle
                    .copyWith(color: AppColor.textPrimaryColor),
              ),
              const SizedBox(
                height: 24,
              ),
              Center(
                child: CustomButton(
                  btnWidth: 194,
                  text: "reload".tr(),
                  onPress: () {
                    onTab();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
