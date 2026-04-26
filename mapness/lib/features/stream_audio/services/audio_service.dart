import 'dart:async';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AudioService extends ChangeNotifier {
  static final AudioService _instance = AudioService._internal();
  static bool _backgroundInitialized = false;
  static AudioPlayer? _globalPlayer;

  factory AudioService() => _instance;

  AudioService._internal();

  AudioPlayer? get _player => _globalPlayer;

  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<PlaybackEvent>? _playbackEventSubscription;
  StreamSubscription<AudioInterruptionEvent>? _audioInterruptionSubscription;
  StreamSubscription<SequenceState?>? _sequenceStateSubscription;

  Timer? _reconnectionTimer;
  Timer? _dismissalCheckTimer; // Periodic check for dismissal
  AudioSession? _audioSession;
  MethodChannel? _audioCoordinationChannel;

  bool _wasPlayingBeforeInterruption = false;
  bool _isInterrupted = false;
  bool _isDucked = false;
  bool _isNavigationDucking = false;
  bool _wasPlayingBeforeNavigationDuck = false;
  Timer? _navigationDuckingFailsafeTimer;

  String? _currentStreamUrl;
  String? _currentChannelId;
  String? _currentTitle;
  String? _currentArtist;
  String? _currentArtUri;

  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  bool _expectsToBePlaying = false;
  bool _isStoppingInternally = false; // Track if stop() was called internally
  bool _isHandlingDismissal = false; // Prevent multiple dismissal handling
  bool _isStartingPlayback = false; // Track when we're actively starting playback
  static const Duration _startPlaybackTimeout = Duration(seconds: 60); //timeout after one min

  // Callback for notification dismissal
  VoidCallback? _onNotificationDismissed;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  String? get currentChannelId => _currentChannelId;
  bool get isDucked => _isDucked;
  bool get isEffectivelyPlaying => _isPlaying || _isDucked;

  // Set callback for notification dismissal
  void setOnNotificationDismissedCallback(VoidCallback? callback) {
    _onNotificationDismissed = callback;
  }

  static Future<void> initializeGlobally() async {
    if (_backgroundInitialized) {
      debugPrint('AudioService: Global background initialization already completed');
      return;
    }

    debugPrint('AudioService: Starting global background initialization');

    try {
      await JustAudioBackground.init(
        androidNotificationChannelId: 'com.balady.audio.channel',
        androidNotificationChannelName: 'Live Radio',
        androidNotificationChannelDescription: 'Live radio streaming controls',
        androidNotificationOngoing: true,
        androidShowNotificationBadge: true,
        androidNotificationClickStartsActivity: true,
        androidNotificationIcon: 'mipmap/ic_launcher',
        preloadArtwork: true,
        artDownscaleWidth: 300,
        artDownscaleHeight: 300,
        fastForwardInterval: const Duration(seconds: 15),
        rewindInterval: const Duration(seconds: 15),
      );
      _backgroundInitialized = true;
      debugPrint('AudioService: ✅ Global background initialization completed');
    } catch (e) {
      debugPrint('AudioService: ❌ Global background initialization failed: $e');
      // Don't throw exception - allow app to continue without background audio
      debugPrint('AudioService: Continuing without background audio support');
    }
  }

  Future<void> init() async {
    if (_isInitialized && _globalPlayer != null) {
      debugPrint('AudioService: Already initialized');
      return;
    }

    try {
      debugPrint('AudioService: Starting initialization');

      // Dispose existing player if any
      if (_globalPlayer != null) {
        try {
          debugPrint('AudioService: Disposing existing player');
          await _globalPlayer!.dispose();
        } catch (e) {
          debugPrint('AudioService: Error disposing existing player: $e');
        }
        _globalPlayer = null;
      }

      // Configure audio session first
      await _configureAudioSession();

      // Initialize background service if not already done
      if (!_backgroundInitialized) {
        debugPrint('AudioService: Attempting background initialization...');
        try {
          await JustAudioBackground.init(
            androidNotificationChannelId: 'com.balady.audio.channel',
            androidNotificationChannelName: 'Live Radio',
            androidNotificationChannelDescription: 'Live radio streaming controls',
            androidNotificationOngoing: true,
            androidShowNotificationBadge: true,
            androidNotificationClickStartsActivity: true,
            androidNotificationIcon: 'mipmap/ic_launcher',
            preloadArtwork: true,
            artDownscaleWidth: 300,
            artDownscaleHeight: 300,
            fastForwardInterval: const Duration(seconds: 15),
            rewindInterval: const Duration(seconds: 15),
          );
          _backgroundInitialized = true;
          debugPrint('AudioService: ✅ JustAudioBackground initialized successfully');
        } catch (e) {
          debugPrint('AudioService: ❌ JustAudioBackground initialization failed: $e');
          debugPrint('AudioService: Continuing without background support');
        }
      } else {
        debugPrint('AudioService: JustAudioBackground already initialized');
      }

      // Create AudioPlayer
      debugPrint('AudioService: Creating AudioPlayer');
      _globalPlayer = AudioPlayer();
      debugPrint('AudioService: ✅ AudioPlayer created successfully');

      // Setup listeners
      await _setupPlayerListeners();

      // Setup iOS audio coordination if on iOS
      if (Platform.isIOS) {
        await _setupIOSAudioCoordination();
      }

      _isInitialized = true;
      debugPrint('AudioService: ✅ Initialization completed successfully');
    } catch (e) {
      debugPrint('AudioService: ❌ Failed to initialize: $e');
      _setError('Failed to initialize: $e');
    }
  }

  Future<void> testAudioService() async {
    final audioService = AudioService();
    await audioService.init();

    await audioService.playStream(
      url: 'https://d2ssktsthzv4nj.cloudfront.net/mbcfm-radio.m3u8',
      channelId: 'test',
      title: 'Test Radio',
      programName: 'Test Program',
    );

    debugPrint('Test: Audio service playStream called');
  }

  Future<void> reinitialize() async {
    debugPrint('AudioService: Reinitializing service');

    // Clean up existing state
    await _cleanup();

    // Reset state
    _isInitialized = false;
    _isPlaying = false;
    _isLoading = false;
    _hasError = false;
    _errorMessage = null;
    _expectsToBePlaying = false;
    _isDucked = false;
    _isInterrupted = false;

    // Reinitialize
    await init();

    debugPrint('AudioService: ✅ Reinitialize completed');
  }

  Future<void> _configureAudioSession() async {
    try {
      _audioSession = await AudioSession.instance;

      // Configure for proper lock screen controls and interruption handling
      await _audioSession!.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.allowBluetooth,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: false,
      ));

      debugPrint('AudioService: ✅ Audio session configured successfully');

      // Cancel existing subscription
      await _audioInterruptionSubscription?.cancel();

      // Listen for audio interruptions
      _audioInterruptionSubscription = _audioSession!.interruptionEventStream.listen(
        (event) {
          debugPrint('AudioService: 🔔 INTERRUPTION EVENT - begin: ${event.begin}, type: ${event.type}');

          if (event.begin) {
            _handleInterruptionBegan(event);
          } else {
            _handleInterruptionEnded(event);
          }
        },
        onError: (error) {
          debugPrint('AudioService: Interruption stream error: $error');
        },
        cancelOnError: false,
      );

      // Listen for becomingNoisy
      _audioSession!.becomingNoisyEventStream.listen((_) {
        debugPrint('AudioService: 🔊 Audio becoming noisy (headphones unplugged)');
        if (_isPlaying) {
          pause();
        }
      });

      debugPrint('AudioService: ✅ Interruption listeners configured');
    } catch (e) {
      debugPrint('AudioService: ❌ Error configuring audio session: $e');
      // Don't rethrow - allow initialization to continue
    }
  }

  void _handleInterruptionBegan(AudioInterruptionEvent event) {
    debugPrint('AudioService: 🛑 INTERRUPTION BEGAN - '
        'type: ${event.type}, '
        'expectsToBePlaying: $_expectsToBePlaying, '
        'isPlaying: $_isPlaying');

    if (_isInterrupted) {
      debugPrint('AudioService: Already interrupted, ignoring');
      return;
    }

    if (!_expectsToBePlaying) {
      debugPrint('AudioService: Not expecting to play, ignoring interruption');
      return;
    }

    _wasPlayingBeforeInterruption = _isPlaying;
    _isInterrupted = true;

    if (_isPlaying) {
      debugPrint('AudioService: Pausing due to interruption');
      pause();
    }

    syncState();
    notifyListeners();
  }

  void _handleInterruptionEnded(AudioInterruptionEvent event) {
    debugPrint('AudioService: ▶️ INTERRUPTION ENDED - '
        'wasPlayingBefore: $_wasPlayingBeforeInterruption, '
        'expectsToBePlaying: $_expectsToBePlaying');

    if (!_isInterrupted) {
      debugPrint('AudioService: Not interrupted, ignoring interruption end');
      return;
    }

    _isInterrupted = false;

    if (_wasPlayingBeforeInterruption && _expectsToBePlaying) {
      debugPrint('AudioService: Resuming after interruption');
      resume();
    }

    syncState();
    notifyListeners();
  }

  Future<void> _setupPlayerListeners() async {
    if (_player == null) return;

    // Cancel existing subscriptions
    await _playerStateSubscription?.cancel();
    await _playbackEventSubscription?.cancel();
    await _sequenceStateSubscription?.cancel();

    // Listen to sequence state changes to detect track changes from lock screen
    _sequenceStateSubscription = _player!.sequenceStateStream.listen((state) {
      if (state?.currentSource?.tag is MediaItem) {
        final mediaItem = state!.currentSource!.tag as MediaItem;
        if (_currentChannelId != mediaItem.id) {
          debugPrint('AudioService: 🎵 Track changed via lock screen/controls to: ${mediaItem.id}');
          _currentChannelId = mediaItem.id;
          _currentTitle = mediaItem.title;
          _currentArtist = mediaItem.artist;
          _currentArtUri = mediaItem.artUri?.toString();
          
          if (state.currentSource is UriAudioSource) {
            _currentStreamUrl = (state.currentSource as UriAudioSource).uri.toString();
          }
          
          syncState();
          notifyListeners();
        }
      }
    });

    // Listen to player state changes
    _playerStateSubscription = _player!.playerStateStream.listen(
      (state) {
        debugPrint('AudioService: 🎵 Player state changed - '
            'playing: ${state.playing}, '
            'processingState: ${state.processingState}, '
            'expectsToBePlaying: $_expectsToBePlaying, '
            'isStoppingInternally: $_isStoppingInternally, '
            'isStartingPlayback: $_isStartingPlayback');

        // Detect notification dismissal: player stopped unexpectedly while we expect it to be playing
        // But ignore if we're actively starting playback (initial idle state is normal)
        final isStopped = !state.playing &&
            (state.processingState == ProcessingState.idle || state.processingState == ProcessingState.completed);

        if (_expectsToBePlaying && isStopped) {
          debugPrint('AudioService: 🔍 Potential dismissal detected - '
              'expectsToBePlaying: $_expectsToBePlaying, '
              'isStoppingInternally: $_isStoppingInternally, '
              'isStartingPlayback: $_isStartingPlayback');

          if (!_isStoppingInternally && !_isStartingPlayback) {
            debugPrint('AudioService: 🚫 Notification dismissed - player stopped unexpectedly');
            _handleNotificationDismissed();
          } else {
            debugPrint('AudioService: ⏸️ Ignoring dismissal - '
                'isStoppingInternally: $_isStoppingInternally, '
                'isStartingPlayback: $_isStartingPlayback');
          }
        }

        syncState();
      },
      onError: (error) {
        debugPrint('AudioService: Player state stream error: $error');
        _setError('Player state error: $error');
      },
    );

    // Listen to playback events for buffering and errors
    _playbackEventSubscription = _player!.playbackEventStream.listen(
      (event) {
        debugPrint('AudioService: 📻 Playback event - '
            'processingState: ${event.processingState}');

        if (event.processingState == ProcessingState.buffering) {
          debugPrint('AudioService: 🔄 Buffering...');
        }

        // Also check for dismissal in playback events
        // Sometimes the state change happens here first
        final isStopped =
            event.processingState == ProcessingState.idle || event.processingState == ProcessingState.completed;

        if (_expectsToBePlaying && isStopped && !_isStoppingInternally && !_isStartingPlayback) {
          debugPrint('AudioService: 🚫 Notification dismissed detected in playback event stream');
          _handleNotificationDismissed();
        }
      },
      onError: (error) {
        debugPrint('AudioService: Playback event stream error: $error');
        _setError('Playback error: $error');
      },
    );

    debugPrint('AudioService: ✅ Player listeners configured');

    // Start periodic check for dismissal (as backup detection)
    _startDismissalCheckTimer();
  }

  /// Start periodic timer to check if player was dismissed
  void _startDismissalCheckTimer() {
    _dismissalCheckTimer?.cancel();
    _dismissalCheckTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!_expectsToBePlaying || _isStoppingInternally || _isStartingPlayback) {
        return; // Don't check if we don't expect to be playing or are stopping/starting
      }

      if (_player == null) {
        if (_currentChannelId != null) {
          debugPrint('AudioService: 🔍 Periodic check - Player is null but we expect to be playing');
          _handleNotificationDismissed();
        }
        return;
      }

      final state = _player!.playerState;
      final isStopped = !state.playing &&
          (state.processingState == ProcessingState.idle || state.processingState == ProcessingState.completed);

      if (isStopped) {
        debugPrint('AudioService: 🔍 Periodic check - Player stopped unexpectedly');
        debugPrint('AudioService: 🔍 State - playing: ${state.playing}, processingState: ${state.processingState}');
        debugPrint(
            'AudioService: 🔍 Flags - expectsToBePlaying: $_expectsToBePlaying, isStoppingInternally: $_isStoppingInternally, isStartingPlayback: $_isStartingPlayback');
        _handleNotificationDismissed();
      }
    });
  }

  /// Stop the dismissal check timer
  void _stopDismissalCheckTimer() {
    _dismissalCheckTimer?.cancel();
    _dismissalCheckTimer = null;
  }

  Future<void> playStream({
    required String url,
    required String channelId,
    String? title,
    String? programName,
    String? artUri,
    List<Map<String, dynamic>>? playlist,
    int? initialIndex,
  }) async {
    debugPrint('AudioService: 🎵 playStream called - URL: $url, Channel: $channelId');

    if (!_isInitialized || _player == null) {
      debugPrint('AudioService: Not initialized, initializing first');
      await init();
    }

    if (_player == null) {
      debugPrint('AudioService: ❌ Player is null after initialization');
      _setError('Failed to initialize audio player');
      return;
    }

    try {
      // Reset dismissal handling flag when starting new stream
      _isHandlingDismissal = false;

      _currentStreamUrl = url;
      _currentChannelId = channelId;
      _currentTitle = title ?? 'Live Radio';
      _currentArtist = programName ?? 'Live Stream';
      _currentArtUri = artUri;
      _expectsToBePlaying = true;
      _clearError();

      // Start periodic dismissal check when starting playback
      _startDismissalCheckTimer();

      debugPrint('AudioService: Setting audio source...');

      await _playLiveStream(playlist: playlist, initialIndex: initialIndex);

      // Notify iOS that MBC is now active
      await _notifyIOSMBCActive();

      debugPrint('AudioService: ✅ Stream started successfully');
    } catch (e) {
      debugPrint('AudioService: ❌ Error in playStream: $e');
      _setError('Failed to play stream: $e');
    }
  }

  Future<void> _playLiveStream({List<Map<String, dynamic>>? playlist, int? initialIndex}) async {
    if (_player == null || _currentStreamUrl == null) return;

    try {
      debugPrint('AudioService: 🎵 _playLiveStream - URL: $_currentStreamUrl');

      // Mark that we're starting playback to prevent false dismissal detection
      _isStartingPlayback = true;

      await Future<void>(() async {
        if (playlist != null && playlist.isNotEmpty) {
          final children = playlist.map((item) {
            return AudioSource.uri(
              Uri.parse(item['url'] as String),
              tag: MediaItem(
                id: item['id'] as String,
                title: item['title'] as String? ?? 'Live Radio',
                artist: item['programName'] as String? ?? 'Live Stream',
                artUri: item['artUri'] != null ? Uri.parse(item['artUri'] as String) : null,
              ),
            );
          }).toList();

          final source = ConcatenatingAudioSource(
            useLazyPreparation: true,
            children: children,
          );

          await _player!.setAudioSource(source, initialIndex: initialIndex ?? 0);
        } else {
          // Set the audio source with metadata
          final audioSource = AudioSource.uri(
            Uri.parse(_currentStreamUrl!),
            tag: MediaItem(
              id: _currentChannelId ?? 'unknown',
              title: _currentTitle ?? 'Live Radio',
              artist: _currentArtist ?? 'Live Stream',
              artUri: _currentArtUri != null ? Uri.parse(_currentArtUri!) : null,
            ),
          );
          await _player!.setAudioSource(audioSource);
        }

        debugPrint('AudioService: Audio source set, starting playback...');
        await _player!.play();

        // Wait a bit for playback to actually start before clearing the flag
        // This prevents false dismissal detection during the initial idle->loading->playing transition
        await Future.delayed(const Duration(milliseconds: 500));
      }).timeout(_startPlaybackTimeout);

      _isStartingPlayback = false;

      debugPrint('AudioService: ✅ Playback started');
      syncState();
      notifyListeners();
    } catch (e) {
      _isStartingPlayback = false; // Reset flag on error
      debugPrint('AudioService: ❌ Error in _playLiveStream: $e');
      _setError('Failed to start playback: $e');
    }
  }

  Future<void> pause() async {
    debugPrint('AudioService: ⏸️ pause called');

    if (_player == null) {
      debugPrint('AudioService: Player is null, cannot pause');
      return;
    }

    try {
      await _player!.pause();
      debugPrint('AudioService: ✅ Paused successfully');
      syncState();
      notifyListeners();
    } catch (e) {
      debugPrint('AudioService: ❌ Error pausing: $e');
    }
  }

  Future<void> resume() async {
    debugPrint('AudioService: ▶️ resume called');

    if (_player == null) {
      debugPrint('AudioService: Player is null, cannot resume');
      return;
    }

    if (!_expectsToBePlaying) {
      debugPrint('AudioService: Not expecting to be playing, ignoring resume');
      return;
    }

    try {
      await _player!.play();
      debugPrint('AudioService: ✅ Resumed successfully');
      syncState();
      notifyListeners();
    } catch (e) {
      debugPrint('AudioService: ❌ Error resuming: $e');
    }
  }

  void syncState() {
    if (_player == null) {
      _isPlaying = false;
      _isLoading = false;
      _isDucked = false;
      _isInterrupted = false;
      return;
    }

    try {
      final currentState = _player!.playerState;

      final isActuallyPlaying = currentState.playing &&
          currentState.processingState != ProcessingState.idle &&
          currentState.processingState != ProcessingState.completed;

      final isActuallyLoading = currentState.processingState == ProcessingState.loading ||
          currentState.processingState == ProcessingState.buffering;

      final bool wasPlaying = _isPlaying;
      final bool wasLoading = _isLoading;

      _isPlaying = isActuallyPlaying;
      _isLoading = isActuallyLoading;

      if (wasPlaying != _isPlaying || wasLoading != _isLoading) {
        debugPrint(
            'AudioService: State synced - isPlaying: $_isPlaying, isLoading: $_isLoading, isDucked: $_isDucked, isInterrupted: $_isInterrupted');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('AudioService: Error syncing state: $e');
    }
  }

  Future<void> togglePlayPause() async {
    debugPrint('AudioService: 🔄 togglePlayPause called - current isPlaying: $_isPlaying, isLoading: $_isLoading');

    if (_isLoading) {
      debugPrint('AudioService: Currently loading, ignoring toggle');
      return;
    }

    if (_isPlaying) {
      await pause();
    } else {
      await resume();
    }
  }

  Future<void> stop() async {
    debugPrint('AudioService: 🛑 stop called');

    _stopDismissalCheckTimer(); // Stop periodic checks when stopping

    _isStoppingInternally = true; // Mark that we're stopping internally
    _isStartingPlayback = false; // Reset playback flag
    _expectsToBePlaying = false;
    _isInterrupted = false;
    _isDucked = false;

    if (_player != null) {
      try {
        await _player!.stop();
        debugPrint('AudioService: ✅ Stopped successfully');
      } catch (e) {
        debugPrint('AudioService: Error stopping player: $e');
      }
    }

    _currentChannelId = null;
    _currentStreamUrl = null;
    _currentTitle = null;
    _currentArtist = null;
    _currentArtUri = null;
    _reconnectionTimer?.cancel();
    _reconnectionTimer = null;
    _clearError();

    // Notify iOS that MBC is now inactive
    await _notifyIOSMBCInactive();

    _isStoppingInternally = false; // Reset flag after stop completes
    syncState();
    notifyListeners();
  }

  /// Handle notification dismissal - called when player stops unexpectedly
  void _handleNotificationDismissed() {
    // Prevent multiple calls
    if (_isHandlingDismissal) {
      debugPrint('AudioService: Already handling dismissal, ignoring');
      return;
    }

    debugPrint('AudioService: 🚫 Handling notification dismissal');
    _isHandlingDismissal = true;

    // Reset expectations since notification was dismissed
    _expectsToBePlaying = false;
    _isStoppingInternally = false;
    _isStartingPlayback = false; // Always reset this when dismissed

    // Clear current stream info
    _currentChannelId = null;
    _currentStreamUrl = null;
    _currentTitle = null;
    _currentArtist = null;
    _currentArtUri = null;

    // Notify iOS that MBC is now inactive (fire and forget)
    _notifyIOSMBCInactive().catchError((e) {
      debugPrint('AudioService: Error notifying iOS MBC inactive: $e');
    });

    // Notify listeners
    syncState();
    notifyListeners();

    // Always call the callback - let the provider decide if it should exit
    // This ensures notification dismissal from outside always triggers exit
    if (_onNotificationDismissed != null) {
      debugPrint('AudioService: Calling notification dismissed callback');
      _onNotificationDismissed!();
    }

    _isHandlingDismissal = false;
  }

  /// Check if player was stopped externally (e.g., notification dismissed)
  /// Call this when app resumes to detect if notification was dismissed while app was in background
  bool checkIfPlayerWasDismissed() {
    // Don't check if we're actively starting playback
    if (_isStartingPlayback) {
      debugPrint('AudioService: 🔍 Skipping dismissal check - actively starting playback');
      return false;
    }

    if (_player == null) {
      // If we expect to be playing but player is null, it was likely dismissed
      if (_expectsToBePlaying && _currentChannelId != null) {
        debugPrint('AudioService: 🔍 Player was dismissed - player is null but we expect to be playing');
        _handleNotificationDismissed();
        return true;
      }
      return false;
    }

    final state = _player!.playerState;
    final isStopped = !state.playing &&
        (state.processingState == ProcessingState.idle || state.processingState == ProcessingState.completed);

    // If we expect to be playing but player is stopped and we didn't stop it internally
    if (_expectsToBePlaying && isStopped && !_isStoppingInternally) {
      debugPrint('AudioService: 🔍 Player was dismissed - stopped unexpectedly');
      _handleNotificationDismissed();
      return true;
    }

    return false;
  }

  Future<void> _cleanup() async {
    debugPrint('AudioService: 🧹 Cleaning up resources');

    // Cancel timers
    _reconnectionTimer?.cancel();
    _reconnectionTimer = null;
    _stopDismissalCheckTimer();

    // Cancel subscriptions
    await _playerStateSubscription?.cancel();
    await _playbackEventSubscription?.cancel();
    await _audioInterruptionSubscription?.cancel();
    await _sequenceStateSubscription?.cancel();

    _playerStateSubscription = null;
    _playbackEventSubscription = null;
    _audioInterruptionSubscription = null;
    _sequenceStateSubscription = null;

    // Stop and dispose player
    if (_globalPlayer != null) {
      try {
        await _globalPlayer!.stop();
        await _globalPlayer!.dispose();
      } catch (e) {
        debugPrint('AudioService: Error disposing player: $e');
      }
      _globalPlayer = null;
    }

    // Deactivate audio session
    if (_audioSession != null) {
      try {
        await _audioSession!.setActive(false);
      } catch (e) {
        debugPrint('AudioService: Error deactivating audio session: $e');
      }
    }

    debugPrint('AudioService: ✅ Cleanup completed');
  }

  void _setError(String message) {
    _hasError = true;
    _errorMessage = message;
    debugPrint('AudioService: ❌ Error set: $message');
    notifyListeners();
  }

  void _clearError() {
    _hasError = false;
    _errorMessage = null;
  }

  // MARK: - iOS Audio Coordination Methods

  /// Setup iOS audio coordination channel for navigation ducking
  Future<void> _setupIOSAudioCoordination() async {
    if (!Platform.isIOS) return;

    try {
      _audioCoordinationChannel = const MethodChannel('com.balady.audio_coordination');
      _audioCoordinationChannel!.setMethodCallHandler(_handleIOSAudioCoordinationCall);

      debugPrint('AudioService: ✅ iOS audio coordination setup completed');
    } catch (e) {
      debugPrint('AudioService: ❌ Failed to setup iOS audio coordination: $e');
    }
  }

  /// Handle method calls from iOS AudioSessionManager
  Future<void> _handleIOSAudioCoordinationCall(MethodCall call) async {
    try {
      switch (call.method) {
        case 'duckAudio':
          await _handleDuckAudio(call.arguments);
          break;
        case 'restoreAudio':
          await _handleRestoreAudio(call.arguments);
          break;
        case 'onAudioInterrupted':
          _handleAudioInterrupted();
          break;
        case 'onAudioInterruptionEnded':
          _handleAudioInterruptionEnded();
          break;
        case 'onAudioRouteChanged':
          _handleAudioRouteChanged(call.arguments);
          break;
        default:
          debugPrint('AudioService: Unknown iOS audio coordination method: ${call.method}');
      }
    } catch (e) {
      debugPrint('AudioService: Error handling iOS audio coordination call: $e');
    }
  }

  /// Duck audio for navigation voice
  Future<void> _handleDuckAudio(dynamic arguments) async {
    if (_player == null) {
      debugPrint('AudioService: 🦆 Duck request ignored - player not active');
      return;
    }

    // Requested behavior: pause the "first sound" while navigation speaks,
    // then resume after navigation finishes.
    //
    // We keep the method names (duck/restore) for compatibility with native iOS,
    // but the effect is "pause/resume" rather than only lowering volume.
    debugPrint('AudioService: 🦆 Navigation started - pausing stream audio');

    try {
      if (_isNavigationDucking) {
        // Already in navigation-duck state, ignore duplicate requests.
        return;
      }

      _wasPlayingBeforeNavigationDuck = _isPlaying;
      _isNavigationDucking = true;

      // If native forgets to call restoreAudio (it happens in real devices),
      // ensure we don't stay paused forever.
      _navigationDuckingFailsafeTimer?.cancel();
      _navigationDuckingFailsafeTimer = Timer(const Duration(seconds: 10), () {
        if (_isNavigationDucking) {
          debugPrint('AudioService: ⏱️ restoreAudio timeout - auto restoring stream audio');
          // Best-effort; ignore returned future in timer callback.
          // The restore method itself checks flags and will no-op if not needed.
          // ignore: discarded_futures
          _handleRestoreAudio(<String, dynamic>{});
        }
      });

      // Use our own pause() so state + listeners stay consistent.
      if (_isPlaying) {
        await pause();
      } else {
        syncState();
        notifyListeners();
      }

      debugPrint('AudioService: ✅ Stream audio paused for navigation');
    } catch (e) {
      debugPrint('AudioService: ❌ Failed to pause for navigation: $e');
    }
  }

  /// Restore audio after navigation voice
  Future<void> _handleRestoreAudio(dynamic arguments) async {
    if (_player == null || !_isNavigationDucking) {
      debugPrint('AudioService: 🔊 Restore request ignored - not ducking or player not active');
      return;
    }

    debugPrint('AudioService: 🔊 Navigation finished - restoring stream audio');

    try {
      _isNavigationDucking = false;
      _navigationDuckingFailsafeTimer?.cancel();
      _navigationDuckingFailsafeTimer = null;

      // Resume even if _expectsToBePlaying got flipped elsewhere.
      if (_wasPlayingBeforeNavigationDuck) {
        _expectsToBePlaying = true;
        await _player!.play();
      }
      _wasPlayingBeforeNavigationDuck = false;

      debugPrint('AudioService: ✅ Stream audio restored after navigation');
      syncState();
      notifyListeners();
    } catch (e) {
      debugPrint('AudioService: ❌ Failed to restore after navigation: $e');
    }
  }

  /// Handle audio interruption from iOS
  void _handleAudioInterrupted() {
    debugPrint('AudioService: 🛑 iOS audio interruption detected');

    if (_isPlaying) {
      _wasPlayingBeforeInterruption = true;
      _isInterrupted = true;
      pause();
    }
  }

  /// Handle audio interruption end from iOS
  void _handleAudioInterruptionEnded() {
    debugPrint('AudioService: ▶️ iOS audio interruption ended');

    if (_wasPlayingBeforeInterruption && _expectsToBePlaying) {
      _isInterrupted = false;
      resume();
    }
  }

  /// Handle audio route change from iOS
  void _handleAudioRouteChanged(dynamic arguments) {
    debugPrint('AudioService: 🔊 iOS audio route changed: $arguments');
    // Handle route changes if needed (e.g., headphones connected/disconnected)
  }

  /// Notify iOS that MBC is active
  Future<void> _notifyIOSMBCActive() async {
    if (!Platform.isIOS || _audioCoordinationChannel == null) return;

    try {
      await _audioCoordinationChannel!.invokeMethod('notifyMBCActive');
      debugPrint('AudioService: ✅ Notified iOS that MBC is active');
    } catch (e) {
      debugPrint('AudioService: ❌ Failed to notify iOS MBC active: $e');
    }
  }

  /// Notify iOS that MBC is inactive
  Future<void> _notifyIOSMBCInactive() async {
    if (!Platform.isIOS || _audioCoordinationChannel == null) return;

    try {
      await _audioCoordinationChannel!.invokeMethod('notifyMBCInactive');
      debugPrint('AudioService: ✅ Notified iOS that MBC is inactive');
    } catch (e) {
      debugPrint('AudioService: ❌ Failed to notify iOS MBC inactive: $e');
    }
  }

  @override
  void dispose() {
    debugPrint('AudioService: 🧹 Disposing AudioService');
    _cleanup();
    _isInitialized = false;
    super.dispose();
    debugPrint('AudioService: ✅ AudioService disposed');
  }
}
