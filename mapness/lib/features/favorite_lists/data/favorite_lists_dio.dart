import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mapness/shared/lib/auth/auth_token_interceptors.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/package_info.dart';
import 'package:mapness/shared/providers/uuid_provider.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/shared/utils/logger/talker_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

part 'favorite_lists_dio.g.dart';

@riverpod
Future<Dio> favoriteListsDio(Ref ref) async {
  final env = await ref.watch(dgisEnvironmentProvider.future);
  final appLanguage = ref.watch(appLanguageProvider);
  final uuid = ref.watch(uuidProviderProvider);
  final version = ref.watch(packageInfoProvider).value?.version;
  const timeout = Duration(seconds: 15);

  final baseOptions = BaseOptions(
    baseUrl: env.favoriteListsApi,
    sendTimeout: timeout,
    receiveTimeout: timeout,
    connectTimeout: timeout,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Device-ID': uuid,
      'X-Device-Platform': Platform.isIOS ? 'ios' : 'android',
      'X-App-Version': version ?? '1.0.0',
      'X-Locale': appLanguage == Language.arabic ? 'ar_SA' : 'en_SA',
      'X-Language': appLanguage == Language.arabic ? 'ar' : 'en',
      // todo(claude): get token from user auth
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkOWI4N2I0ZS0zM2YxLTRhYzEtOWEzZC1mOTkyMzRjNWY2YTciLCJjbGllbnRfdHlwZSI6Im1vYmlsZSIsImlhdCI6MTc2OTcyMzIwMH0.sampleSignatureTokenStringForTestingOnly',
    },
  );

  final dio = Dio(baseOptions);
  dio.interceptors.addAll([
    if (logger is TalkerMapnessLogger)
      TalkerDioLogger(
        talker: (logger as TalkerMapnessLogger).talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseData: false,
        ),
      ),
    AuthTokenInterceptor.tokenInterceptor(ref, baseOptions),
  ]);
  return dio;
}
