import 'package:mapness/features/share_eta/models/eta_stream_store.dart';

class EtaStreamStorage {
  static final EtaStreamStorage _instance = EtaStreamStorage._internal();

  EtaStreamStore _state = const EtaStreamStore();

  factory EtaStreamStorage() => _instance;

  EtaStreamStorage._internal();

  EtaStreamStore get state => _state;

  void setToken(String token) {
    _state = _state.copyWith(streamToken: token);
  }

  void setStreamId(String streamId) {
    _state = _state.copyWith(streamId: streamId);
  }

  void setXStreamData(String xStreamData) {
    _state = _state.copyWith(xStreamData: xStreamData);
  }

  void setEstimatedTime(DateTime estimatedTime) {
    _state = _state.copyWith(estimatedTime: estimatedTime);
  }

  void setDurationInMinutes(int durationInMinutes) {
    _state = _state.copyWith(durationInMinutes: durationInMinutes);
  }

  void clear() {
    _state = const EtaStreamStore();
  }
}
