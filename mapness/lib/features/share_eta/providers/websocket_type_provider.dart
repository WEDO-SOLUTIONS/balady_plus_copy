import 'package:mapness/features/share_eta/models/ws_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'websocket_type_provider.g.dart';

@Riverpod(keepAlive: true)
class WebsocketType extends _$WebsocketType {
  @override
  SubscriptionType? build() => null;

  // ignore: use_setters_to_change_properties
  void setType({SubscriptionType? type}) {
    state = type;
  }
}
