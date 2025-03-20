import 'package:dio/dio.dart';
import 'package:mapness/shared/config/environment_config.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/dgis_http_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repo/saudi_pass_repository.dart';

part 'saudi_pass_repository_riverpod.g.dart';

@riverpod
class SaudiPassRepositoryRiverpod extends _$SaudiPassRepositoryRiverpod {
  @override
  Future<SaudiPassRepository> build() async {
    final dio = await ref.watch(dGisHttpService.future);
    final env = await ref.read(dgisEnvironmentProvider.future);

    // TODO weatherApi should be semantically renamed to apiservicesBalady cause it used wider then only for the Weather
    return SaudiPassRepository(_createDio(dio, env));
  }

  Dio _createDio(Dio dio, EnvironmentConfig env) {
    late final _saudiPassServicesPath = '${env.weatherApi}/v1/balady-business-saudi-pass-services/user';

    final saudiPassDio = Dio(dio.options.copyWith(baseUrl: _saudiPassServicesPath));

    _copyXLanguageToAcceptedLanguage(saudiPassDio.options);

    saudiPassDio.interceptors.addAll(dio.interceptors);

    return saudiPassDio;
  }

  /// fixes current Momra API state
  void _copyXLanguageToAcceptedLanguage(BaseOptions options) {
    final xLanguage = options.headers['X-Language'];

    if (xLanguage != null) {
      options.headers.putIfAbsent('Accept-Language', () => xLanguage);
    }
  }
}
