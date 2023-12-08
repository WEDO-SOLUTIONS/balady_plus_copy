import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dgis_url.g.dart';

@riverpod
class _DgisUrl extends _$DgisUrl {
  // bool isProduction = kDebugMode;
  bool isProduction = true;

  void setProduction() {
    isProduction = true;
    ref.invalidateSelf();
  }

  void setStaging() {
    isProduction = false;
    ref.invalidateSelf();
  }

  @override
  String build() {
    return isProduction
        ? 'https://momrah-balady.public-poc.urbi.ae/api/1.0/'
        : 'https://momrah-balady-dev.public-poc.urbi.ae/api/1.0/';
  }
}

final dgisUrlProvider = _dgisUrlProvider;
