import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

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
  StreamSubscription<PlaybackEvent>? _playbackEventSubscription;

  // Audio interruption handling
  Timer? _reconnectionTimer;

  // Stream info
  String? _currentStreamUrl;
  String? _currentChannelId;

  // State
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  bool _isInterrupted = false;
  DateTime? _lastPlaybackTime;

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
    await _playbackEventSubscription?.cancel();

    // Listen to player state changes
    _playerStateSubscription = _player!.playerStateStream.listen((state) {
      final wasPlaying = _isPlaying;
      final wasLoading = _isLoading;

      _isPlaying = state.playing;
      _lastPlaybackTime = DateTime.now();

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
      } else if (state.processingState == ProcessingState.idle) {
        // Handle unexpected idle state - this might indicate an interruption
        if (wasPlaying && !_isInterrupted) {
          debugPrint('AudioService: Unexpected idle state detected, attempting recovery');
          _handleUnexpectedStop();
        }
      }

      // Detect audio interruptions (when playing stops unexpectedly)
      if (wasPlaying && !_isPlaying && !_isInterrupted && state.processingState != ProcessingState.loading) {
        debugPrint('AudioService: Audio interruption detected');
        _isInterrupted = true;
      } else if (!wasPlaying && _isPlaying && _isInterrupted) {
        debugPrint('AudioService: Audio resumed after interruption');
        _isInterrupted = false;
      }

      // Notify listeners if either playing or loading state changed
      if (wasPlaying != _isPlaying || wasLoading != _isLoading) {
        debugPrint(
            'AudioService: State changed - playing: $_isPlaying, loading: $_isLoading, interrupted: $_isInterrupted');
        notifyListeners();
      }
    }, onError: (error) {
      debugPrint('AudioService: Player state stream error: $error');
      _setError('Player error: $error');
    });

    // Listen to playback events for additional monitoring
    _playbackEventSubscription = _player!.playbackEventStream.listen((event) {
      // Monitor for unexpected stops or errors
      if (event.processingState == ProcessingState.idle && _isPlaying) {
        debugPrint('AudioService: Playback event shows idle while playing flag is true');
        _handleUnexpectedStop();
      }
    }, onError: (error) {
      debugPrint('AudioService: Playback event stream error: $error');
    });

    // Setup audio focus handling for Android
    _setupAudioFocusHandling();
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
      final bool hasAudioSource = _player!.sequence?.isNotEmpty == true;

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
        // tag: MediaItem(
        //   id: _currentChannelId ?? 'unknown',
        //   title: _currentTitle ?? 'Live Radio',
        //   artist: _currentArtist ?? 'Unknown',
        //   artUri: _currentArtUri != null ? Uri.parse(_currentArtUri!) : null,
        // ),
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

  // Handle unexpected audio stops
  void _handleUnexpectedStop() {
    if (_currentStreamUrl != null && !_isInterrupted) {
      debugPrint('AudioService: Handling unexpected stop, scheduling reconnection');
      _scheduleReconnection();
    }
  }

  // Schedule automatic reconnection
  void _scheduleReconnection() {
    _reconnectionTimer?.cancel();
    _reconnectionTimer = Timer(const Duration(seconds: 2), () async {
      if (_currentStreamUrl != null && !_isPlaying && !_isLoading) {
        debugPrint('AudioService: Attempting automatic reconnection');
        try {
          await _playLiveStream();
        } catch (e) {
          debugPrint('AudioService: Reconnection failed: $e');
        }
      }
    });
  }

  // Setup audio focus handling for better interruption management
  void _setupAudioFocusHandling() {
    // This is a simplified approach - in a production app, you might want to use
    // a more sophisticated audio focus management system
  }

  // Check if audio should be playing but isn't (for background monitoring)
  bool get shouldBePlayingButIsnt {
    final now = DateTime.now();
    final timeSinceLastPlayback = _lastPlaybackTime != null ? now.difference(_lastPlaybackTime!).inSeconds : 0;

    // If we have a stream URL, we're not interrupted, not loading,
    // and it's been more than 30 seconds since last playback update
    return _currentStreamUrl != null && !_isInterrupted && !_isLoading && !_isPlaying && timeSinceLastPlayback > 30;
  }

  // Monitor and recover from background audio issues
  void monitorAndRecover() {
    if (shouldBePlayingButIsnt) {
      debugPrint('AudioService: Detected background audio issue, attempting recovery');
      _scheduleReconnection();
    }
  }

  // Stop and cleanup
  Future<void> stop() async {
    try {
      _reconnectionTimer?.cancel();
      _reconnectionTimer = null;

      await _playerStateSubscription?.cancel();
      await _playbackEventSubscription?.cancel();
      _playerStateSubscription = null;
      _playbackEventSubscription = null;

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
    _isInterrupted = false;
    _currentChannelId = null;
    _currentStreamUrl = null;
    _lastPlaybackTime = null;
    _reconnectionTimer?.cancel();
    _reconnectionTimer = null;
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
    _reconnectionTimer?.cancel();
    _playerStateSubscription?.cancel();
    _playbackEventSubscription?.cancel();
    _globalPlayer?.dispose();
    super.dispose();
  }
}
