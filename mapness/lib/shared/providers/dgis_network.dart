import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mapness/features/sso_auth/data/token_provider.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/package_info.dart';
import 'package:mapness/shared/providers/uuid_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dgis_network.g.dart';

@riverpod
class _DGisNetwork extends _$DGisNetwork {
  @override
  Dio build(String url) {
    const timeout = Duration(seconds: 5);
    final appLanguage = ref.watch(appLanguageProvider);
    final uuid = ref.watch(uuidProviderProvider);
    final version = ref.watch(packageInfoProvider).value?.version;
    final token = ref.watch(tokenProvider).value?.token;

    return Dio(BaseOptions(
      responseType: ResponseType.bytes,
      baseUrl: url,
      sendTimeout: timeout,
      receiveTimeout: timeout,
      connectTimeout: timeout,
      headers: {
        'Content-Type': 'application/protobuf',
        'Accept': 'application/protobuf',
        'X-Device-ID': uuid,
        'X-Device-Platform': Platform.isIOS ? "ios" : "android",
        "X-App-Version": version ?? "1.0.0",
        "X-Locale": appLanguage == Language.arabic ? "ar_SA" : "en_SA",
        "X-Language": appLanguage == Language.arabic ? "ar" : "en",
      }..addAll(token != null ? {'Authorization': 'Bearer $token'} : {}),
      // validateStatus: (status) => status != null && status < 500,
    ))
      ..interceptors.add(
        PrettyDioLogger(
          /// Since protobufs are just binary files what a purpose to print it
          responseBody: false,
        ),
      );
  }
}

dGisNetworkProvider(String url) => _dGisNetworkProvider(url);
