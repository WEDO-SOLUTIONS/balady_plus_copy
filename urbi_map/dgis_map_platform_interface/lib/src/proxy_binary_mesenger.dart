import 'dart:ui' as ui;
import 'package:flutter/services.dart';

/// Wraps a [BinaryMessenger] and appends a suffix to every channel name, so
/// two map views in one app talk on channels of their own instead of both
/// answering the same one.
class ProxyBinaryMessenger implements BinaryMessenger {
  /// Wraps [binaryMessenger], or the app's default one, appending [suffix] to
  /// every channel name that passes through.
  ProxyBinaryMessenger({required String suffix, BinaryMessenger? binaryMessenger})
    : _suffix = suffix,
      _binaryMessenger = binaryMessenger ?? ServicesBinding.instance.defaultBinaryMessenger;

  final BinaryMessenger _binaryMessenger;
  final String _suffix;

  @override
  Future<void> handlePlatformMessage(String channel, ByteData? data, ui.PlatformMessageResponseCallback? callback) {
    return _binaryMessenger.handlePlatformMessage("$channel$_suffix", data, callback);
  }

  @override
  Future<ByteData?>? send(String channel, ByteData? data) {
    return _binaryMessenger.send("$channel$_suffix", data);
  }

  @override
  void setMessageHandler(String channel, MessageHandler? handler) {
    _binaryMessenger.setMessageHandler("$channel$_suffix", handler);
  }
}
