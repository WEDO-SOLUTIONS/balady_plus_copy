import 'dart:async';

/// Reports whether the phone is connected to an Android Auto head unit.
class AndroidAutoHandler {
  /// Creates the handler.
  AndroidAutoHandler();

  /// Emits true while an Android Auto head unit is connected.
  Stream<bool> get androidAutoEvents => _controller.stream;

  final _controller = StreamController<bool>.broadcast();

  /// Decodes a connection payload off the platform channel and publishes it
  /// on [androidAutoEvents], treating a missing value as disconnected.
  void handleAndroidAutoConnectionEvent(Map<dynamic, dynamic> map) {
    final connected = map["connected"] ?? false;
    _controller.sink.add(connected);
  }

  /// Closes the connection stream.
  Future<void> dispose() {
    return _controller.close();
  }
}
