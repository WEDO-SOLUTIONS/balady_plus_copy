import 'package:freezed_annotation/freezed_annotation.dart';

part 'ws_config.freezed.dart';

enum SubscriptionType { share, get, custom }

@freezed
abstract class WsConfig with _$WsConfig {
  @Assert('subscriptionType != SubscriptionType.custom || customPath != null',
      'customPath must not be null for custom subscription type')
  const factory WsConfig({
    required final String token,
    required final String streamId,
    required final String host,
    required final int port,
    required final SubscriptionType subscriptionType,
    final String? customPath,
    final String? xStreamData,
  }) = _WsConfig;

  const WsConfig._();

  bool get isCustomSubscription => subscriptionType == SubscriptionType.custom;

  bool get hasValidCustomPath => isCustomSubscription && customPath != null;
}
