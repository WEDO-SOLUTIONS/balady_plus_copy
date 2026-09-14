import 'dart:io';

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class DeepLinkDialogService {
  static Future<void> showLaunchAppDialog({
    required BuildContext context,
    required Function(AppInfo, String?) onLaunchPressed,
  }) async {
    final controllers = _DialogControllers();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return _DeepLinkDialogContent(controllers: controllers, onLaunchPressed: onLaunchPressed);
          },
        );
      },
    );
  }
}

class _DialogControllers {
  final TextEditingController deeplinkController = TextEditingController();
  final TextEditingController androidPackageController = TextEditingController();
  final TextEditingController iosUrlSchemeController = TextEditingController();
  final TextEditingController appStoreIdController = TextEditingController();
  final TextEditingController playStoreIdController = TextEditingController();

  void dispose() {
    deeplinkController.dispose();
    androidPackageController.dispose();
    iosUrlSchemeController.dispose();
    appStoreIdController.dispose();
    playStoreIdController.dispose();
  }
}

class _DeepLinkDialogContent extends StatefulWidget {
  final _DialogControllers controllers;
  final Function(AppInfo, String?) onLaunchPressed;

  const _DeepLinkDialogContent({required this.controllers, required this.onLaunchPressed});

  @override
  State<_DeepLinkDialogContent> createState() => _DeepLinkDialogContentState();
}

class _DeepLinkDialogContentState extends State<_DeepLinkDialogContent> {
  final PlatformType _selectedPlatform = (Platform.isAndroid ? PlatformType.android : PlatformType.ios);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('launch_app_settings'.tr()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('app_info_settings'.tr(), style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 16),
            if (_selectedPlatform == PlatformType.android) ...[
              TextField(
                controller: widget.controllers.androidPackageController,
                decoration: InputDecoration(
                  labelText: 'android_package_name'.tr(),
                  hintText: 'com.example.app',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: widget.controllers.playStoreIdController,
                decoration: InputDecoration(
                  labelText: 'play_store_id'.tr(),
                  hintText: 'com.example.app',
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
            if (_selectedPlatform == PlatformType.ios) ...[
              TextField(
                controller: widget.controllers.iosUrlSchemeController,
                decoration: InputDecoration(
                  labelText: 'ios_url_scheme'.tr(),
                  hintText: 'exampleapp',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: widget.controllers.appStoreIdController,
                decoration: InputDecoration(
                  labelText: 'app_store_id'.tr(),
                  hintText: '123456789',
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: widget.controllers.deeplinkController,
              decoration: InputDecoration(
                labelText: 'deeplink_url'.tr(),
                hintText: 'https://example.com/path or custom://scheme',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('cancel'.tr()),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('launch'.tr()),
          onPressed: () {
            final deeplink = widget.controllers.deeplinkController.text.trim();
            final hasDeeplink = deeplink.isNotEmpty;

            // If deeplink is provided, we can launch with minimal app info
            if (hasDeeplink) {
              final appInfo = AppInfo(
                androidPackageName: widget.controllers.androidPackageController.text.isNotEmpty
                    ? widget.controllers.androidPackageController.text
                    : "unknown.package",
                iosUrlScheme: widget.controllers.iosUrlSchemeController.text.isNotEmpty
                    ? widget.controllers.iosUrlSchemeController.text
                    : null,
                appStoreId: widget.controllers.appStoreIdController.text.isNotEmpty
                    ? widget.controllers.appStoreIdController.text
                    : null,
                playStoreId: widget.controllers.playStoreIdController.text.isNotEmpty
                    ? widget.controllers.playStoreIdController.text
                    : null,
              );

              Navigator.of(context).pop();
              widget.onLaunchPressed(appInfo, deeplink);
              return;
            }

            // Original validation for app info when no deeplink
            final appInfo = AppInfo(
              androidPackageName: widget.controllers.androidPackageController.text,
              iosUrlScheme: widget.controllers.iosUrlSchemeController.text,
              appStoreId: widget.controllers.appStoreIdController.text,
              playStoreId: widget.controllers.playStoreIdController.text,
            );

            if (_selectedPlatform == PlatformType.android && widget.controllers.androidPackageController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('android_package_required'.tr())));
              return;
            }

            if (_selectedPlatform == PlatformType.ios && widget.controllers.iosUrlSchemeController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ios_url_scheme_required'.tr())));
              return;
            }

            Navigator.of(context).pop();
            widget.onLaunchPressed(appInfo, null);
          },
        ),
      ],
    );
  }
}

enum PlatformType { android, ios }

class DeepLinkActionButton extends StatelessWidget {
  final bool isLoading;
  final String? currentOperation;
  final Function(AppInfo, String?) onLaunchApp;

  const DeepLinkActionButton({
    super.key,
    required this.isLoading,
    required this.currentOperation,
    required this.onLaunchApp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => DeepLinkDialogService.showLaunchAppDialog(context: context, onLaunchPressed: onLaunchApp),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.open_in_new, size: 24, color: AppColor.primary700Light),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "launch_external_app".tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (currentOperation == "launch_external_app" && isLoading)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "launch_external_app_description".tr(),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final AppInfo instagramAppInfo = AppInfo(
  androidPackageName: "com.instagram.android",
  iosUrlScheme: "instagram",
  appStoreId: "389801252",
  playStoreId: "com.instagram.android",
  fallbackUrl: "https://www.instagram.com/",
);

final AppInfo facebookAppInfo = AppInfo(
  androidPackageName: "com.facebook.katana",
  iosUrlScheme: "fb",
  appStoreId: "284882215",
  playStoreId: "com.facebook.katana",
  fallbackUrl: "https://www.facebook.com/",
);

final AppInfo linkedInAppInfo = AppInfo(
  androidPackageName: "com.linkedin.android",
  iosUrlScheme: "linkedin",
  appStoreId: "288429040",
  playStoreId: "com.linkedin.android",
  fallbackUrl: "https://www.linkedin.com/",
);

class AppInfo {
  final String androidPackageName;
  final String? iosUrlScheme;
  final String? appStoreId;
  final String? playStoreId;
  final String? fallbackUrl;

  AppInfo({required this.androidPackageName, this.iosUrlScheme, this.appStoreId, this.playStoreId, this.fallbackUrl});
}
