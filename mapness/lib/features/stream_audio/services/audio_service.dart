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
  // Track when we expect audio to be playing (to distinguish user pause vs system interruption)
  bool _expectsToBePlaying = false;

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

      // Handle processing state - idle and completed indicate stopped state
      // Even if state.playing is true, if processingState is idle/completed, audio is stopped
      if (state.processingState == ProcessingState.idle || state.processingState == ProcessingState.completed) {
        // Player is stopped, regardless of playing flag
        _isPlaying = false;
        _isLoading = false;

        // If we expected to be playing but now we're stopped, this is an unexpected stop
        if (_expectsToBePlaying) {
          debugPrint('AudioService: Unexpected stop detected - processingState: ${state.processingState}');
          _handleUnexpectedStop();
        }

        if (_hasError) {
          _clearError();
        }
      } else {
        // For other states, use the playing flag
        _isPlaying = state.playing;

        if (state.processingState == ProcessingState.loading || state.processingState == ProcessingState.buffering) {
          _isLoading = true;
        } else if (state.processingState == ProcessingState.ready) {
          _isLoading = false;
          if (_hasError) {
            _clearError();
          }
        }
      }

      if (wasPlaying != _isPlaying || wasLoading != _isLoading) {
        notifyListeners();
      }
    }, onError: (error) {
      debugPrint('AudioService: Player state stream error: $error');
      _setError('Player error: $error');
    });

    // Listen to playback events for errors and interruptions
    _playbackEventSubscription = _player!.playbackEventStream.listen((event) {
      // Handle playback errors
      if (event.processingState == ProcessingState.idle || event.processingState == ProcessingState.completed) {
        // Check if this is an unexpected stop
        if (_expectsToBePlaying && !_isPlaying) {
          debugPrint(
              'AudioService: Playback event indicates unexpected stop - processingState: ${event.processingState}');
          _handleUnexpectedStop();
        }
      }
    }, onError: (error) {
      debugPrint('AudioService: Playback event stream error: $error');
      _handleUnexpectedStop();
      // Don't set error here as state stream will handle it, but log it
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

      // Mark that we expect audio to be playing
      _expectsToBePlaying = true;

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
      // Mark that we no longer expect to be playing (user-initiated pause)
      _expectsToBePlaying = false;
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

  // Synchronize internal state with actual player state
  void syncState() {
    if (_player == null) {
      _isPlaying = false;
      _isLoading = false;
      return;
    }

    try {
      final currentState = _player!.playerState;

      // Check actual playing state
      final isActuallyPlaying = currentState.playing &&
          currentState.processingState != ProcessingState.idle &&
          currentState.processingState != ProcessingState.completed;

      // Check loading state
      final isActuallyLoading = currentState.processingState == ProcessingState.loading ||
          currentState.processingState == ProcessingState.buffering;

      final bool wasPlaying = _isPlaying;
      final bool wasLoading = _isLoading;

      _isPlaying = isActuallyPlaying;
      _isLoading = isActuallyLoading;

      // If state changed, notify listeners
      if (wasPlaying != _isPlaying || wasLoading != _isLoading) {
        debugPrint('AudioService: State synced - isPlaying: $_isPlaying, isLoading: $_isLoading');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('AudioService: Error syncing state: $e');
    }
  }

  Future<void> togglePlayPause() async {
    // Sync state first to ensure we have accurate information
    syncState();

    // Now check the actual state (not just _isPlaying which might be stale)
    if (_player != null) {
      final currentState = _player!.playerState;
      final isActuallyPlaying = currentState.playing &&
          currentState.processingState != ProcessingState.idle &&
          currentState.processingState != ProcessingState.completed;

      if (isActuallyPlaying) {
        await pause();
      } else {
        await resume();
      }
    } else {
      // No player, try to resume (which will initialize if needed)
      await resume();
    }
  }

  // Handle unexpected audio stops
  void _handleUnexpectedStop() {
    debugPrint('AudioService: Handling unexpected stop');
    // Update state to reflect that audio is stopped
    _isPlaying = false;
    _isLoading = false;
    // Keep _expectsToBePlaying as true so monitorAndRecover can attempt recovery
    notifyListeners();
  }

  // Schedule automatic reconnection
  void _scheduleReconnection() {}

  // Setup audio focus handling for better interruption management
  void _setupAudioFocusHandling() {
    // This is a simplified approach - in a production app, you might want to use
    // a more sophisticated audio focus management system
  }

  // Check if audio should be playing but isn't (for background monitoring)
  bool get shouldBePlayingButIsnt {
    if (!_expectsToBePlaying) {
      return false; // We don't expect to be playing, so no issue
    }

    if (_player == null) {
      return true; // Player is null but we expect to be playing
    }

    try {
      final currentState = _player!.playerState;
      // Check if player state indicates it's not actually playing
      final isActuallyPlaying = currentState.playing &&
          currentState.processingState != ProcessingState.idle &&
          currentState.processingState != ProcessingState.completed;

      return !isActuallyPlaying;
    } catch (e) {
      debugPrint('AudioService: Error checking shouldBePlayingButIsnt: $e');
      return false;
    }
  }

  // Monitor and recover from background audio issues
  void monitorAndRecover() {
    // First, immediately sync state with actual player state
    syncState();

    if (!_expectsToBePlaying || _currentStreamUrl == null) {
      return; // Nothing to recover
    }

    if (shouldBePlayingButIsnt) {
      debugPrint('AudioService: Detected audio should be playing but isn\'t - attempting recovery');

      // State already synced by syncState() above, so _isPlaying should be false now
      // Attempt to recover by restarting playback
      // Use a small delay to avoid rapid reconnection attempts
      _reconnectionTimer?.cancel();
      _reconnectionTimer = Timer(const Duration(seconds: 2), () {
        if (_expectsToBePlaying && _currentStreamUrl != null && _player != null) {
          debugPrint('AudioService: Attempting to recover playback');
          _playLiveStream().catchError((error) {
            debugPrint('AudioService: Recovery attempt failed: $error');
            // If recovery fails, stop expecting to play
            _expectsToBePlaying = false;
            _setError('Playback stopped unexpectedly and recovery failed');
          });
        }
      });
    }
    // If audio is playing correctly, syncState() already handled synchronization
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
    _expectsToBePlaying = false;
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
