import 'package:freezed_annotation/freezed_annotation.dart';

part 'ws_config.freezed.dart';

enum SubscriptionType { share, get, custom }

@freezed
abstract class WsConfig with _$WsConfig {
  @Assert('subscriptionType != SubscriptionType.custom || customPath != null',
      'customPath must not be null for custom subscription type')
  const factory WsConfig({
    required String token,
    required String streamId,
    required String host,
    required int port,
    required SubscriptionType subscriptionType,
    String? customPath,
  }) = _WsConfig;

  const WsConfig._();

  bool get isCustomSubscription => subscriptionType == SubscriptionType.custom;

  bool get hasValidCustomPath => isCustomSubscription && customPath != null;
}
