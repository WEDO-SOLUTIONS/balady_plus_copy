import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StreamAudioProvider extends ChangeNotifier {
  bool _isPlaying = false;
  bool _isExited = false;

  bool get isPlaying => _isPlaying;
  bool get isExited => _isExited;

  void playStream() {
    _isPlaying = true;
    _isExited = false; // Reset exited state to allow restarting
    notifyListeners();
  }

  void exitPlayer() {
    print(
        'StreamAudioProvider: exitPlayer() called - setting isPlaying=false, isExited=true');
    _isPlaying = false;
    _isExited = true;
    notifyListeners();
    print(
        'StreamAudioProvider: State after exit - isPlaying=$isPlaying, isExited=$isExited');
  }

  void reset() {
    _isPlaying = false;
    _isExited = false;
    notifyListeners();
  }
}

final streamAudioProvider = ChangeNotifierProvider<StreamAudioProvider>((ref) {
  return StreamAudioProvider();
});
