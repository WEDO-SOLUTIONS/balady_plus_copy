import 'dart:async';

class AndroidAutoHandler {
  AndroidAutoHandler();

  Stream<bool> get androidAutoEvents => _controller.stream;

  final _controller = StreamController<bool>.broadcast();

  void handleAndroidAutoConnectionEvent(Map<dynamic, dynamic> map) {
    final connected = map["connected"] ?? false;
    _controller.sink.add(connected);
  }

  Future<void> dispose() {
    return _controller.close();
  }
}
