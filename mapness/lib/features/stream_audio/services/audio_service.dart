import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AudioService extends ChangeNotifier {
  static final AudioService _instance = AudioService._internal();
  static bool _globalInitialized = false;
  static AudioPlayer? _globalPlayer; // Global static player instance

  factory AudioService() => _instance;

  AudioService._internal();

  // Player (reference to global static instance)
  AudioPlayer? get _player => _globalPlayer;

  // Player stream subscriptions
  StreamSubscription<PlayerState>? _playerStateSubscription;

  // Stream info
  String? _currentStreamUrl;
  String? _currentChannelId;
  String? _currentTitle;
  String? _currentArtist;
  String? _currentArtUri;

  // State
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  String? get currentChannelId => _currentChannelId;

  // Global initialization - should be called once at app startup
  static Future<void> initializeGlobally() async {
    if (_globalInitialized) {
      debugPrint('AudioService: Global initialization already completed, skipping');
      return;
    }

    debugPrint(
        'AudioService: Marking global initialization as complete (JustAudioBackground initialized in main.dart)');

    // Dispose any existing global player first
    if (_globalPlayer != null) {
      debugPrint('AudioService: Disposing existing global player before initialization');
      try {
        await _globalPlayer!.dispose();
      } catch (e) {
        debugPrint('AudioService: Error disposing existing player: $e');
      }
      _globalPlayer = null;
    }

    _globalInitialized = true;
    debugPrint('AudioService: Global initialization completed successfully');
  }

  // Initialization
  Future<void> init() async {
    if (_isInitialized && _globalPlayer != null) {
      debugPrint('AudioService: Already initialized, skipping');
      return;
    }

    try {
      // Mark global as initialized since JustAudioBackground is initialized in main.dart
      _globalInitialized = true;

      // Ensure no existing player (just_audio_background only supports one instance)
      if (_globalPlayer != null) {
        try {
          debugPrint('AudioService: Disposing existing player in init');
          await _globalPlayer!.dispose();
        } catch (e) {
          debugPrint('AudioService: Error disposing existing player in init: $e');
        }
        _globalPlayer = null;
      }

      debugPrint('AudioService: Creating new AudioPlayer instance');
      _globalPlayer = AudioPlayer();
      await _setupPlayerListeners();
      _isInitialized = true;
      debugPrint('AudioService: AudioPlayer initialization completed');
    } catch (e) {
      debugPrint('AudioService: Failed to initialize: $e');
      _setError('Failed to initialize: $e');
    }
  }

  // Reinitialize after disposal
  Future<void> reinitialize() async {
    // Cancel subscriptions
    await _playerStateSubscription?.cancel();
    _playerStateSubscription = null;

    // Dispose old player if it exists
    if (_globalPlayer != null) {
      try {
        await _globalPlayer!.dispose();
      } catch (e) {
        debugPrint('AudioService: Error disposing during reinitialize: $e');
      }
      _globalPlayer = null;
    }

    _isInitialized = false;
    _resetState();
    await init();
  }

  Future<void> _setupPlayerListeners() async {
    if (_player == null) {
      return;
    }

    // Cancel existing subscriptions first
    await _playerStateSubscription?.cancel();

    // Listen to player state changes
    _playerStateSubscription = _player!.playerStateStream.listen((state) {
      final wasPlaying = _isPlaying;
      final wasLoading = _isLoading;

      _isPlaying = state.playing;

      // Manage loading state based on processing state
      if (state.processingState == ProcessingState.loading || state.processingState == ProcessingState.buffering) {
        _isLoading = true;
      } else if (state.processingState == ProcessingState.ready || state.processingState == ProcessingState.completed) {
        _isLoading = false;

        // Clear any errors when playback is ready/completed successfully
        if (_hasError) {
          _clearError();
          notifyListeners();
          return; // Already notified
        }
      }

      // Notify listeners if either playing or loading state changed
      if (wasPlaying != _isPlaying || wasLoading != _isLoading) {
        notifyListeners();
      }
    });
  }

  // Main playback method
  Future<void> playStream({
    required String url,
    required String channelId,
    String? title,
    String? programName,
    String? artUri,
  }) async {
    try {
      if (!_isInitialized) {
        await init();
      }

      _clearError();

      _currentChannelId = channelId;
      _currentStreamUrl = url;
      _currentTitle = title;
      _currentArtist = programName;
      _currentArtUri = artUri;

      await _playLiveStream();
    } catch (e) {
      _setError('Failed to play: $e');
    }
  }

  // Live stream playback
  Future<void> _playLiveStream() async {
    if (_player == null || _currentStreamUrl == null) {
      return;
    }

    try {
      // Clear any errors before attempting playback
      _clearError();

      // Check if player has a sequence (audio source) loaded
      // If so, we need to properly stop it first to avoid iOS CoreMedia errors
      final hasAudioSource = _player!.sequence.isNotEmpty;

      if (hasAudioSource) {
        debugPrint('AudioService: Stopping current audio source');
        try {
          // Stop and wait for completion
          await _player!.stop();
          // Wait a bit longer for iOS to fully release resources
          await Future.delayed(const Duration(milliseconds: 200));
        } catch (e) {
          debugPrint('AudioService: Error stopping player: $e (continuing...)');
        }
      }

      debugPrint('AudioService: Setting new audio source: $_currentStreamUrl');

      final audioSource = AudioSource.uri(
        Uri.parse(_currentStreamUrl!),
        tag: MediaItem(
          id: _currentChannelId ?? 'unknown',
          title: _currentTitle ?? 'Live Radio',
          artist: _currentArtist ?? 'Unknown',
          artUri: _currentArtUri != null ? Uri.parse(_currentArtUri!) : null,
        ),
      );

      await _player!.setAudioSource(audioSource);
      debugPrint('AudioService: Audio source set, starting playback');
      await _player!.play();
      debugPrint('AudioService: Playback started successfully');

      // Clear error again after successful playback start
      _clearError();
      notifyListeners();
    } catch (e) {
      debugPrint('AudioService: Playback error: $e');
      _setError('Playback error: $e');
      rethrow;
    }
  }

  // Playback controls
  Future<void> pause() async {
    try {
      await _player?.pause();
      notifyListeners();
    } catch (e) {
      debugPrint('AudioService: Pause error: $e');
    }
  }

  Future<void> resume() async {
    try {
      if (_player == null || _currentStreamUrl == null) {
        return;
      }

      // Always reconnect to live stream when resuming
      // This is the key behavior - pause means disconnect, resume means reconnect
      await _playLiveStream();
      notifyListeners();
    } catch (e) {
      debugPrint('AudioService: Resume error: $e');
    }
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      await resume();
    }
  }

  // Stop and cleanup
  Future<void> stop() async {
    try {
      await _playerStateSubscription?.cancel();
      _playerStateSubscription = null;
      await _globalPlayer?.stop();
      await _globalPlayer?.dispose();
      _globalPlayer = null;
      _isInitialized = false;
      _resetState();
    } catch (e) {
      debugPrint('AudioService: Stop error: $e');
    }
  }

  // State management
  void _resetState() {
    _isPlaying = false;
    _isLoading = false;
    _currentChannelId = null;
    _currentStreamUrl = null;
    _currentTitle = null;
    _currentArtist = null;
    _currentArtUri = null;
    _clearError();
    notifyListeners();
  }

  void _setError(String message) {
    _hasError = true;
    _errorMessage = message;
    _isLoading = false;
    _isPlaying = false;
    notifyListeners();
  }

  void _clearError() {
    _hasError = false;
    _errorMessage = null;
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _globalPlayer?.dispose();
    super.dispose();
  }
}
