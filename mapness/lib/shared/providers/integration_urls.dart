import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'integration_urls.g.dart';

@Riverpod(keepAlive: true)
class IntegrationUrls extends _$IntegrationUrls {
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
  String build() => isProduction
      ? 'https://sa1.ops.2gis.dev/v1/recruitment-services'
      : 'https://sa1.ops.2gis.dev/v1/recruitment-services';
}
