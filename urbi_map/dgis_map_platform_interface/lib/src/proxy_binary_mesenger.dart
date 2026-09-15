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

  // `BinaryMessenger` still declares this member abstract, so a proxy has to
  // implement it, and the only correct implementation is to forward to the
  // messenger being wrapped. The warning goes away on its own when Flutter
  // removes the method, and this override goes with it.
  @override
  // ignore: deprecated_member_use
  Future<void> handlePlatformMessage(String channel, ByteData? data, ui.PlatformMessageResponseCallback? callback) {
    // ignore: deprecated_member_use
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
