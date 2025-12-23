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
  // Simplified live-only playback: no interruption state or last-playback tracking

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
    debugPrint('AudioService: Starting reinitialize');

    // Cancel all subscriptions first
    await _playerStateSubscription?.cancel();
    await _playbackEventSubscription?.cancel();
    _playerStateSubscription = null;
    _playbackEventSubscription = null;

    // Cancel any reconnection timers
    _reconnectionTimer?.cancel();
    _reconnectionTimer = null;

    // Dispose old player if it exists
    if (_globalPlayer != null) {
      try {
        await _globalPlayer!.stop();
        await _globalPlayer!.dispose();
      } catch (e) {
        debugPrint('AudioService: Error disposing during reinitialize: $e');
      }
      _globalPlayer = null;
    }

    _isInitialized = false;
    _resetState();
    await init();
    debugPrint('AudioService: Reinitialize completed');
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
      final bool wasPlaying = _isPlaying;
      final bool wasLoading = _isLoading;

      _isPlaying = state.playing;
      // No last-playback tracking for pure live playback

      if (state.processingState == ProcessingState.loading || state.processingState == ProcessingState.buffering) {
        _isLoading = true;
      } else if (state.processingState == ProcessingState.ready ||
          state.processingState == ProcessingState.completed ||
          state.processingState == ProcessingState.idle) {
        _isLoading = false;
        if (_hasError) {
          _clearError();
        }
      }

      if (wasPlaying != _isPlaying || wasLoading != _isLoading) {
        notifyListeners();
      }
    }, onError: (error) {
      debugPrint('AudioService: Player state stream error: $error');
      _setError('Player error: $error');
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
      // Stop instead of pause to avoid buffering any past content
      await _player?.stop();
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
  void _handleUnexpectedStop() {}

  // Schedule automatic reconnection
  void _scheduleReconnection() {}

  // Setup audio focus handling for better interruption management
  void _setupAudioFocusHandling() {
    // This is a simplified approach - in a production app, you might want to use
    // a more sophisticated audio focus management system
  }

  // Check if audio should be playing but isn't (for background monitoring)
  bool get shouldBePlayingButIsnt => false;

  // Monitor and recover from background audio issues
  void monitorAndRecover() {}

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
    _currentChannelId = null;
    _currentStreamUrl = null;
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
    debugPrint('AudioService: Starting dispose');

    // Cancel all timers
    _reconnectionTimer?.cancel();
    _reconnectionTimer = null;

    // Cancel all subscriptions
    _playerStateSubscription?.cancel();
    _playbackEventSubscription?.cancel();
    _playerStateSubscription = null;
    _playbackEventSubscription = null;

    // Dispose global player
    _globalPlayer?.dispose();
    _globalPlayer = null;

    // Reset state
    _isInitialized = false;
    _globalInitialized = false;

    super.dispose();
    debugPrint('AudioService: Dispose completed');
  }
}
