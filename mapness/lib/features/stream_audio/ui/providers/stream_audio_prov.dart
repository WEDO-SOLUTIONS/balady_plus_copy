import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stream_audio/data/datasource/channels_data_source.dart';
import 'package:mapness/features/stream_audio/data/dto/LiveNowDto.dart';
import 'package:mapness/features/stream_audio/services/audio_service.dart';

class StreamAudioProvider extends ChangeNotifier {
  bool _isExited = false;
  final AudioService _audioService = AudioService();

  ProgramDto? _selectedProgram;

  StreamAudioProvider() {
    _audioService.init();
    _audioService.addListener(_onAudioServiceChanged);
  }

  void _onAudioServiceChanged() {
    notifyListeners();
  }

  ProgramDto? get selectedProgram => _selectedProgram;

  bool get isPlaying => _audioService.isPlaying;
  bool get isLoading => _audioService.isLoading;
  bool get hasError => _audioService.hasError;
  String? get errorMessage => _audioService.errorMessage;

  bool get isExited => _isExited;

  Future<void> selectProgram(ProgramDto? program) async {
    if (program != null && program.streamUrl.isNotEmpty) {
      _selectedProgram = program;
      _isExited = false;
      await _audioService.playStream(
        program.streamUrl,
        title: program.title,
        artist: program.sub,
        artUri: program.programImage.keyName,
      );
      notifyListeners();
    }
  }

  Future<void> playStream() async {
    if (_selectedProgram != null && _selectedProgram!.streamUrl.isNotEmpty) {
      _isExited = false;
      await _audioService.playStream(
        _selectedProgram!.streamUrl,
        title: _selectedProgram!.title,
        artist: _selectedProgram!.sub,
        artUri: _selectedProgram!.programImage.keyName,
      );
      notifyListeners();
    }
  }

  Future<void> pauseStream() async {
    await _audioService.pause();
    notifyListeners();
  }

  Future<void> resumeStream() async {
    await _audioService.resume();
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await pauseStream();
    } else {
      await resumeStream();
    }
  }

  Future<void> seekForward() async {
    await _audioService.seekForward();
  }

  Future<void> exitPlayer() async {
    print(
        'StreamAudioProvider: exitPlayer() called - stopping audio and setting isExited=true');
    await _audioService.stop();
    _isExited = true;
    _selectedProgram = null;
    notifyListeners();
    print(
        'StreamAudioProvider: State after exit - isPlaying=$isPlaying, isExited=$isExited');
  }

  void reset() {
    _isExited = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioService.removeListener(_onAudioServiceChanged);
    super.dispose();
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
