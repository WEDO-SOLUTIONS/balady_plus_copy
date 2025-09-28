import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class AudioService extends ChangeNotifier {
  static final AudioService _instance = AudioService._internal();
  static bool _globalInitialized = false;

  factory AudioService() => _instance;

  AudioService._internal();

  // Players
  AudioPlayer? _player;

  // Player stream subscriptions
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  // Caching
  File? _cacheFile;
  IOSink? _cacheWriter;
  late http.StreamedResponse? _streamResponse;
  StreamSubscription<List<int>>? _streamSubscription;

  // Stream URLs
  String? _currentStreamUrl;
  String? _currentChannelId;

  // State
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isLoading =
      false; // Start with false, let player state listener manage it
  bool _hasError = false;
  String? _errorMessage;
  bool _manuallyPaused = false; // Track if user manually paused

  // Time tracking
  DateTime? _cacheStartTime;
  Duration _userPosition = Duration.zero; // Where user is listening
  Duration _totalCachedDuration = Duration.zero; // Total cached since start
  Timer? _cacheTimer;

  // Playback mode
  bool _isPlayingFromCache = false;

  // Native platform
  static const MethodChannel _mediaSessionChannel =
      MethodChannel('balady_media_session');

  // Constants
  static const Duration _maxCacheDuration = Duration(hours: 1);
  static const Duration _liveThreshold = Duration(seconds: 2);

  // Getters
  bool get isInitialized => _isInitialized;

  bool get isPlaying {
    // If we have a selected channel and cached time, and not manually paused, we're playing
    final result = _currentChannelId != null &&
        _totalCachedDuration.inSeconds > 0 &&
        !_manuallyPaused;

    return result;
  }

  bool get isLoading => _totalCachedDuration.inSeconds == 0;

  bool get hasError => _hasError;

  String? get errorMessage => _errorMessage;

  String? get currentChannelId => _currentChannelId;

  Duration get currentPosition => _userPosition;

  Duration get totalCachedTime => _totalCachedDuration;

  bool get isLive {
    final diff = (_totalCachedDuration - _userPosition).abs();
    return diff <= _liveThreshold && _isPlaying && !_isPlayingFromCache;
  }

  Duration get timeBehindLive {
    final timeBehind = _totalCachedDuration - _userPosition;
    if (_isPlayingFromCache && timeBehind.inSeconds > 0) {
      debugPrint(
          'AudioService: timeBehindLive - cached: ${_formatDuration(_totalCachedDuration)}, user: ${_formatDuration(_userPosition)}, behind: ${_formatDuration(timeBehind)}');
    }
    return timeBehind;
  }

  double get progress {
    if (_totalCachedDuration.inMilliseconds <= 0) {
      return 0.0;
    }
    return (_userPosition.inMilliseconds / _totalCachedDuration.inMilliseconds)
        .clamp(0.0, 1.0);
  }

  String get formattedCurrentPosition => _formatDuration(_userPosition);

  String get formattedLivePosition => _formatDuration(_totalCachedDuration);

  String get formattedTimeBehind => _formatDuration(timeBehindLive.abs());

  // Global initialization - should be called once at app startup
  static Future<void> initializeGlobally() async {
    if (_globalInitialized) {
      debugPrint('AudioService: Already globally initialized, skipping');
      return;
    }

    // Mark as initialized immediately to prevent multiple calls
    _globalInitialized = true;

    debugPrint(
        'AudioService: Global initialization completed (using custom MediaSession)');
    // We'll use our custom MediaSessionHandler instead of JustAudioBackground
    // to avoid conflicts with the custom FlutterProvider setup
  }

  // Initialization
  Future<void> init() async {
    if (_isInitialized) {
      debugPrint('AudioService: Already initialized, skipping');
      return;
    }

    try {
      debugPrint('AudioService: Starting instance initialization');

      // Check if global initialization was successful
      if (!_globalInitialized) {
        debugPrint(
            'AudioService: Global initialization was not completed successfully');
        debugPrint('AudioService: Continuing without background audio support');
      }

      _player = AudioPlayer();

      await _setupPlayerListeners();
      await _initPlatformMediaSession();

      _isInitialized = true;
      debugPrint('AudioService: Instance initialized successfully');
    } catch (e) {
      debugPrint('AudioService: Init error: $e');
      _setError('Failed to initialize: $e');
    }
  }

  // Reinitialize after disposal
  Future<void> reinitialize() async {
    debugPrint('AudioService: Reinitializing after disposal');

    // Reset the initialization flag to allow re-initialization
    _isInitialized = false;

    // Clear any disposed state
    _player = null;
    _resetState();

    // Re-initialize
    await init();

    debugPrint('AudioService: Reinitialization completed');
  }

  Future<void> _setupPlayerListeners() async {
    if (_player == null) {
      return;
    }

    // Cancel existing subscriptions first
    await _cancelPlayerSubscriptions();

    // Listen to position updates
    _positionSubscription = _player!.positionStream.listen((position) {
      if (_isPlayingFromCache && !_manuallyPaused) {
        // When playing from cache, update user position based on player position
        _userPosition = position;
        debugPrint(
            'AudioService: Position stream - updating from cache position: ${_formatDuration(position)}');
        notifyListeners();
      }
      // When playing live, user position is updated by the timer
    });

    // Listen to player state changes
    _playerStateSubscription = _player!.playerStateStream.listen((state) {
      final wasPlaying = _isPlaying;
      final wasLoading = _isLoading;

      _isPlaying = state.playing;

      // Manage loading state based on processing state
      if (state.processingState == ProcessingState.loading ||
          state.processingState == ProcessingState.buffering) {
        _isLoading = true;
        debugPrint(
            'AudioService: Player state listener - Setting _isLoading = true');
      } else if (state.processingState == ProcessingState.ready ||
          state.processingState == ProcessingState.completed) {
        _isLoading = false;
        debugPrint(
            'AudioService: Player state listener - Setting _isLoading = false');
      }

      // Debug logging to track state changes
      debugPrint(
          'AudioService: Player state - playing: ${state.playing}, processing: ${state.processingState}, isLoading: $_isLoading');

      // Notify listeners if either playing or loading state changed
      if (wasPlaying != _isPlaying || wasLoading != _isLoading) {
        notifyListeners();
      }
    });
  }

  Future<void> _cancelPlayerSubscriptions() async {
    await _positionSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    _positionSubscription = null;
    _playerStateSubscription = null;
  }

  // Main playback method
  Future<void> playStream({
    required String url,
    required String channelId,
    String? title,
    String? artist,
    String? artUri,
  }) async {
    try {
      if (!_isInitialized) {
        await init();
      }

      _clearError();

      // Check if switching channels
      final isNewChannel = _currentChannelId != channelId;

      if (isNewChannel) {
        await _stopCurrentStream();
        _currentChannelId = channelId;
        _currentStreamUrl = url;

        // Reset time tracking
        _userPosition = Duration.zero;
        _totalCachedDuration = Duration.zero;
        _isPlayingFromCache = false;
        _manuallyPaused = false; // Reset pause state when starting new stream

        // Start caching
        await _startCaching(url);
        _startCacheTimer();

        debugPrint('AudioService: Starting new channel: $channelId');
      } else {
        // Make sure cache timer is running even for same channel
        if (_cacheTimer == null || !_cacheTimer!.isActive) {
          _startCacheTimer();
        }
      }

      // Always play live when starting a new stream
      await _playLiveStream(url, title ?? 'Live Radio', artist ?? 'Unknown');
    } catch (e) {
      debugPrint('AudioService: Play error: $e');
      _setError('Failed to play: $e');
    }
  }

  // Live stream playback
  Future<void> _playLiveStream(String url, String title, String artist) async {
    if (_player == null) {
      return;
    }

    try {
      _isPlayingFromCache = false;

      final audioSource = AudioSource.uri(Uri.parse(url));

      await _player!.setAudioSource(audioSource);

      // Update platform media session with metadata FIRST
      await _updatePlatformMediaMetadata(title, artist);

      await _player!.play();

      // Then update playback state after starting playback
      await _updatePlatformPlaybackState(true);

      debugPrint('AudioService: Playing live stream');
    } catch (e) {
      debugPrint('AudioService: Live stream error: $e');
      rethrow;
    }
  }

  // Cache playback
  Future<void> _playFromCache(Duration position) async {
    if (_player == null || _cacheFile == null || !await _cacheFile!.exists()) {
      debugPrint('AudioService: No cache available');
      return;
    }

    try {
      _isPlayingFromCache = true;

      final audioSource = AudioSource.uri(Uri.file(_cacheFile!.path));

      await _player!.setAudioSource(audioSource);
      await _player!.seek(position);

      // Update platform media session with metadata FIRST
      await _updatePlatformMediaMetadata('Radio (Cached)', 'Buffered');

      await _player!.play();

      // Then update playback state after starting playback
      await _updatePlatformPlaybackState(true);

      debugPrint(
          'AudioService: Playing from cache at ${_formatDuration(position)}');
    } catch (e) {
      debugPrint('AudioService: Cache playback error: $e');
    }
  }

  // Caching implementation
  Future<void> _startCaching(String url) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _cacheFile = File(
          '${tempDir.path}/radio_cache_${_currentChannelId}_$timestamp.mp3');

      if (await _cacheFile!.exists()) {
        await _cacheFile!.delete();
      }

      await _cacheFile!.create();
      _cacheWriter = _cacheFile!.openWrite();

      // Start downloading stream
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(url));
      _streamResponse = await client.send(request);

      _streamSubscription = _streamResponse!.stream.listen(
        (chunk) {
          _cacheWriter?.add(chunk);
        },
        onError: (error) => debugPrint('Cache error: $error'),
        onDone: () => debugPrint('Cache stream ended'),
      );

      _cacheStartTime = DateTime.now();
      debugPrint('AudioService: Started caching to ${_cacheFile!.path}');
    } catch (e) {
      debugPrint('AudioService: Cache setup error: $e');
    }
  }

  // Timer for tracking cache duration
  void _startCacheTimer() {
    _cacheTimer?.cancel();

    _cacheTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_cacheStartTime != null) {
        final now = DateTime.now();
        _totalCachedDuration = now.difference(_cacheStartTime!);

        // Enforce max cache duration (FIFO)
        if (_totalCachedDuration > _maxCacheDuration) {
          final excess = _totalCachedDuration - _maxCacheDuration;
          _cacheStartTime = _cacheStartTime!.add(excess);
          _totalCachedDuration = _maxCacheDuration;

          // Adjust user position if needed
          if (_userPosition > _totalCachedDuration) {
            _userPosition = _totalCachedDuration;
          }
        }

        // Always update user position if not manually paused
        // For live: sync to total cached time
        // For cache: advance user position (since position stream might not work reliably)
        if (!_manuallyPaused) {
          if (!_isPlayingFromCache) {
            // Playing live - sync to total cached time
            _userPosition = _totalCachedDuration;
          } else {
            // Playing from cache - advance user position slightly faster to catch up to live
            // Advance by timer interval + small catch-up amount
            const timerInterval = Duration(milliseconds: 100);
            const catchUpBonus =
                Duration(milliseconds: 10); // 10% faster to catch up
            final oldPosition = _userPosition;
            _userPosition = _userPosition + timerInterval + catchUpBonus;
            // Don't go beyond total cached time
            if (_userPosition > _totalCachedDuration) {
              _userPosition = _totalCachedDuration;
            }
            debugPrint(
                'AudioService: Cache playback - advanced from ${_formatDuration(oldPosition)} to ${_formatDuration(_userPosition)}, behind: ${_formatDuration(_totalCachedDuration - _userPosition)}');
          }
        }

        // Debug: Log cache timer updates every 10 seconds
        if (_totalCachedDuration.inSeconds % 10 == 0 &&
            _totalCachedDuration.inMilliseconds % 1000 < 100) {
          debugPrint(
              'AudioService: Cache timer - isPlaying: $_isPlaying, userPos: ${_formatDuration(_userPosition)}, cached: ${_formatDuration(_totalCachedDuration)}');
        }

        notifyListeners();
      }
    });
  }

  // Playback controls
  Future<void> pause() async {
    try {
      debugPrint(
          'AudioService: pause() called - setting _manuallyPaused = true');
      _manuallyPaused = true;
      await _player?.pause();

      // Update platform media session playback state
      await _updatePlatformPlaybackState(false);

      debugPrint(
          'AudioService: Paused at ${_formatDuration(_userPosition)}, _manuallyPaused = $_manuallyPaused');
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

      debugPrint(
          'AudioService: resume() called - setting _manuallyPaused = false');
      _manuallyPaused = false;

      // Check if user is still close to live
      final behindTime = _totalCachedDuration - _userPosition;
      final shouldPlayLive = behindTime <= _liveThreshold;

      debugPrint(
          'AudioService: Resume - Behind: ${behindTime.inSeconds}s, Play live: $shouldPlayLive');

      if (shouldPlayLive) {
        // Play live and sync position
        _userPosition = _totalCachedDuration;
        await _playLiveStream(_currentStreamUrl!, 'Live Radio', 'Live');
      } else {
        // Play from cached position
        await _playFromCache(_userPosition);
      }

      // Update platform media session playback state
      await _updatePlatformPlaybackState(true);

      notifyListeners();
    } catch (e) {
      debugPrint('AudioService: Resume error: $e');
    }
  }

  Future<void> togglePlayPause() async {
    debugPrint(
        'AudioService: togglePlayPause called - current isPlaying: $isPlaying (old _isPlaying: $_isPlaying)');
    if (isPlaying) {
      debugPrint('AudioService: Calling pause()');
      await pause();
    } else {
      debugPrint('AudioService: Calling resume()');
      await resume();
    }
    debugPrint(
        'AudioService: togglePlayPause completed - new isPlaying: $isPlaying');
  }

  // Seeking
  Future<void> seekToProgress(double progress) async {
    if (_totalCachedDuration.inMilliseconds <= 0) {
      return;
    }

    final targetPosition = Duration(
      milliseconds: (_totalCachedDuration.inMilliseconds * progress).round(),
    );

    await seekToPosition(targetPosition);
  }

  Future<void> seekToPosition(Duration position) async {
    try {
      // Clamp position to valid range
      final clampedPosition = Duration(
        milliseconds: position.inMilliseconds.clamp(
          0,
          _totalCachedDuration.inMilliseconds,
        ),
      );

      _userPosition = clampedPosition;

      // Immediately notify listeners of position change
      notifyListeners();

      // Check if seeking to live
      final behindTime = _totalCachedDuration - clampedPosition;
      final isSeekingToLive = behindTime <= _liveThreshold;

      debugPrint(
          'AudioService: Seeking to ${_formatDuration(clampedPosition)}, Live: $isSeekingToLive, Behind: ${behindTime.inSeconds}s');

      if (isSeekingToLive) {
        await goLive();
      } else {
        await _playFromCache(clampedPosition);
      }

      // Notify listeners again after playback change
      notifyListeners();
    } catch (e) {
      debugPrint('AudioService: Seek error: $e');
    }
  }

  Future<void> goLive() async {
    try {
      if (_currentStreamUrl == null) {
        return;
      }

      debugPrint('AudioService: Going live');

      _userPosition = _totalCachedDuration;
      _isPlayingFromCache = false;

      await _playLiveStream(_currentStreamUrl!, 'Live Radio', 'Live');

      notifyListeners();
    } catch (e) {
      debugPrint('AudioService: Go live error: $e');
    }
  }

  Future<void> seekForward(
      [Duration duration = const Duration(seconds: 30)]) async {
    final newPosition = _userPosition + duration;
    if (newPosition >= _totalCachedDuration) {
      await goLive();
    } else {
      await seekToPosition(newPosition);
    }
  }

  Future<void> seekBackward(
      [Duration duration = const Duration(seconds: 30)]) async {
    final newPosition = _userPosition - duration;
    await seekToPosition(newPosition.isNegative ? Duration.zero : newPosition);
  }

  // Stop and cleanup
  Future<void> _stopCurrentStream() async {
    _cacheTimer?.cancel();
    await _streamSubscription?.cancel();
    await _cancelPlayerSubscriptions();

    await _cacheWriter?.close();
    _cacheWriter = null;

    if (_cacheFile != null && await _cacheFile!.exists()) {
      await _cacheFile!.delete();
    }
    _cacheFile = null;

    await _player?.stop();

    _userPosition = Duration.zero;
    _totalCachedDuration = Duration.zero;
    _cacheStartTime = null;
    _isPlayingFromCache = false;
  }

  Future<void> stop() async {
    try {
      await _stopCurrentStream();
      await _player?.dispose();
      _player = null;

      _resetState();
      debugPrint('AudioService: Stopped');
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

  // Platform integration
  Future<void> _initPlatformMediaSession() async {
    if (Platform.isAndroid) {
      try {
        // Initialize custom media session for better control
        await _mediaSessionChannel.invokeMethod('initMediaSession');
        _mediaSessionChannel.setMethodCallHandler((call) async {
          switch (call.method) {
            case 'onPlay':
              await resume();
              break;
            case 'onPause':
              await pause();
              break;
            case 'onStop':
              await stop();
              break;
          }
        });
        debugPrint(
            'AudioService: Custom MediaSession initialized successfully');
      } catch (e) {
        debugPrint('AudioService: MediaSession setup failed: $e');
        // Continue without custom media session if it fails
      }
    }
  }

  Future<void> _updatePlatformMediaMetadata(String title, String artist) async {
    if (Platform.isAndroid) {
      try {
        debugPrint(
            'AudioService: Calling updateMediaMetadata - $title by $artist');
        await _mediaSessionChannel.invokeMethod('updateMediaMetadata', {
          'title': title,
          'artist': artist,
        });
        debugPrint(
            'AudioService: Successfully updated media metadata - $title by $artist');
      } catch (e) {
        debugPrint('AudioService: MediaSession metadata update failed: $e');
      }
    }
  }

  Future<void> _updatePlatformPlaybackState(bool playing) async {
    if (Platform.isAndroid) {
      try {
        debugPrint(
            'AudioService: Calling setPlaybackState - playing: $playing');
        await _mediaSessionChannel.invokeMethod('setPlaybackState', {
          'isPlaying': playing,
        });
        debugPrint(
            'AudioService: Successfully updated playback state - playing: $playing');
      } catch (e) {
        debugPrint(
            'AudioService: MediaSession playback state update failed: $e');
      }
    }
  }

  // Utilities
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _cacheTimer?.cancel();
    _streamSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _cacheWriter?.close();
    _player?.dispose();
    super.dispose();
  }
}
