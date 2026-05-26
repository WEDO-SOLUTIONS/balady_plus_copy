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
  Timer? _iosDismissalDebounceTimer;
  AudioSession? _audioSession;
  MethodChannel? _audioCoordinationChannel;
  MethodChannel? _nativeRadioChannel;

  bool _wasPlayingBeforeInterruption = false;
  bool _isInterrupted = false;
  bool _isDucked = false;
  bool _isNavigationDucking = false;
  Timer? _navigationDuckingFailsafeTimer;
  double? _preNavigationDuckVolume;

  // True while navigation voice is active — blocks dismissal detection so the
  // periodic timer doesn't mistake a voice-induced idle state for a user dismissal.
  bool _isNavigationVoiceActive = false;
  Timer? _navigationVoiceFailsafeTimer;

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
  static const Duration _iosUnexpectedStopDebounce = Duration(milliseconds: 1200);
  static const Duration _iosResumeRetryDelay = Duration(milliseconds: 350);

  Future<void> _ensureStreamPlayingAfterVoice({required String reason}) async {
    if (!Platform.isIOS) return;
    if (_player == null) return;
    if (!_expectsToBePlaying) return;
    if (_currentStreamUrl == null) return;
    if (_isStoppingInternally) return;

    // If we are intentionally paused for navigation voice, wait for restore/end.
    if (_isNavigationDucking) return;

    try {
      final st = _player!.playerState;
      final isStopped = !st.playing &&
          (st.processingState == ProcessingState.idle || st.processingState == ProcessingState.completed);

      if (!isStopped) {
        // Already playing or buffering/loading.
        return;
      }

      debugPrint('AudioService: 🔁 iOS ensure-playing ($reason) - re-preparing stream source');
      _expectsToBePlaying = true;

      // Re-activate the audio session before re-preparing: after an iOS interruption
      // the session stays deactivated, and calling play() without setActive(true) is a no-op.
      try {
        await _audioSession?.setActive(true);
        debugPrint('AudioService: ✅ Audio session reactivated ($reason)');
      } catch (e) {
        debugPrint('AudioService: ⚠️ Could not reactivate audio session ($reason): $e');
      }

      // Re-prepare the source; on iOS the player drops to idle after interruptions.
      await _playLiveStream();
    } catch (e) {
      debugPrint('AudioService: ❌ iOS ensure-playing failed ($reason): $e');
    }
  }

  void _maybeHandleUnexpectedStop(String source) {
    if (_isStoppingInternally || _isStartingPlayback || !_expectsToBePlaying) return;
    if (_isInterrupted || _isNavigationDucking || _isNavigationVoiceActive) return;

    // iOS sometimes reports the player as idle before we receive the AVAudioSession
    // interruption/secondary-audio hint. Debounce to avoid flipping state too early.
    if (Platform.isIOS) {
      _iosDismissalDebounceTimer?.cancel();
      _iosDismissalDebounceTimer = Timer(_iosUnexpectedStopDebounce, () {
        if (_player == null) {
          if (_currentChannelId != null && _expectsToBePlaying && !_isInterrupted && !_isNavigationDucking && !_isNavigationVoiceActive) {
            debugPrint('AudioService: 🚫 Notification dismissed (debounced/$source) - player is null');
            _handleNotificationDismissed();
          }
          return;
        }

        final st = _player!.playerState;
        final isStopped = !st.playing &&
            (st.processingState == ProcessingState.idle || st.processingState == ProcessingState.completed);
        if (_expectsToBePlaying && isStopped && !_isStoppingInternally && !_isStartingPlayback && !_isInterrupted && !_isNavigationDucking && !_isNavigationVoiceActive) {
          debugPrint('AudioService: 🚫 Notification dismissed (debounced/$source) - player stopped unexpectedly');
          _handleNotificationDismissed();
        } else {
          debugPrint('AudioService: ⏸️ Debounced stop resolved (source: $source)');
        }
      });
      return;
    }

    debugPrint('AudioService: 🚫 Notification dismissed ($source) - player stopped unexpectedly');
    _handleNotificationDismissed();
  }

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
    if (_isInitialized) {
      debugPrint('AudioService: Already initialized');
      return;
    }

    try {
      debugPrint('AudioService: Starting initialization');

      if (Platform.isIOS) {
        // iOS: NativeRadioPlayer.swift handles all audio.
        // Do NOT create just_audio_background or AudioPlayer — their idle state
        // would trigger the dismissal-check timer and kill the native player.
        await _setupIOSAudioCoordination();
        _isInitialized = true;
        debugPrint('AudioService: ✅ iOS initialised (native radio mode)');
        return;
      }

      // ── Android / other platforms ──────────────────────────────────────────

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

      // Setup listeners (includes dismissal-check timer — only for Android)
      await _setupPlayerListeners();

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
        // iOS: allow navigation voice prompts to coexist with radio playback.
        // - mixWithOthers: don't fully stop other audio when another session activates
        // - interruptSpokenAudioAndMixWithOthers: improves coexistence with spoken guidance
        // We still handle duck/pause via our native coordination bridge as a fallback.
        // Note: This must stay `const`. We use raw bitmask values from `audio_session`
        // (`AVAudioSessionCategoryOptions` in `audio_session/lib/src/darwin.dart`):
        // - mixWithOthers: 0x1
        // - interruptSpokenAudioAndMixWithOthers: 0x11
        // - allowBluetooth: 0x4
        // 0x1 = mixWithOthers: mix with other sessions (don't take exclusive access)
        // 0x4 = allowBluetooth
        // NOT 0x11 (interruptSpokenAudioAndMixWithOthers): that flag makes us interrupt
        // navigation voice, which fights 2GIS SDK and kills our audio session.
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions(0x1 | 0x4),
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

    _isInterrupted = true;
    _wasPlayingBeforeInterruption = _isPlaying || _isLoading;

    // Android: duck volume instead of pausing when 2GIS navigation voice speaks.
    if (Platform.isAndroid && event.type == AudioInterruptionType.duck && _player != null) {
      _player!.setVolume(0.15);
    }
  }

  void _handleInterruptionEnded(AudioInterruptionEvent event) {
    debugPrint('AudioService: ▶️ INTERRUPTION ENDED - wasPlaying: $_wasPlayingBeforeInterruption');
    _isInterrupted = false;

    if (Platform.isAndroid && event.type == AudioInterruptionType.duck && _player != null) {
      // Restore volume after navigation voice ends.
      _player!.setVolume(1.0);
      return;
    }

    if (Platform.isIOS && _wasPlayingBeforeInterruption && _expectsToBePlaying) {
      // ignore: discarded_futures
      _recoverAfterInterruption('interruptionEnded');
    }
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

          final shouldIgnoreDismissal = _isInterrupted || _isNavigationDucking || _isNavigationVoiceActive;
          if (!_isStoppingInternally && !_isStartingPlayback && !shouldIgnoreDismissal) {
            _maybeHandleUnexpectedStop('playerStateStream');
          } else {
            debugPrint('AudioService: ⏸️ Ignoring dismissal - '
                'isStoppingInternally: $_isStoppingInternally, '
                'isStartingPlayback: $_isStartingPlayback, '
                'isInterrupted: $_isInterrupted, '
                'isNavigationDucking: $_isNavigationDucking');
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

        final shouldIgnoreDismissal = _isInterrupted || _isNavigationDucking;
        if (_expectsToBePlaying && isStopped && !_isStoppingInternally && !_isStartingPlayback && !shouldIgnoreDismissal) {
          _maybeHandleUnexpectedStop('playbackEventStream');
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
      if (!_expectsToBePlaying || _isStoppingInternally || _isStartingPlayback || _isInterrupted || _isNavigationDucking || _isNavigationVoiceActive) {
        return; // Don't check if we don't expect to be playing or are stopping/starting
      }

      if (_player == null) {
        if (_currentChannelId != null) {
          debugPrint('AudioService: 🔍 Periodic check - Player is null but we expect to be playing');
          _maybeHandleUnexpectedStop('periodicTimer(playerNull)');
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
        _maybeHandleUnexpectedStop('periodicTimer');
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

    if (!_isInitialized || (!Platform.isIOS && _player == null)) {
      debugPrint('AudioService: Not initialized, initializing first');
      await init();
    }

    if (!Platform.isIOS && _player == null) {
      debugPrint('AudioService: ❌ Player is null after initialization');
      _setError('Failed to initialize audio player');
      return;
    }

    try {
      _isHandlingDismissal = false;
      _currentStreamUrl = url;
      _currentChannelId = channelId;
      _currentTitle = title ?? 'Live Radio';
      _currentArtist = programName ?? 'Live Stream';
      _currentArtUri = artUri;
      _expectsToBePlaying = true;
      _clearError();

      if (Platform.isIOS) {
        // On iOS: delegate all audio to NativeRadioPlayer.swift which handles
        // session conflicts with the 2GIS navigation SDK internally.
        _isLoading = true;
        notifyListeners();
        await _nativePlay();
        await _notifyIOSMBCActive();
      } else {
        _startDismissalCheckTimer();
        debugPrint('AudioService: Setting audio source...');
        await _playLiveStream(playlist: playlist, initialIndex: initialIndex);
        await _notifyIOSMBCActive();
      }

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

    if (Platform.isIOS) {
      try {
        await _nativePause();
        _isPlaying = false;
        _isLoading = false;
        notifyListeners();
      } catch (e) {
        debugPrint('AudioService: ❌ Error pausing (native): $e');
      }
      return;
    }

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

    if (!_expectsToBePlaying) {
      debugPrint('AudioService: Not expecting to be playing, ignoring resume');
      return;
    }

    if (Platform.isIOS) {
      try {
        await _nativeRadioChannel?.invokeMethod('resume');
        _isLoading = true;
        notifyListeners();
      } catch (e) {
        debugPrint('AudioService: ❌ Error resuming (native): $e');
      }
      return;
    }

    if (_player == null) {
      debugPrint('AudioService: Player is null, cannot resume');
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
    // On iOS the state is driven by NativeRadioPlayer callbacks — _globalPlayer
    // is always null. Calling syncState() here would reset _isPlaying to false
    // and break the provider's play/pause logic.
    if (Platform.isIOS) return;

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

    // On iOS the native player reports transient "loading" states during normal
    // operation — do NOT block the toggle on them.
    if (!Platform.isIOS && _isLoading) {
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

    _expectsToBePlaying = false;
    _isStartingPlayback = false;
    _isInterrupted = false;
    _isDucked = false;
    _currentChannelId = null;
    _currentStreamUrl = null;
    _currentTitle = null;
    _currentArtist = null;
    _currentArtUri = null;
    _reconnectionTimer?.cancel();
    _reconnectionTimer = null;
    _clearError();

    if (Platform.isIOS) {
      await _nativeStop();
      await _notifyIOSMBCInactive();
      _isPlaying = false;
      _isLoading = false;
      notifyListeners();
      return;
    }

    _stopDismissalCheckTimer();
    _isStoppingInternally = true;

    if (_player != null) {
      try {
        await _player!.stop();
        debugPrint('AudioService: ✅ Stopped successfully');
      } catch (e) {
        debugPrint('AudioService: Error stopping player: $e');
      }
    }

    await _notifyIOSMBCInactive();
    _isStoppingInternally = false;
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

    // iOS can temporarily pause/stop our audio session while navigation voice speaks
    // (or while we are in navigation-duck mode). That should NOT be treated as a dismissal.
    if (_isInterrupted || _isNavigationDucking) {
      debugPrint('AudioService: 🔍 Skipping dismissal check - interrupted/ducking (isInterrupted: $_isInterrupted, isNavigationDucking: $_isNavigationDucking)');
      return false;
    }

    if (_player == null) {
      // If we expect to be playing but player is null, it was likely dismissed
      if (_expectsToBePlaying && _currentChannelId != null) {
        debugPrint('AudioService: 🔍 Player was dismissed - player is null but we expect to be playing');
        _maybeHandleUnexpectedStop('checkIfPlayerWasDismissed(playerNull)');
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
      _maybeHandleUnexpectedStop('checkIfPlayerWasDismissed');
      return true;
    }

    return false;
  }

  Future<void> _cleanup() async {
    debugPrint('AudioService: 🧹 Cleaning up resources');

    // Cancel timers
    _reconnectionTimer?.cancel();
    _reconnectionTimer = null;
    _navigationVoiceFailsafeTimer?.cancel();
    _navigationVoiceFailsafeTimer = null;
    _isNavigationVoiceActive = false;
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

      // Native radio player channel — receives state updates from NativeRadioPlayer.swift.
      _nativeRadioChannel = const MethodChannel('com.balady.native_radio');
      _nativeRadioChannel!.setMethodCallHandler(_handleNativeRadioCall);

      debugPrint('AudioService: ✅ iOS audio coordination + native radio setup completed');
    } catch (e) {
      debugPrint('AudioService: ❌ Failed to setup iOS audio coordination: $e');
    }
  }

  /// Handle method calls from iOS AudioSessionManager
  Future<void> _handleIOSAudioCoordinationCall(MethodCall call) async {
    try {
      switch (call.method) {
        case 'navigationVoiceStarted':
          _handleNavigationVoiceStarted();
          break;
        case 'navigationVoiceEnded':
          await _handleNavigationVoiceEnded();
          break;
        // Legacy — kept so older native builds don't crash.
        case 'duckAudio':
        case 'onAudioInterrupted':
          _handleNavigationVoiceStarted();
          break;
        case 'restoreAudio':
        case 'onAudioInterruptionEnded':
          await _handleNavigationVoiceEnded();
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

  // MARK: - Native radio player (iOS only) -----------------------------------

  /// Receives state updates from NativeRadioPlayer.swift via method channel.
  Future<void> _handleNativeRadioCall(MethodCall call) async {
    if (call.method != 'onStateChanged') return;
    final state = ((call.arguments as Map?)?['state'] as String?) ?? 'stopped';
    debugPrint('AudioService: 📡 native radio state → $state');
    switch (state) {
      case 'playing':
        _isPlaying = true;
        _isLoading = false;
        _hasError = false;
        _isStartingPlayback = false;
        notifyListeners();
      case 'loading':
        _isPlaying = false;
        _isLoading = true;
        _hasError = false;
        notifyListeners();
      case 'paused':
        _isPlaying = false;
        _isLoading = false;
        notifyListeners();
      case 'error':
        _isPlaying = false;
        _isLoading = false;
        _setError('Native radio player error');
      case 'stopped':
        // 'stopped' only means the native player was explicitly stopped.
        // Do NOT treat it as a user dismissal — the native player handles recovery.
        _isPlaying = false;
        _isLoading = false;
        notifyListeners();
    }
  }

  /// Send play command to the native iOS player.
  Future<void> _nativePlay() async {
    if (_nativeRadioChannel == null || _currentStreamUrl == null) return;
    try {
      await _nativeRadioChannel!.invokeMethod('play', {
        'url': _currentStreamUrl,
        'title': _currentTitle ?? 'Live Radio',
        'artist': _currentArtist ?? '',
      });
      debugPrint('AudioService: ✅ native play sent');
    } catch (e) {
      debugPrint('AudioService: ❌ native play failed: $e');
    }
  }

  Future<void> _nativePause() async {
    try {
      await _nativeRadioChannel?.invokeMethod('pause');
    } catch (e) {
      debugPrint('AudioService: ❌ native pause failed: $e');
    }
  }

  Future<void> _nativeStop() async {
    try {
      await _nativeRadioChannel?.invokeMethod('stop');
    } catch (e) {
      debugPrint('AudioService: ❌ native stop failed: $e');
    }
  }

  // --------------------------------------------------------------------------

  /// Navigation voice started — block dismissal detection so the periodic timer
  /// doesn't mistake the iOS-induced idle state for a user notification dismissal.
  void _handleNavigationVoiceStarted() {
    if (_isNavigationVoiceActive) return;
    debugPrint('AudioService: 🔔 Navigation voice started — blocking dismissal detection');
    _isNavigationVoiceActive = true;

    // Failsafe: if navigationVoiceEnded never arrives (e.g. SDK bug), unblock after 20s.
    _navigationVoiceFailsafeTimer?.cancel();
    _navigationVoiceFailsafeTimer = Timer(const Duration(seconds: 20), () {
      if (_isNavigationVoiceActive) {
        debugPrint('AudioService: ⏱️ Navigation voice failsafe — forcing recovery');
        // ignore: discarded_futures
        _handleNavigationVoiceEnded();
      }
    });
  }

  /// Navigation voice ended — re-activate audio session and restart the stream.
  Future<void> _handleNavigationVoiceEnded() async {
    if (!_isNavigationVoiceActive) return;
    debugPrint('AudioService: 🔔 Navigation voice ended — recovering radio stream');

    _navigationVoiceFailsafeTimer?.cancel();
    _navigationVoiceFailsafeTimer = null;

    if (!_expectsToBePlaying || _currentStreamUrl == null || _isStoppingInternally) {
      _isNavigationVoiceActive = false;
      return;
    }

    // Clear voice flag before recovery so guards inside _recoverAfterInterruption pass.
    _isNavigationVoiceActive = false;
    await _recoverAfterInterruption('navigationVoiceEnded');
  }

  /// Unified recovery: re-activate audio session and restart the stream.
  /// Called from both the interruption-ended path and the navigation-voice-ended path.
  Future<void> _recoverAfterInterruption(String reason) async {
    if (_isStartingPlayback) {
      debugPrint('AudioService: ⏭️ Recovery skipped — already starting ($reason)');
      return;
    }
    if (!_expectsToBePlaying || _currentStreamUrl == null || _isStoppingInternally) return;

    debugPrint('AudioService: 🔁 Recovering after interruption ($reason)');
    _isStartingPlayback = true;

    try {
      // Re-activate the session; iOS deactivates it during interruptions.
      await _audioSession?.setActive(true);
      debugPrint('AudioService: ✅ Audio session reactivated ($reason)');

      // Give iOS a moment to fully hand back the audio route.
      await Future<void>.delayed(const Duration(milliseconds: 300));

      // Re-prepare and play the live stream from scratch.
      await _playLiveStream();
      debugPrint('AudioService: ✅ Stream restarted ($reason)');
    } catch (e) {
      debugPrint('AudioService: ❌ Recovery failed ($reason): $e');
      _isStartingPlayback = false;
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
