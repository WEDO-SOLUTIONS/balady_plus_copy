import 'package:mapness/features/share_eta/models/eta_status_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'websocket_status_provider.g.dart';

@riverpod
class WebsocketStatus extends _$WebsocketStatus {
  @override
  EtaStatusModel build() => EtaStatusModel(status: false);

  void setConnected({required String streamId, required String streamToken}) {
    state = EtaStatusModel(status: true, streamId: streamId, streamToken: streamToken);
  }

  void setDisconnected() {
    state = EtaStatusModel(status: false);
  }

  void setStreamId(String streamId) {
    state = state.copyWith(streamId: streamId);
  }

  void setStreamToken(String streamToken) {
    state = state.copyWith(streamToken: streamToken);
  }

  void setEstimatedTime(DateTime estimatedTime) {
    state = state.copyWith(estimatedTime: estimatedTime);
  }
}
