import 'dart:io';

import 'package:dartz/dartz.dart' show Either, Right, Left;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../../../core/utils/constants/remote_config.dart';
import '../../entry_point_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class GetCookie extends UseCase<String, bool?> {
  final EntryPointRepository repository;

  GetCookie({required this.repository});
  @override
  Future<Either<Failure, String>> call(bool? parseCookies) async {
    Either<Failure, String> res = await repository.getCookie();
    return res.fold((l) => Left(l), (r) async {
      if (parseCookies == false) {
        return Right(r);
      } else {
        await parseCookieValues(r);
        return Right(r);
      }
    });
  }

  Future<String> parseCookieValues(String cookie) async {
    var cookieExpiration = DateTime.now().add(const Duration(days: 14)).millisecondsSinceEpoch;
    await CookieManager.instance().deleteAllCookies();
    List<String> cookies = cookie.split(',');
    String appCookie = "";
    cookies.forEach((element) async {
      if (element.contains("AspNetCore.Identity.Application")) {
        int valueStartIndex =
            element.indexOf(".AspNetCore.Identity.Application=") + ".AspNetCore.Identity.Application=".length;
        int valueEndIndex = element.indexOf(";");
        String value = element.substring(valueStartIndex, valueEndIndex);

        try {
          await CookieManager.instance().setCookie(
            url: WebUri(RemoteConfig.cookieURL),
            name: ".AspNetCore.Identity.Application",
            value: value,
            domain: Platform.isIOS ? RemoteConfig.ssoMomraDomain : RemoteConfig.momraDomain,
            expiresDate: cookieExpiration,
          );
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
      } else if (element.contains("ASPXFORMSAUTH")) {
        int valueStartIndex = element.indexOf(".ASPXFORMSAUTH=") + ".ASPXFORMSAUTH=".length;
        int valueEndIndex = element.indexOf(";");
        String value = element.substring(valueStartIndex, valueEndIndex);
        appCookie = ".ASPXFORMSAUTH=$value";
        try {
          await CookieManager.instance().setCookie(
            url: WebUri(RemoteConfig.cookieURL),
            name: ".ASPXFORMSAUTH",
            value: value,
            domain: RemoteConfig.momraDomain,
            expiresDate: cookieExpiration,
          );
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
      } else if (element.contains("idsrv.session")) {
        int valueStartIndex = element.indexOf(".idsrv.session=") + ".idsrv.session=".length;
        int valueEndIndex = element.indexOf(";");
        String value = element.substring(valueStartIndex + 1, valueEndIndex);
        try {
          await CookieManager.instance().setCookie(
            url: WebUri(RemoteConfig.cookieURL),
            name: ".idsrv.session",
            value: value,
            domain: Platform.isIOS ? RemoteConfig.ssoMomraDomain : RemoteConfig.momraDomain,
            expiresDate: cookieExpiration,
          );
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
      } else if (element.contains(RemoteConfig.webCookieHeader)) {
        int valueStartIndex =
            element.indexOf(".${RemoteConfig.webCookieHeader}=") + ".${RemoteConfig.webCookieHeader}=".length;
        int valueEndIndex = element.indexOf(";");
        String value = element.substring(valueStartIndex + 1, valueEndIndex);

        try {
          await CookieManager.instance().setCookie(
            url: WebUri(RemoteConfig.cookieURL),
            name: ".${RemoteConfig.webCookieHeader}",
            value: value,
            domain: Platform.isIOS ? RemoteConfig.ssoMomraDomain : RemoteConfig.momraDomain,
            expiresDate: cookieExpiration,
          );
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
      }
    });
    return appCookie;
  }
}
