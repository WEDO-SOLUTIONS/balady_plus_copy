import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class AppLaunchService {
  static Future<void> launchApp({
    required DeepLinkModel deepLinkInfo,
    // String? deepLink,
  }) async {
    //_fallbackUrl the same value of deepLink paramter
    String? fallbackUrl = Platform.isAndroid
        ? deepLinkInfo.deepLinkAndroid
        : deepLinkInfo.deepLinkIos;

    try {
      bool launched = await _tryLaunchApp(
        androidPackageName: deepLinkInfo.androidPackageName ?? "",
        iosUrlScheme: deepLinkInfo.iosUrlScheme,
        deepLink: fallbackUrl,
      );

      if (!launched) {
        await _redirectToStore(
          appStoreId: deepLinkInfo.appStoreId,
          playStoreId: deepLinkInfo.playStoreId,
          fallbackUrl: fallbackUrl,
        );
      }
    } catch (e) {
      debugPrint('Error launching app: $e');
      await _redirectToStore(
        appStoreId: deepLinkInfo.appStoreId,
        playStoreId: deepLinkInfo.playStoreId,
        fallbackUrl: fallbackUrl,
      );
    }
  }

  static Future<bool> _tryLaunchApp({
    required String androidPackageName,
    String? iosUrlScheme,
    String? deepLink,
  }) async {
    if (deepLink != null) {
      // Try deep linking first
      bool deepLinkSuccess = await _tryDeepLink(
        androidPackageName: androidPackageName,
        iosUrlScheme: iosUrlScheme,
        deepLink: deepLink,
      );

      if (deepLinkSuccess) {
        return true;
      }
    }

    // Fall back to regular app launch
    final result = await LaunchApp.openApp(
      androidPackageName: androidPackageName,
      iosUrlScheme: iosUrlScheme != null ? '$iosUrlScheme://' : null,
      openStore: false,
    );
    return result == 1;
  }

  static Future<bool> _tryDeepLink({
    required String androidPackageName,
    String? iosUrlScheme,
    required String deepLink,
  }) async {
    try {
      if (await _launchUrl(deepLink, androidPackageName)) {
        return true;
      }

      if (Platform.isAndroid) {
        // Android-specific deep link formats
        final androidIntents = [
          if (deepLink.startsWith('http'))
            'intent://${deepLink.replaceFirst(RegExp('^https?://'), '')}#Intent;package=$androidPackageName;scheme=https;end',
          if (!deepLink.contains('://'))
            'intent://$deepLink#Intent;package=$androidPackageName;end',
          deepLink, // try original again
        ];

        for (final intent in androidIntents) {
          if (await _launchUrl(intent, androidPackageName)) {
            return true;
          }
        }
      } else if (Platform.isIOS && iosUrlScheme != null) {
        // iOS-specific deep link formats
        final iosLinks = [
          if (deepLink.startsWith('http'))
            '$iosUrlScheme://${deepLink.replaceFirst(RegExp('^https?://'), '')}',
          if (!deepLink.contains('://')) '$iosUrlScheme://$deepLink',
          deepLink, // try original again
        ];

        for (final link in iosLinks) {
          if (await _launchUrl(link)) {
            return true;
          }
        }
      }

      return false;
    } catch (e) {
      debugPrint('Deep link failed: $e');
      return false;
    }
  }

  static Future<bool> _launchUrl(String url, [String? package]) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
          webOnlyWindowName: package != null ? '_self' : null,
        );
      }
      return false;
    } catch (e) {
      debugPrint('URL launch failed: $e');
      return false;
    }
  }

  static Future<void> _redirectToStore({
    String? appStoreId,
    String? playStoreId,
    String? fallbackUrl,
  }) async {
    if (Platform.isAndroid && playStoreId != null) {
      await StoreRedirect.redirect(
        androidAppId: playStoreId,
      );
    } else if (Platform.isIOS && appStoreId != null) {
      await StoreRedirect.redirect(
        iOSAppId: appStoreId,
      );
    } else if (fallbackUrl != null) {
      final uri = Uri.parse(fallbackUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }
}

// class AppInfo {
//   final String androidPackageName;
//   final String? iosUrlScheme;
//   final String? appStoreId;
//   final String? playStoreId;
//   final String? fallbackUrl;

//   AppInfo({
//     required this.androidPackageName,
//     this.iosUrlScheme,
//     this.appStoreId,
//     this.playStoreId,
//     this.fallbackUrl,
//   });
// }

/// TODO: only use for testing
// class UniversalLinkExamples {
//   static final AppInfo instagramAppInfo = AppInfo(
//     androidPackageName: "com.instagram.android",
//     iosUrlScheme: "instagram",
//     appStoreId: "389801252",
//     playStoreId: "com.instagram.android",
//     fallbackUrl: "https://www.instagram.com/",
//   );

//   static final AppInfo facebookAppInfo = AppInfo(
//     androidPackageName: "com.facebook.katana",
//     iosUrlScheme: "fb",
//     appStoreId: "284882215",
//     playStoreId: "com.facebook.katana",
//     fallbackUrl: "https://www.facebook.com/",
//   );

//   static final AppInfo linkedInAppInfo = AppInfo(
//     androidPackageName: "com.linkedin.android",
//     iosUrlScheme: "linkedin",
//     appStoreId: "288429040",
//     playStoreId: "com.linkedin.android",
//     fallbackUrl: "https://www.linkedin.com/",
//   );

//   static Future<void> openInstagramProfile(String username) async {
//     await AppLaunchService.launchApp(
//       appInfo: instagramAppInfo,
//       deepLink: "user?username=$username",
//     );
//   }

//   static Future<void> openFacebookProfile(String username) async {
//     await AppLaunchService.launchApp(
//       appInfo: facebookAppInfo,
//       deepLink: "user?username=$username",
//     );
//   }

//   static Future<void> openLinkedInProfile(String profileId) async {
//     await AppLaunchService.launchApp(
//       appInfo: linkedInAppInfo,
//       deepLink: "https://www.linkedin.com/in/$profileId",
//     );
//   }
// }
