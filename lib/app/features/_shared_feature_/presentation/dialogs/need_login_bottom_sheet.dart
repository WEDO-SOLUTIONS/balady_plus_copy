import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';

class NeedLoginBottomSheet extends StatelessWidget {
  final String? title;
  final String? desc;
  final String? mainPage;
  final Function(bool isSuccess)? onSuccessLogin;

  const NeedLoginBottomSheet({super.key, this.desc, this.title, this.mainPage, this.onSuccessLogin});

  List<Widget> textActions(BuildContext context) => [
    const SizedBox(height: 10),
    TextButton(
      onPressed: () => CommonFunctions.onLogin(isMunicipality: true, mainPage: mainPage),
      child: Text("signInButton".tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
    ),
    const SizedBox(height: 10),
    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("notNow".tr())),
    const SizedBox(height: 10),
  ];

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0x1F898989),
                  border: Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(12), // Applies rounded corners
                ),
                width: 40,
                height: 40,
                child: CloseButton(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/icons/png/lockv.webp", width: 73, height: 88, fit: BoxFit.cover),
                const SizedBox(height: 40),
                CustomTextWidget(
                  ("not_registered").tr(),
                  fontColor: AppColor.blackModern600Light,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 20,
                ),
                const SizedBox(height: 20),
                CustomTextWidget(
                  ('not_register_desc').tr(),
                  fontColor: AppColor.blackModern500Light,
                  fontWeight: AppFontWeight.semiBold,
                  fontSize: 16,
                  maxLines: null,
                  textAlign: TextAlign.center,
                  height: 1.5,
                ),
                const SizedBox(height: 40),
                EnhancedCustomElevatedButtonWidget(
                  btnPressed: () => Navigator.of(context).pop(),
                  btnText: ("notNow").tr(),
                  btnTextSize: 18,
                  btnTextWeight: AppFontWeight.bold,
                  btnTextColor: Color(0xFF606060),
                  btnHeight: 56,
                  btnColor: Color(0x1F898989).withOpacity(0.1),
                  btnRadius: 8,
                ),
                const SizedBox(height: 12),
                EnhancedCustomElevatedButtonWidget(
                  btnPressed: () => CommonFunctions.onLogin(isMunicipality: true),
                  btnText: ("signInButton").tr(),
                  btnTextSize: 18,
                  btnTextWeight: AppFontWeight.bold,
                  btnTextColor: AppColor.white,
                  btnHeight: 56,
                  btnRadius: 8,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
