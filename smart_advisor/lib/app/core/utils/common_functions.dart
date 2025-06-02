import 'dart:ui';
import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show EventTransformer;
import 'package:smart_advisor/app/core/dependency_injection/injection_container.dart';
import 'package:smart_advisor/app/core/utils/constants/apis/env_types.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/webview_page.dart';
import 'package:stream_transform/stream_transform.dart' show RateLimit, Switch;
import './utils_exports.dart' show AppConfig, AppLanguage;
import 'constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';

class CommonFunctions {
  static EventTransformer<Event> debounce<Event>([Duration? duration]) =>
      (events, mapper) => events
          .debounce(duration ?? const Duration(milliseconds: 100))
          .switchMap(mapper);

  static showError(String error) {
    if (error.isNotEmpty) {
      try {
        BotToast.showSimpleNotification(
            title: error,
            titleStyle: const TextStyle(
              color: AppColor.white,
            ),
            backgroundColor: const Color.fromARGB(255, 204, 51, 51),
            hideCloseButton: true,
            duration: const Duration(seconds: 3));
      } catch (_) {}
    }
  }

  static showSuccess(String error) {
    if (error.isNotEmpty) {
      try {
        BotToast.showSimpleNotification(
            title: error,
            titleStyle: const TextStyle(
              color: AppColor.white,
            ),
            backgroundColor: const Color(0xFF389492),
            hideCloseButton: true,
            duration: const Duration(seconds: 3));
      } catch (_) {}
    }
  }

  /*static String hashRequest(
    String url,
    String method, {
    String? body,
    bool authorization = false,
    String? corelationId,
  }) {
    //var encodedURL = Uri.encodeComponent(url);

    String message = "";
    message = url + method;

    if (corelationId != null) message += corelationId;
    // if (authorization) message += 'Bearer ${CommonProperties.token}';

    if (body != null) {
      message += body.replaceAll(RegExp(r'^/\\n/g'), "");
    }
    /*message.errorLog();
    ;
    body.errorLog();*/

    message.trim();
    var key = utf8.encode(
        "oxqUHJH1KXD84vP0KYBnyaHDUk5sJ9HkzqPDTice5TABqvfACZaLscG1TjjyPgIT");
    var bytes = utf8.encode(message);

    var hmacSha256 = Hmac(sha256, key);
    var digest = hmacSha256.convert(bytes);
    String base64 = base64Encode(digest.bytes);
    return base64;
  }*/

  static bool get isAppAR =>
      AppConfig.getCurrentLanguageCode() == AppLanguage.ar.name;

  static openWebView(
      {required BuildContext context,
      required String title,
      required String URL}) {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      return WebViewPage(
        url: URL,
        title: title,
      );
    }));
  }

  static String hashRequest(String url, String method,
      {String? body,
      bool authorization = false,
      String? corelationId,
      String? loginIdentityId,
      String? loginIdentityType}) {
    //var encodedURL = Uri.encodeComponent(url);

    String message = "";
    message = url + method;
    if (body != null) {
      message += body.replaceAll(RegExp(r'^/\\n/g'), "");
    }

    if (authorization) message += 'Bearer ${BaladyServices.token}';
    print("message $message");
    if (loginIdentityId != null) message += loginIdentityId;

    if (loginIdentityType != null) message += loginIdentityType;

    /*message.errorLog();
    ;
    body.errorLog();*/
    print("message $message");
    message.trim();
    print(message);
    String hmCode = sl<EnvType>().isProd
        ? "TU9NUkEgTW9iaWxlIFRlYW0gMjAyMg=="
        : "oxqUHJH1KXD84vP0KYBnyaHDUk5sJ9HkzqPDTice5TABqvfACZaLscG1TjjyPgIT";
    var key = utf8.encode(hmCode);
    var bytes = utf8.encode(message);

    var hmacSha256 = Hmac(sha256, key);
    var digest = hmacSha256.convert(bytes);
    String base64 = base64Encode(digest.bytes);
    return base64;
  }

  // CommonFunctions.openWebView
}
