import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

enum AudioPlayerState {
  idle,
  loading,
  playing,
  paused,
  error,
}

class AudioService extends ChangeNotifier {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  AudioPlayerState _state = AudioPlayerState.idle;
  String? _currentUrl;
  String? _errorMessage;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  // Getters
  AudioPlayerState get state => _state;
  String? get currentUrl => _currentUrl;
  String? get errorMessage => _errorMessage;
  Duration get duration => _duration;
  Duration get position => _position;
  bool get isPlaying => _state == AudioPlayerState.playing;
  bool get isLoading => _state == AudioPlayerState.loading;
  bool get hasError => _state == AudioPlayerState.error;

  void _updateState(AudioPlayerState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  Future<void> init() async {
    // Listen to player state changes
    _audioPlayer.playerStateStream.listen((playerState) {
      switch (playerState.processingState) {
        case ProcessingState.idle:
          _updateState(AudioPlayerState.idle);
          break;
        case ProcessingState.loading:
        case ProcessingState.buffering:
          _updateState(AudioPlayerState.loading);
          break;
        case ProcessingState.ready:
          if (playerState.playing) {
            _updateState(AudioPlayerState.playing);
          } else {
            _updateState(AudioPlayerState.paused);
          }
          break;
        case ProcessingState.completed:
          _updateState(AudioPlayerState.paused);
          break;
      }
    });

    // Listen to duration changes
    _audioPlayer.durationStream.listen((duration) {
      _duration = duration ?? Duration.zero;
      notifyListeners();
    });

    // Listen to position changes
    _audioPlayer.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });

    // Listen to errors
    _audioPlayer.playbackEventStream.listen(
      (event) {},
      onError: (Object e, StackTrace stackTrace) {
        _errorMessage = e.toString();
        _updateState(AudioPlayerState.error);
        debugPrint('Audio Player Error: $e');
      },
    );
  }

  Future<void> playStream(
    String url, {
    String? title,
    String? artist,
    String? artUri,
  }) async {
    try {
      _errorMessage = null;

      // If same URL is already playing, just resume
      if (_currentUrl == url && _state == AudioPlayerState.paused) {
        await resume();
        return;
      }

      // If different URL or not loaded, load new stream
      if (_currentUrl != url) {
        _updateState(AudioPlayerState.loading);
        _currentUrl = url;

        // Create MediaItem for background audio support
        final mediaItem = MediaItem(
          id: url,
          title: title ?? 'Radio Stream',
          artist: artist ?? 'Unknown Artist',
          artUri: artUri != null ? Uri.parse(artUri) : null,
        );

        // Create AudioSource with MediaItem tag
        final audioSource = AudioSource.uri(
          Uri.parse(url),
          tag: mediaItem,
        );

        await _audioPlayer.setAudioSource(audioSource);
      }

      await _audioPlayer.play();
    } catch (e) {
      _errorMessage = e.toString();
      _updateState(AudioPlayerState.error);
      debugPrint('Error playing stream: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      _errorMessage = e.toString();
      _updateState(AudioPlayerState.error);
      debugPrint('Error pausing stream: $e');
    }
  }

  Future<void> resume() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      _errorMessage = e.toString();
      _updateState(AudioPlayerState.error);
      debugPrint('Error resuming stream: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _currentUrl = null;
      _updateState(AudioPlayerState.idle);
    } catch (e) {
      _errorMessage = e.toString();
      _updateState(AudioPlayerState.error);
      debugPrint('Error stopping stream: $e');
    }
  }

  Future<void> seekForward(
      [Duration duration = const Duration(seconds: 15)]) async {
    try {
      final newPosition = _position + duration;
      final maxPosition = _duration;

      if (maxPosition > Duration.zero && newPosition <= maxPosition) {
        await _audioPlayer.seek(newPosition);
      } else if (maxPosition > Duration.zero) {
        await _audioPlayer.seek(maxPosition);
      }
    } catch (e) {
      debugPrint('Error seeking forward: $e');
    }
  }

  Future<void> seekBackward(
      [Duration duration = const Duration(seconds: 15)]) async {
    try {
      final newPosition = _position - duration;

      if (newPosition >= Duration.zero) {
        await _audioPlayer.seek(newPosition);
      } else {
        await _audioPlayer.seek(Duration.zero);
      }
    } catch (e) {
      debugPrint('Error seeking backward: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
