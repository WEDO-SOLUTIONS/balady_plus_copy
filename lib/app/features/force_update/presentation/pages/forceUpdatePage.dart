import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/utils_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';

class ForceUpdatePage extends StatefulWidget {
  const ForceUpdatePage({super.key});

  @override
  _ForceUpdatePageState createState() => _ForceUpdatePageState();
}

class _ForceUpdatePageState extends State<ForceUpdatePage> {
  Future<void> _openAppStore() async {
    final appStoreUrl = Uri.parse("https://apps.apple.com/app/id1522185123");
    if (await canLaunchUrl(appStoreUrl)) {
      await launchUrl(appStoreUrl, mode: LaunchMode.externalApplication);
    } else {
      // Optional: handle error or fallback
      debugPrint("Could not launch App Store.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(child: SingleChildScrollView(child: body())),
      ),
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const CustomSvgIconWidget(IconPath.mobile, iconSize: 86),
          const SizedBox(height: 24),
          CustomTextWidget(
            "force_update_title".tr(),
            fontSize: 20,
            fontWeight: AppFontWeight.bold,
            fontColor: AppColor.blackModern600Light,
          ),
          const SizedBox(height: 8),
          CustomTextWidget(
            "force_update_desc".tr(),
            fontSize: 18,
            maxLines: null,
            textAlign: TextAlign.center,
            height: 1.2,
            fontWeight: AppFontWeight.bold,
            fontColor: AppColor.blackModern500Light,
          ),
          const SizedBox(height: 24),
          CustomElevatedButtonWidget(
            btnColor: AppColor.primary900Light,
            textStyle: AppStyle.elevatedButtonStyle.copyWith(
              color: AppColor.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
            btnHeight: 52,
            btnWidth: MediaQuery.sizeOf(context).width,
            text: "force_update_app".tr(),
            onPressed: () {
              if (Platform.isAndroid) {
                StoreRedirect.redirect(androidAppId: "momra.balady.android", iOSAppId: "1522185123");
              } else {
                _openAppStore();
              }
            },
          ),
        ],
      ),
    );
  }
}
