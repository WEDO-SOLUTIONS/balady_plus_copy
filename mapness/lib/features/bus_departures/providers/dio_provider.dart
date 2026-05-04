import 'package:dio/dio.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/base_dio.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Dio> busDeparturesDio(Ref ref) async {
  final env = await ref.read(dgisEnvironmentProvider.future);
  final baseUrl = '${env.appFeedbackApi}/v1/transit/';

  final dio = ref.read(baseDioProvider);
  final appLanguage = ref.read(appLanguageProvider);
  final makkahBusDio = Dio(
    dio.options.copyWith(
      baseUrl: baseUrl,
      headers: {
        ...dio.options.headers,
        'X-API-Key': 'ce49130d-1d91-4ea1-9b56-68d866494842',
        'X-Locale': appLanguage == Language.arabic ? 'ar_SA' : 'en_SA',
      },
    ),
  );
  
  makkahBusDio.interceptors.addAll(dio.interceptors);
  
  return makkahBusDio;
}
