import 'dart:io';

import 'package:dartz/dartz.dart' show Either, Right, Left;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase, NoParams;
import '../../../../core/utils/constants/remote_config.dart';
import '../../entry_point_exports.dart';

class GetCookie extends UseCase<String, NoParams> {
  final EntryPointRepository repository;

  GetCookie({required this.repository});
  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    Either<Failure, String> res = await repository.getCookie();
    return res.fold(
        (l) => Left(l), (r) async => Right(await parseCookieValues(r)));
  }

  Future<String> parseCookieValues(String cookie) async {
    var cookieExpiration =
        DateTime.now().add(const Duration(days: 14)).millisecondsSinceEpoch;
    await CookieManager.instance().deleteAllCookies();
    List<String> cookies = cookie.split(',');
    String appCookie = "";
    cookies.forEach((element) async {
      if (element.contains("AspNetCore.Identity.Application")) {
        int valueStartIndex =
            element.indexOf(".AspNetCore.Identity.Application=") +
                ".AspNetCore.Identity.Application=".length;
        int valueEndIndex = element.indexOf(";");
        String value = element.substring(valueStartIndex, valueEndIndex);

        try {
          await CookieManager.instance().setCookie(
              url: WebUri(RemoteConfig.cookieURL),
              name: ".AspNetCore.Identity.Application",
              value: value,
              domain: Platform.isIOS
                  ? RemoteConfig.ssoMomraDomain
                  : RemoteConfig.momraDomain,
              expiresDate: cookieExpiration);
        } catch (_) {}
      } else if (element.contains("ASPXFORMSAUTH")) {
        int valueStartIndex =
            element.indexOf(".ASPXFORMSAUTH=") + ".ASPXFORMSAUTH=".length;
        int valueEndIndex = element.indexOf(";");
        String value = element.substring(valueStartIndex, valueEndIndex);
        appCookie = ".ASPXFORMSAUTH=$value";
        try {
          await CookieManager.instance().setCookie(
              url: WebUri(RemoteConfig.cookieURL),
              name: ".ASPXFORMSAUTH",
              value: value,
              domain: RemoteConfig.momraDomain,
              expiresDate: cookieExpiration);
        } catch (_) {}
      }
    });
    return appCookie;
  }
}
