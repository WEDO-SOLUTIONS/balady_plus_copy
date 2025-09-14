import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stream_audio/data/datasource/channels_data_source.dart';
import 'package:mapness/features/stream_audio/data/dto/LiveNowDto.dart';

class StreamAudioProvider extends ChangeNotifier {
  bool _isPlaying = false;
  bool _isExited = false;

  ProgramDto? _selectedProgram;

  ProgramDto? get selectedProgram => _selectedProgram;

  void selectProgram(ProgramDto? program) {
    if(!_isPlaying) {
      _isPlaying = true;
    }
    _selectedProgram = program;
    notifyListeners();
  }

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
    _selectedProgram = null;
    notifyListeners();
    print(
        'StreamAudioProvider: State after exit - isPlaying=$isPlaying, isExited=$isExited');
  }

  void reset() {
    _isPlaying = false;
    _isExited = false;
    notifyListeners();
  }

  LiveNowDto? _liveNow;

  LiveNowDto? get liveNow => _liveNow;

  set liveNow(LiveNowDto? value) {
    _liveNow = value;
    notifyListeners();
  }

  Future<void> getLiveNow() async {
    liveNow ??= await ChannelsDataSource().getLiveNow();
  }

  void reorderPrograms(int oldIndex, int newIndex) {
    final ln = liveNow;
    if (ln == null) return;

    final list = [...ln.programs];
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);

    liveNow = ln.copyWith(programs: list);
    notifyListeners();
  }
}

final streamAudioProvider =
    ChangeNotifierProvider<StreamAudioProvider>((ref) => StreamAudioProvider());
