import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stream_audio/data/datasource/channels_data_source.dart';
import 'package:mapness/features/stream_audio/data/dto/LiveNowDto.dart';
import 'package:mapness/features/stream_audio/services/fijk_audio_service.dart';

class StreamAudioProvider extends ChangeNotifier {
  bool _isExited = false;
  final FijkAudioService _audioService = FijkAudioService();
  static const MethodChannel _mediaChannel =
      MethodChannel('balady_media_session');

  ProgramDto? _selectedProgram;

  StreamAudioProvider() {
    _audioService.init();
    _audioService.addListener(_onAudioServiceChanged);
    _setupAndroidMediaCallbacks();
  }

  void _setupAndroidMediaCallbacks() {
    if (!Platform.isAndroid) return;
    _mediaChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onPlay':
          await resumeStream();
          break;
        case 'onPause':
          await pauseStream();
          break;
        case 'onStop':
          await exitPlayer();
          break;
      }
    });
  }

  void _onAudioServiceChanged() {
    notifyListeners();
  }

  // Getters
  ProgramDto? get selectedProgram => _selectedProgram;
  bool get isPlaying => _audioService.isPlaying;
  bool get isLoading => _audioService.isLoading;
  bool get hasError => _audioService.hasError;
  String? get errorMessage => _audioService.errorMessage;
  bool get isExited => _isExited;

  // Cache and progress info
  Duration get currentPosition => _audioService.currentPosition;
  Duration get bufferedDuration => _audioService.bufferedDuration;
  Duration get maxCacheDuration => _audioService.maxCacheDuration;
  double get progress => _audioService.progress;
  bool get isLive => _audioService.isLive;
  DateTime? get channelStartTime => _audioService.channelStartTime;

  Future<void> selectProgram(ProgramDto? program) async {
    if (program != null && program.streamUrl.isNotEmpty) {
      _selectedProgram = program;
      _isExited = false;

      await _audioService.playStream(
        program.streamUrl,
        channelId: program.title,
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
        channelId: _selectedProgram!.title,
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

  Future<void> seekToProgress(double progress) async {
    await _audioService.seekToProgress(progress);
    notifyListeners();
  }

  Future<void> goLive() async {
    await _audioService.goLive();
    notifyListeners();
  }

  Future<void> seekForward(
      [Duration duration = const Duration(seconds: 30)]) async {
    await _audioService.seekForward(duration);
    notifyListeners();
  }

  Future<void> seekBackward(
      [Duration duration = const Duration(seconds: 30)]) async {
    await _audioService.seekBackward(duration);
    notifyListeners();
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
    _audioService.dispose();
    super.dispose();
  }

  // LiveNow data management
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

  // Helper methods for UI
  String get formattedCurrentPosition => _formatDuration(currentPosition);
  String get formattedBufferedDuration => _formatDuration(bufferedDuration);
  String get formattedMaxCache => _formatDuration(maxCacheDuration);

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  // Cache status for debugging
  String get cacheStatus {
    if (channelStartTime == null) return 'No cache';

    final elapsed = DateTime.now().difference(channelStartTime!);
    final cacheUsed = (elapsed.inMinutes / 60).toStringAsFixed(1);
    final maxCache = (maxCacheDuration.inMinutes / 60).toStringAsFixed(1);

    return 'Cache: ${cacheUsed}h / ${maxCache}h';
  }
}

final streamAudioProvider = ChangeNotifierProvider<StreamAudioProvider>(
  (ref) => StreamAudioProvider(),
);
