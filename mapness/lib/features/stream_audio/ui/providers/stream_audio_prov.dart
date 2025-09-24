import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stream_audio/data/datasource/channels_data_source.dart';
import 'package:mapness/features/stream_audio/data/dto/LiveNowDto.dart';
import 'package:mapness/features/stream_audio/services/audio_service.dart';

class StreamAudioProvider extends ChangeNotifier {
  AudioService _audioService = AudioService();
  ProgramDto? _selectedProgram;
  LiveNowDto? _liveNow;
  bool _isExited = false;
  bool _isInitialized = false;

  StreamAudioProvider() {
    _initializeService();
  }

  Future<void> _initializeService() async {
    await _audioService.init();
    _audioService.addListener(_onAudioServiceChanged);
    _isInitialized = true;
    notifyListeners();
  }

  void _onAudioServiceChanged() {
    try {
      // Only notify if not disposed
      if (!_isExited) {
        notifyListeners();
      }
    } catch (e) {
      debugPrint('StreamAudioProvider: Error in _onAudioServiceChanged: $e');
    }
  }

  // Program management
  ProgramDto? get selectedProgram => _selectedProgram;

  LiveNowDto? get liveNow => _liveNow;

  set liveNow(LiveNowDto? value) {
    _liveNow = value;
    notifyListeners();
  }

  // State getters from audio service
  bool get isPlaying => _audioService.isPlaying;

  // Show loading when: no program selected OR audio service is loading but not yet playing
  bool get isLoading => _audioService.isLoading;

  bool get hasError => _audioService.hasError;

  String? get errorMessage => _audioService.errorMessage;

  bool get isExited => _isExited;

  bool get needsReinitialization => _isExited || _selectedProgram == null;

  bool get isInitialized => _isInitialized;

  // Time and progress getters
  Duration get currentPosition => _audioService.currentPosition;

  Duration get totalCachedTime => _audioService.totalCachedTime;

  Duration get timeBehindLive => _audioService.timeBehindLive;

  // Fix progress calculation
  double get progress {
    final totalCached = _audioService.totalCachedTime.inMilliseconds;
    final currentPos = _audioService.currentPosition.inMilliseconds;
    if (totalCached <= 0) return 0.0;
    return (currentPos / totalCached).clamp(0.0, 1.0);
  }

  // Fix live detection - we're live if time behind is very small
  bool get isLive {
    final behindTime = _audioService.timeBehindLive.inSeconds;
    return behindTime <= 2; // Consider live if within 2 seconds
  }

  // Formatted time strings
  String get formattedCurrentPosition => _audioService.formattedCurrentPosition;

  String get formattedLivePosition => _audioService.formattedLivePosition;

  String get formattedTimeBehind => _audioService.formattedTimeBehind;

  // Load channels data
  Future<void> getLiveNow() async {
    if (_liveNow == null) {
      try {
        _liveNow = await ChannelsDataSource().getLiveNow();
        notifyListeners();
      } catch (e) {
        debugPrint('StreamAudioProvider: Failed to load channels: $e');
      }
    }
  }

  // Program selection and playback
  Future<void> selectProgram(ProgramDto? program) async {
    if (program == null || program.streamUrl.isEmpty) return;

    debugPrint('StreamAudioProvider: Selecting program: ${program.title}');

    // If we were previously exited, reinitialize the audio service
    if (_isExited) {
      debugPrint('StreamAudioProvider: Reinitializing after exit');
      await _reinitializeAudioService();
    }

    _selectedProgram = program;
    _isExited = false;

    try {
      await _audioService.playStream(
        url: program.streamUrl,
        channelId: program.title,
        title: program.title,
        artist: program.sub,
        artUri: null, // Don't use asset paths as artUri
      );
      debugPrint(
          'StreamAudioProvider: Successfully started playing ${program.title}');
    } catch (e) {
      debugPrint('StreamAudioProvider: Error playing stream: $e');
    }

    notifyListeners();
  }

  // Reinitialize audio service after being exited
  Future<void> _reinitializeAudioService() async {
    debugPrint('StreamAudioProvider: Reinitializing audio service');

    // Remove old listener to avoid memory leaks
    _audioService.removeListener(_onAudioServiceChanged);

    // Use the new reinitialize method instead of dispose + new instance
    await _audioService.reinitialize();

    // Add listener to the reinitialized service
    _audioService.addListener(_onAudioServiceChanged);
    _isInitialized = true;

    debugPrint('StreamAudioProvider: Audio service reinitialized');
  }

  // Playback controls
  Future<void> playStream() async {
    if (_selectedProgram == null || _selectedProgram!.streamUrl.isEmpty) return;

    debugPrint(
        'StreamAudioProvider: Playing stream for ${_selectedProgram!.title}');

    // If we were previously exited, reinitialize
    if (_isExited) {
      await _reinitializeAudioService();
    }

    _isExited = false;

    try {
      await _audioService.playStream(
        url: _selectedProgram!.streamUrl,
        channelId: _selectedProgram!.title,
        title: _selectedProgram!.title,
        artist: _selectedProgram!.sub,
        artUri: null,
      );
      debugPrint('StreamAudioProvider: Stream playing successfully');
    } catch (e) {
      debugPrint('StreamAudioProvider: Error in playStream: $e');
    }

    notifyListeners();
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
    await _audioService.togglePlayPause();
  }

  // Seeking controls
  Future<void> seekToProgress(double progress) async {
    await _audioService.seekToProgress(progress);
  }

  Future<void> seekToPosition(Duration position) async {
    await _audioService.seekToPosition(position);
  }

  Future<void> goLive() async {
    await _audioService.goLive();
  }

  Future<void> seekForward(
      [Duration duration = const Duration(seconds: 30)]) async {
    await _audioService.seekForward(duration);
  }

  Future<void> seekBackward(
      [Duration duration = const Duration(seconds: 30)]) async {
    await _audioService.seekBackward(duration);
  }

  // Exit and cleanup
  Future<void> exitPlayer() async {
    debugPrint('StreamAudioProvider: Exiting player');

    // Remove listener to avoid notifications during cleanup
    _audioService.removeListener(_onAudioServiceChanged);

    // Stop the audio service (don't dispose here, let reinitialize handle it)
    await _audioService.stop();

    // Mark as exited and clear selected program
    _isExited = true;
    _selectedProgram = null;
    _isInitialized = false;

    debugPrint('StreamAudioProvider: Player exited successfully');
    notifyListeners();
  }

  // Reset method - now properly handles reinitialization
  Future<void> reset() async {
    debugPrint('StreamAudioProvider: Resetting provider');

    if (_isExited) {
      await _reinitializeAudioService();
    }

    _isExited = false;
    notifyListeners();
  }

  // Program reordering (for UI)
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
  }

  @override
  void dispose() {
    _audioService.removeListener(_onAudioServiceChanged);
    _audioService.dispose();
    super.dispose();
  }
}

// Provider definition
final streamAudioProvider = ChangeNotifierProvider<StreamAudioProvider>(
  (ref) => StreamAudioProvider(),
);
