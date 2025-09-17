import 'dart:async';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/foundation.dart';

class FijkAudioService extends ChangeNotifier {
  FijkPlayer? _player;
  Timer? _progressTimer;
  Timer? _bufferCleanupTimer;

  // Cache management
  DateTime? _channelStartTime;
  DateTime? _lastPauseTime;
  final Duration _maxCacheHours = const Duration(hours: 1);

  // Stream state
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  Duration _currentPosition = Duration.zero; // Where user is listening
  Duration _livePosition = Duration.zero;    // Current live position
  bool _isLive = true;
  String? _currentChannelId;

  // Getters
  FijkPlayer? get player => _player;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  Duration get currentPosition => _currentPosition;
  Duration get bufferedDuration => _livePosition; // Live position is our buffer end
  Duration get maxCacheDuration => _maxCacheHours;
  bool get isLive => _isLive;
  DateTime? get channelStartTime => _channelStartTime;

  // Progress as percentage (0.0 to 1.0)
  double get progress {
    if (_livePosition.inMilliseconds <= 0) {
      return 1.0;
    }
    final progress = (_currentPosition.inMilliseconds / _livePosition.inMilliseconds).clamp(0.0, 1.0);
    debugPrint('FijkAudioService: Progress - current: ${_currentPosition.inSeconds}s, live: ${_livePosition.inSeconds}s, progress: ${(progress * 100).toInt()}%');
    return progress;
  }

  Future<void> init() async {
    try {
      _player = FijkPlayer();
      _setupPlayerListeners();
      await _player!.setOption(FijkOption.hostCategory, 'cache-file-path', '/cache/audio/');
      await _player!.setOption(FijkOption.hostCategory, 'cache-max-entries', 1);

      // Enable live streaming optimizations
      await _player!.setOption(FijkOption.playerCategory, 'enable-accurate-seek', 1);
      await _player!.setOption(FijkOption.playerCategory, 'max-buffer-size', 1024 * 1024 * 60); // 60MB buffer
      await _player!.setOption(FijkOption.codecCategory, 'skip_frame', 0);

      debugPrint('FijkAudioService: Initialized successfully');
    } catch (e) {
      debugPrint('FijkAudioService: Initialization error: $e');
      _setError('Failed to initialize player: $e');
    }
  }

  void _setupPlayerListeners() {
    _player?.addListener(() {
      final state = _player?.state;
      final previousIsPlaying = _isPlaying;

      switch (state) {
        case FijkState.prepared:
          _isLoading = false;
          _hasError = false;
          _errorMessage = null;
          break;

        case FijkState.started:
          _isPlaying = true;
          _isLoading = false;
          _hasError = false;
          _errorMessage = null;
          break;

        case FijkState.paused:
          _isPlaying = false;
          _isLoading = false;
          break;

        case FijkState.stopped:
        case FijkState.completed:
          _isPlaying = false;
          _isLoading = false;
          break;

        case FijkState.error:
          _isPlaying = false;
          _isLoading = false;
          _setError('Playback error occurred');
          break;

        default:
          break;
      }

      if (previousIsPlaying != _isPlaying) {
        notifyListeners();
      }
    });

    // Start progress tracking
    _startProgressTracking();
    _startBufferCleanup();
  }

  Future<void> playStream(String url, {
    required String channelId,
    String? title,
    String? artist,
    String? artUri,
  }) async {
    try {
      debugPrint('FijkAudioService: Starting stream for channel: $channelId');

      // Reset state for new channel
      if (_currentChannelId != channelId) {
        _channelStartTime = DateTime.now();
        _currentPosition = Duration.zero;
        _livePosition = Duration.zero;
        _lastPauseTime = null;
        _isLive = true;
        _currentChannelId = channelId;
        debugPrint('FijkAudioService: New channel started, cache reset');
      }

      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
      notifyListeners();

      if (_player != null) {
        await _player!.reset();
        await _player!.setDataSource(url, autoPlay: true);

        // Set media metadata for notification
        await _player!.setLoop(0); // No loop for live streams

        debugPrint('FijkAudioService: Stream started successfully');
      }
    } catch (e) {
      debugPrint('FijkAudioService: Play stream error: $e');
      _setError('Failed to play stream: $e');
    }
  }

  Future<void> pause() async {
    try {
      if (_player != null && _isPlaying) {
        _lastPauseTime = DateTime.now();
        await _player!.pause();
        _isLive = false; // No longer live when paused
        debugPrint('FijkAudioService: Stream paused at position: ${_currentPosition.inSeconds}s, live at: ${_livePosition.inSeconds}s');
      }
    } catch (e) {
      debugPrint('FijkAudioService: Pause error: $e');
      _setError('Failed to pause: $e');
    }
  }

  Future<void> resume() async {
    try {
      if (_player != null && !_isPlaying) {
        if (_lastPauseTime != null) {
          _lastPauseTime = null;
        }
        await _player!.start();
        // Check if we're still close to live after resuming
        final timeBehind = _livePosition - _currentPosition;
        _isLive = timeBehind.inSeconds < 5; // Consider live if within 5 seconds
        debugPrint('FijkAudioService: Stream resumed from position: ${_currentPosition.inSeconds}s, behind by: ${timeBehind.inSeconds}s');
      }
    } catch (e) {
      debugPrint('FijkAudioService: Resume error: $e');
      _setError('Failed to resume: $e');
    }
  }

  Future<void> seekToProgress(double progress) async {
    try {
      if (_player == null || _livePosition.inMilliseconds <= 0) {
        return;
      }

      final targetPosition = Duration(
        milliseconds: (_livePosition.inMilliseconds * progress).round(),
      );

      debugPrint('FijkAudioService: Seeking to ${targetPosition.inSeconds}s (${(progress * 100).toInt()}%) of live position ${_livePosition.inSeconds}s');

      // For live streams, seeking is limited - we simulate by updating our position
      _currentPosition = targetPosition;
      _isLive = progress >= 0.95; // Consider live if within 5% of end

      // In a real implementation, you would restart the stream from a specific point
      // For now, we just update the position tracking

      notifyListeners();
    } catch (e) {
      debugPrint('FijkAudioService: Seek error: $e');
      _setError('Failed to seek: $e');
    }
  }

  Future<void> goLive() async {
    try {
      if (_player == null) {
        return;
      }

      // Reset pause tracking and go live
      _lastPauseTime = null;
      _currentPosition = _livePosition;
      _isLive = true;

      // Restart the stream to ensure we're truly live
      if (_currentChannelId != null && _player!.state == FijkState.started) {
        // For live streams, we can't actually seek, so we restart
        final currentUrl = _player!.dataSource!;
        await _player!.reset();
        await _player!.setDataSource(currentUrl, autoPlay: true);
      }

      debugPrint('FijkAudioService: Jumped to live position: ${_livePosition.inSeconds}s');
      notifyListeners();
    } catch (e) {
      debugPrint('FijkAudioService: Go live error: $e');
      _setError('Failed to go live: $e');
    }
  }

  Future<void> seekForward([Duration duration = const Duration(seconds: 30)]) async {
    final newPosition = _currentPosition + duration;

    if (newPosition >= _livePosition) {
      await goLive();
    } else {
      final progress = newPosition.inMilliseconds / _livePosition.inMilliseconds;
      await seekToProgress(progress.clamp(0.0, 1.0));
    }
  }

  Future<void> seekBackward([Duration duration = const Duration(seconds: 30)]) async {
    final newPosition = _currentPosition - duration;
    if (newPosition.inMilliseconds <= 0) {
      await seekToProgress(0.0);
    } else {
      final progress = newPosition.inMilliseconds / _livePosition.inMilliseconds;
      await seekToProgress(progress.clamp(0.0, 1.0));
    }
  }

  void _startProgressTracking() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (_player != null && _channelStartTime != null) {
        try {
          final now = DateTime.now();
          final totalElapsed = now.difference(_channelStartTime!);

          // Live position always advances (total time since channel started)
          _livePosition = totalElapsed;

          if (_isPlaying && _isLive) {
            // When playing and live, current position follows live position
            _currentPosition = _livePosition;
          } else if (_isPlaying && !_isLive) {
            // When playing but behind, current position advances slowly
            _currentPosition += const Duration(milliseconds: 500);

            // Don't let current position exceed live position
            if (_currentPosition > _livePosition) {
              _currentPosition = _livePosition;
              _isLive = true;
            }
          }
          // When paused, current position stays the same

          // Auto-cleanup old cache
          if (_livePosition > _maxCacheHours) {
            final excess = _livePosition - _maxCacheHours;
            if (_currentPosition > excess) {
              _currentPosition = _currentPosition - excess;
            } else {
              _currentPosition = Duration.zero;
            }
            _channelStartTime = _channelStartTime!.add(excess);
            _livePosition = _maxCacheHours;
          }

          notifyListeners();
        } catch (e) {
          // Silent catch for progress tracking errors
        }
      }
    });
  }

  void _startBufferCleanup() {
    _bufferCleanupTimer?.cancel();
    _bufferCleanupTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      // Cleanup is now handled in _startProgressTracking
    });
  }

  Future<void> stop() async {
    try {
      _progressTimer?.cancel();
      _bufferCleanupTimer?.cancel();

      if (_player != null) {
        await _player!.stop();
      }

      _resetState();
      debugPrint('FijkAudioService: Stream stopped');
    } catch (e) {
      debugPrint('FijkAudioService: Stop error: $e');
    }
  }

  void _resetState() {
    _isPlaying = false;
    _isLoading = false;
    _hasError = false;
    _errorMessage = null;
    _currentPosition = Duration.zero;
    _livePosition = Duration.zero;
    _isLive = true;
    _channelStartTime = null;
    _currentChannelId = null;
    _lastPauseTime = null;
    notifyListeners();
  }

  void _setError(String message) {
    _hasError = true;
    _errorMessage = message;
    _isLoading = false;
    _isPlaying = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _bufferCleanupTimer?.cancel();
    _player?.removeListener(() {});
    _player?.release();
    super.dispose();
  }
}