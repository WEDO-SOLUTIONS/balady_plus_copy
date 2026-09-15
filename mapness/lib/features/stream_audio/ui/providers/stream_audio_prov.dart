import 'dart:async';
import 'package:balady_plus/app/core/services/local/shared_prefs_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mapness/features/stream_audio/data/datasource/channels_data_source.dart';
import 'package:mapness/features/stream_audio/data/dto/channel_dto.dart';
import 'package:mapness/features/stream_audio/data/dto/filtered_channel.dart';
import 'package:mapness/features/stream_audio/services/audio_service.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/shared/utils/detach.dart';

class StreamAudioProvider extends ChangeNotifier {
  final AudioService _audioService = AudioService();
  FilteredChannel? _selectedChannel;
  List<ChannelDTO> _channels = [];
  List<FilteredChannel> filteredChannels = [];
  bool _isExited = false;
  bool _isInitialized = false;
  bool _isContextualMessageVisible = false;
  String? _contextualMessageTitle;
  String? _contextualMessageSubtitle;
  Timer? _contextualMessageTimer;
  bool _isDragging = false;
  bool _isFloatingPlayerVisible = true;
  bool _isInWeb = false;
  bool _isLoadingChannels = false;
  bool _isSelectingChannel = false; // Track when we're actively selecting a channel

  // Error toast deduplication
  bool _prevHasError = false;
  String? _lastShownErrorMessage;
  DateTime? _lastShownErrorAt;

  // Request deduplication
  Future<void>? _currentChannelsRequest;

  // Callback to trigger panel toggle from external widgets
  VoidCallback? _togglePanelCallback;

  // Background monitoring
  // Timer? _backgroundMonitorTimer;

  StreamAudioProvider() {
    _initializeService();
    // _startBackgroundMonitoring();
    // Load channels automatically when provider is created
    _loadChannelsOnInit();
  }

  void testAudioService() {
    _audioService.testAudioService();
  }

  // Set the ref to listen to language changes and initialize coordinator
  void setRef(Ref ref) {
    // Listen to language changes
    ref.listen<Language>(appLanguageProvider, (previous, next) {
      if (previous != null && previous != next) {
        // Language changed, refresh channels
        refreshChannels();
      }
    });

    // Provider initialization complete
  }

  Future<void> _initializeService() async {
    await _audioService.init();
    _audioService
      ..addListener(_onAudioServiceChanged)
      // Set callback for notification dismissal
      ..onNotificationDismissedCallback = (() {
        debugPrint('StreamAudioProvider: Notification dismissed callback received - forcing exit (like mustRemove)');
        // When notification is dismissed from outside, ALWAYS exit (like mustRemove)
        // This is a user action that should take precedence over any ongoing operations
        if (_isSelectingChannel) {
          debugPrint('StreamAudioProvider: Currently selecting channel, canceling selection and exiting');
          // Cancel the selection flag immediately so exitPlayer can proceed
          _isSelectingChannel = false;
        }

        // Always exit when notification is dismissed (user action)
        if (!_isExited) {
          exitPlayer();
        }
      });

    _isInitialized = true;
    notifyListeners();
  }

  // Coordinator initialization removed for simplicity

  // Load channels automatically when provider is initialized
  void _loadChannelsOnInit() {
    // Use Future.microtask with a small delay to avoid race conditions
    // with manual loading calls from UI components
    Future.microtask(() async {
      // Small delay to let the widget tree settle
      await Future.delayed(const Duration(milliseconds: 100));

      try {
        await getChannels();
        debugPrint('StreamAudioProvider: Channels loaded automatically on initialization');
      } catch (e) {
        debugPrint('StreamAudioProvider: Failed to load channels on initialization: $e');
      }
    });
  }

  // Start background monitoring to detect and recover from audio issues
  // void _startBackgroundMonitoring() {
  //   _backgroundMonitorTimer?.cancel();
  //   _backgroundMonitorTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
  //     if (!_isExited && _selectedChannel != null) {
  //       _audioService.monitorAndRecover();
  //     }
  //   });
  // }

  void _onAudioServiceChanged() {
    try {
      // Only notify if not disposed
      if (!_isExited) {
        // Sync selected channel if it changed from lockscreen
        final currentId = _audioService.currentChannelId;
        if (currentId != null && _selectedChannel?.id?.toString() != currentId) {
          final newChannel = filteredChannels.cast<FilteredChannel?>().firstWhere(
            (c) => c?.id?.toString() == currentId,
            orElse: () => null,
          );
          if (newChannel != null) {
            _selectedChannel = newChannel;
          }
        }
        notifyListeners();

        // Show user-friendly network toast for common stream failures.
        _maybeShowNetworkErrorToast();
      }
    } catch (e) {
      _maybeShowNetworkErrorToast();

      debugPrint('StreamAudioProvider: Error in _onAudioServiceChanged: $e');
    }
  }

  bool _isNetworkPlaybackError(String? message) {
    if (message == null || message.isEmpty) {
      return false;
    }
    final m = message.toLowerCase();

    // Common just_audio/ExoPlayer transport errors presented as "Source error".
    if (m.contains('source error')) {
      return true;
    }

    // iOS/AVFoundation style errors that bubble up through just_audio.
    // Example: "failed to start play back (-1008) resource unavailable"
    if (m.contains('(-1008)')) {
      return true;
    }
    if (m.contains('resource unavailable')) {
      return true;
    }
    if (m.contains('failed to start playback')) {
      return true;
    }
    if (m.contains('failed to start play back')) {
      return true;
    }

    // Generic network keywords we often see in thrown exceptions.
    if (m.contains('socketexception')) {
      return true;
    }
    if (m.contains('timeoutexception')) {
      return true;
    }
    if (m.contains('connection') && m.contains('failed')) {
      return true;
    }
    if (m.contains('network')) {
      return true;
    }
    if (m.contains('no internet')) {
      return true;
    }
    if (m.contains('handshakeexception')) {
      return true;
    }

    return false;
  }

  void _maybeShowNetworkErrorToast() {
    final hasErrorNow = _audioService.hasError;
    final message = _audioService.errorMessage;

    // Trigger only on edge: false -> true, so we don't spam.
    final becameError = !_prevHasError && hasErrorNow;
    _prevHasError = hasErrorNow;
    if (!becameError) {
      return;
    }

    if (!_isNetworkPlaybackError(message)) {
      return;
    }

    // If playback fails due to network/timeout, pause the player so the UI
    // doesn't look like it's still playing while audio is broken.
    detach(_audioService.pause(), tag: 'streamAudioProv.pause');

    // Dedupe repeated identical messages (e.g., auto retry / repeated listener triggers).
    final now = DateTime.now();
    final recentlyShown = _lastShownErrorAt != null && now.difference(_lastShownErrorAt!) < const Duration(seconds: 4);
    if (recentlyShown && _lastShownErrorMessage == message) {
      return;
    }
    _lastShownErrorMessage = message;
    _lastShownErrorAt = now;

    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null || !ctx.mounted) {
      return;
    }

    ToastOverlay.of(ctx).showNoInternet(
      onRetry: () {
        // Retry the currently selected channel if any; otherwise just reload channels.
        final channel = _selectedChannel;
        if (channel != null) {
          detach(selectChannel(channel), tag: 'streamAudioProv.selectChannel');
        } else {
          detach(getChannels(forceRefresh: true), tag: 'streamAudioProv.getChannels');
        }
      },
    );
  }

  bool get isContextualMessageVisible => _isContextualMessageVisible;

  String? get contextualMessageTitle => _contextualMessageTitle;

  String? get contextualMessageSubtitle => _contextualMessageSubtitle;

  void showContextualMessage() {
    _isContextualMessageVisible = true;

    // Cancel any existing timer
    _contextualMessageTimer?.cancel();

    // Start new timer to auto-hide after 15 seconds
    _contextualMessageTimer = Timer(const Duration(seconds: 15), () {
      hideContextualMessage();
    });

    notifyListeners();
  }

  void hideContextualMessage() {
    _isContextualMessageVisible = false;

    // Cancel the timer if it's still active
    if (_contextualMessageTimer != null && _contextualMessageTimer!.isActive) {
      _contextualMessageTimer!.cancel();
      _contextualMessageTimer = null;
    }

    notifyListeners();
  }

  set contextualMessageTitle(String? value) {
    _contextualMessageTitle = value;
    notifyListeners();
  }

  set contextualMessageSubtitle(String? value) {
    _contextualMessageSubtitle = value;
    notifyListeners();
  }

  void mockUserInTraffic() {
    contextualMessageTitle = 'Stuck in traffic';
    contextualMessageSubtitle = 'Tune into live radio';
    showContextualMessage();
  }

  // Program management
  FilteredChannel? get selectedChannel => _selectedChannel;

  // LiveNowDto? get liveNow => _liveNow;

  // set liveNow(LiveNowDto? value) {
  //   _liveNow = value;
  //   notifyListeners();
  // }

  // State getters from audio service
  bool get isPlaying => _audioService.isPlaying;

  // Helper to check if audio is effectively playing (including when ducked)
  bool get isEffectivelyPlaying => _audioService.isEffectivelyPlaying;

  bool get isLoading => _audioService.isLoading;

  bool get hasError => _audioService.hasError;

  String? get errorMessage => _audioService.errorMessage;

  bool get isExited => _isExited;

  bool get needsReinitialization => _isExited || selectedChannel == null;

  bool get isInitialized => _isInitialized;

  bool get isDragging => _isDragging;

  bool get isFloatingPlayerVisible => _isFloatingPlayerVisible;

  bool get isLoadingChannels => _isLoadingChannels;

  bool get hasChannels => filteredChannels.isNotEmpty;

  set isDragging(bool value) {
    debugPrint('StreamAudioProvider: isDragging set - old: $_isDragging, new: $value');
    _isDragging = value;
    notifyListeners();
    debugPrint('StreamAudioProvider: notifyListeners called');
  }

  bool get isInWeb => _isInWeb;

  set isInWeb(bool value) {
    debugPrint('StreamAudioProvider: isInWeb set - old: $_isInWeb, new: $value');
    _isInWeb = value;
    notifyListeners();
    debugPrint('StreamAudioProvider: InWeb state changed to $value');
  }

  set isFloatingPlayerVisible(bool isVisible) {
    debugPrint(
      'StreamAudioProvider: isFloatingPlayerVisible set - old: $_isFloatingPlayerVisible, new: $isVisible',
    );
    if (isInWeb && isVisible) {
      _isFloatingPlayerVisible = false;
    } else {
      _isFloatingPlayerVisible = isVisible;
    }
    notifyListeners();
    debugPrint('StreamAudioProvider: Floating player visibility changed to $isVisible');
  }

  // Register the toggle panel callback from StreamAudio widget
  void setTogglePanelCallback(VoidCallback? callback) {
    _togglePanelCallback = callback;
    debugPrint('StreamAudioProvider: Toggle panel callback ${callback != null ? 'registered' : 'unregistered'}');
  }

  // Trigger the panel toggle from external widgets (like mini apps)
  void togglePanel() {
    debugPrint('StreamAudioProvider: togglePanel called');
    if (_togglePanelCallback != null) {
      _togglePanelCallback!();
      debugPrint('StreamAudioProvider: Panel toggle callback executed');
    } else {
      debugPrint('StreamAudioProvider: No toggle panel callback registered');
    }
  }

  // Load channels data with request deduplication
  Future<void> getChannels({bool forceRefresh = false}) async {
    // If there's already a request in progress, wait for it
    if (_currentChannelsRequest != null && !forceRefresh) {
      debugPrint('StreamAudioProvider: Channels request already in progress, waiting...');
      return _currentChannelsRequest!;
    }

    // If we already have channels and not forcing refresh, return early
    if (_channels.isNotEmpty && !forceRefresh) {
      debugPrint('StreamAudioProvider: Channels already loaded (${_channels.length} channels)');
      return;
    }

    // Start new request
    _currentChannelsRequest = _loadChannelsInternal(forceRefresh);

    try {
      await _currentChannelsRequest!;
    } finally {
      _currentChannelsRequest = null;
    }
  }

  // Internal method to actually load channels
  Future<void> _loadChannelsInternal(bool forceRefresh) async {
    try {
      debugPrint('StreamAudioProvider: Starting to load channels (forceRefresh: $forceRefresh)');
      _isLoadingChannels = true;
      notifyListeners();

      _channels = await ChannelsDataSource().getChannels();
      filterChannels();
      await _applySavedChannelOrder();

      _isLoadingChannels = false;
      notifyListeners();
      debugPrint('StreamAudioProvider: Successfully loaded ${_channels.length} channels');
    } catch (e) {
      _isLoadingChannels = false;
      notifyListeners();
      debugPrint('StreamAudioProvider: Failed to load channels: $e');
      rethrow; // Re-throw to let callers handle the error
    }
  }

  // Refresh channels when language changes
  Future<void> refreshChannels() async {
    debugPrint('StreamAudioProvider: Refreshing channels due to language change');

    // Store the currently selected channel ID if any
    final currentChannelId = _selectedChannel?.id;

    await getChannels(forceRefresh: true);

    // If there was a selected channel, find and update it with the new data
    if (currentChannelId != null && filteredChannels.isNotEmpty) {
      try {
        final updatedChannel = filteredChannels.firstWhere(
          (channel) => channel.id == currentChannelId,
        );

        _selectedChannel = updatedChannel;
        debugPrint('StreamAudioProvider: Updated selected channel with new language data');
      } catch (e) {
        // If the channel is not found, keep the current selection or select the first available
        debugPrint('StreamAudioProvider: Previously selected channel not found, keeping current selection');
      }

      // Always notify listeners to ensure UI updates
      notifyListeners();
    }
  }

  void filterChannels() {
    filteredChannels.clear();
    for (final ChannelDTO channel in _channels) {
      if (channel.streamUrl != null && channel.streamUrl!.isNotEmpty) {
        filteredChannels.add(FilteredChannel.fromDTO(channel));
      }
    }
  }

  // Apply saved channel order from SharedPreferences
  Future<void> _applySavedChannelOrder() async {
    try {
      await sharedPrefs.init();
      final savedOrder = sharedPrefs.getChannelOrder();
      if (savedOrder != null && savedOrder.isNotEmpty) {
        // Sort filteredChannels based on saved order
        filteredChannels.sort((a, b) {
          final orderA = savedOrder[a.id.toString()] ?? 999;
          final orderB = savedOrder[b.id.toString()] ?? 999;
          return orderA.compareTo(orderB);
        });
        debugPrint('StreamAudioProvider: Applied saved channel order');
      }
    } catch (e) {
      debugPrint('StreamAudioProvider: Error applying saved channel order: $e');
    }
  }

  // Reorder channels and save to SharedPreferences
  Future<void> reorderChannels(int oldIndex, int newIndex) async {
    // Allow newIndex == length to support dropping at the end of the list
    if (oldIndex < 0 || newIndex < 0 || oldIndex >= filteredChannels.length || newIndex > filteredChannels.length) {
      return;
    }

    // Adjust newIndex for ReorderableListView behavior
    int adjustedNewIndex = newIndex;
    if (newIndex > oldIndex) {
      adjustedNewIndex = newIndex - 1;
    }

    // Reorder the channels list
    final item = filteredChannels.removeAt(oldIndex);
    filteredChannels.insert(adjustedNewIndex, item);

    // Save the new order to SharedPreferences
    await _saveChannelOrder();

    notifyListeners();
    debugPrint('StreamAudioProvider: Reordered channels from index $oldIndex to $adjustedNewIndex');
  }

  // Save current channel order to SharedPreferences
  Future<void> _saveChannelOrder() async {
    try {
      await sharedPrefs.init();
      final Map<String, int> channelOrder = {};

      for (int i = 0; i < filteredChannels.length; i++) {
        channelOrder[filteredChannels[i].id.toString()] = i;
      }

      await sharedPrefs.saveChannelOrder(channelOrder);
      debugPrint('StreamAudioProvider: Saved channel order to SharedPreferences');
    } catch (e) {
      debugPrint('StreamAudioProvider: Error saving channel order: $e');
    }
  }

  // Program selection and playback
  Future<void> selectChannel(FilteredChannel? channel) async {
    if (channel == null || channel.streamUrl == null || channel.streamUrl?.isEmpty == true) {
      return;
    }

    debugPrint('StreamAudioProvider: Selecting program: ${channel.name}');

    // Prevent exitPlayer from interfering while selecting
    _isSelectingChannel = true;

    try {
      // If we were previously exited, reinitialize the audio service
      if (_isExited) {
        debugPrint('StreamAudioProvider: Reinitializing after exit');
        await _reinitializeAudioService();
      }

      _selectedChannel = channel;
      _isExited = false;
      isFloatingPlayerVisible = true; // Show floating player when selecting a channel

      final playlistArgs = filteredChannels
          .map(
            (c) => {
              'url': c.streamUrl ?? '',
              'id': c.id?.toString() ?? '',
              'title': c.name,
              'programName': c.currentPlayedProgram?.name,
              'artUri': c.logo,
            },
          )
          .toList();

      final initialIndex = filteredChannels.indexWhere((c) => c.id == channel.id);

      await _audioService.playStream(
        url: channel.streamUrl!,
        channelId: channel.id.toString(),
        title: channel.name,
        programName: channel.currentPlayedProgram?.name,
        artUri: channel.logo, // Add artwork URL if available
        playlist: playlistArgs,
        initialIndex: initialIndex >= 0 ? initialIndex : 0,
      );

      // Stream audio is now active

      debugPrint('StreamAudioProvider: Successfully started playing ${channel.name}');
    } catch (e) {
      debugPrint('StreamAudioProvider: Error playing stream: $e');
    } finally {
      // Allow exitPlayer after a short delay to ensure playback has started
      Future.delayed(const Duration(milliseconds: 1000), () {
        _isSelectingChannel = false;
      });
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
    _audioService
      ..addListener(_onAudioServiceChanged)
      // Re-set callback for notification dismissal
      ..onNotificationDismissedCallback = (() {
        debugPrint('StreamAudioProvider: Notification dismissed callback received - forcing exit (like mustRemove)');
        // When notification is dismissed from outside, ALWAYS exit (like mustRemove)
        // This is a user action that should take precedence over any ongoing operations
        if (_isSelectingChannel) {
          debugPrint('StreamAudioProvider: Currently selecting channel, canceling selection and exiting');
          // Cancel the selection flag immediately so exitPlayer can proceed
          _isSelectingChannel = false;
        }

        // Always exit when notification is dismissed (user action)
        if (!_isExited) {
          exitPlayer();
        }
      });

    _isInitialized = true;

    debugPrint('StreamAudioProvider: Audio service reinitialized');
  }

  // Playback controls
  Future<void> playStream() async {
    if (_selectedChannel == null ||
        _selectedChannel?.streamUrl == null ||
        _selectedChannel?.streamUrl?.isEmpty == true) {
      return;
    }

    debugPrint('StreamAudioProvider: Playing stream for ${_selectedChannel?.name}');

    // If we were previously exited, reinitialize
    if (_isExited) {
      await _reinitializeAudioService();
    }

    _isExited = false;
    isFloatingPlayerVisible = true; // Show floating player when playing

    try {
      final playlistArgs = filteredChannels
          .map(
            (c) => {
              'url': c.streamUrl ?? '',
              'id': c.id?.toString() ?? '',
              'title': c.name,
              'programName': c.currentPlayedProgram?.name,
              'artUri': c.logo,
            },
          )
          .toList();

      final initialIndex = filteredChannels.indexWhere((c) => c.id == _selectedChannel!.id);

      await _audioService.playStream(
        url: _selectedChannel!.streamUrl!,
        channelId: _selectedChannel!.id!.toString(),
        title: _selectedChannel!.name,
        programName: _selectedChannel!.currentPlayedProgram?.name,
        artUri: _selectedChannel!.logo, // Add artwork URL if available
        playlist: playlistArgs,
        initialIndex: initialIndex >= 0 ? initialIndex : 0,
      );

      // Stream audio is now active

      debugPrint('StreamAudioProvider: Stream playing successfully');
    } catch (e) {
      debugPrint('StreamAudioProvider: Error in playStream: $e');
    }

    notifyListeners();
  }

  Future<void> pauseStream() async {
    await _audioService.pause();

    // Stream audio is no longer active

    notifyListeners();
  }

  Future<void> resumeStream() async {
    await _audioService.resume();
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    debugPrint(
      'StreamAudioProvider: togglePlayPause called - selectedChannel: ${_selectedChannel?.name}, isPlaying: ${_audioService.isPlaying}, isLoading: ${_audioService.isLoading}',
    );

    // If no channel is selected, select the first available channel and start playing
    if (_selectedChannel == null) {
      debugPrint('StreamAudioProvider: No channel selected, loading channels...');
      await getChannels();
      if (filteredChannels.isNotEmpty) {
        debugPrint('StreamAudioProvider: Auto-selecting first channel: ${filteredChannels.first.name}');
        await selectChannel(filteredChannels.first);
        return;
      } else {
        debugPrint('StreamAudioProvider: No channels available to play');
        return;
      }
    }

    // Sync state first to ensure we have accurate information about current playback state
    _audioService.syncState();

    // If we have a selected channel but audio service is not playing, start playing
    if (!_audioService.isPlaying && !_audioService.isLoading) {
      debugPrint('StreamAudioProvider: Starting playback for selected channel: ${_selectedChannel!.name}');
      await playStream();
    } else {
      // Otherwise, toggle play/pause normally (togglePlayPause will also sync state internally)
      debugPrint('StreamAudioProvider: Toggling play/pause state');
      await _audioService.togglePlayPause();
    }

    // Ensure UI is updated after toggle
    notifyListeners();
  }

  // Channel navigation
  bool get canGoToPreviousChannel {
    if (_selectedChannel == null || filteredChannels.isEmpty) {
      return false;
    }
    final currentIndex = filteredChannels.indexWhere((c) => c.id == _selectedChannel!.id);
    return currentIndex > 0;
  }

  bool get canGoToNextChannel {
    if (_selectedChannel == null || filteredChannels.isEmpty) {
      return false;
    }
    final currentIndex = filteredChannels.indexWhere((c) => c.id == _selectedChannel!.id);
    return currentIndex >= 0 && currentIndex < filteredChannels.length - 1;
  }

  void goToPreviousChannel() {
    if (!canGoToPreviousChannel) {
      return;
    }
    // Capture current selection to avoid null access after delay
    final selectedId = _selectedChannel?.id;
    if (selectedId == null) {
      return;
    }
    final delay = Duration(milliseconds: isLoading ? 10000 : 10);
    Future.delayed(delay).then((_) async {
      // Re-validate state at execution time
      if (_isExited) {
        return;
      }
      final currentIndex = filteredChannels.indexWhere((c) => c.id == selectedId);
      if (currentIndex > 0) {
        await selectChannel(filteredChannels[currentIndex - 1]);
      }
    });
  }

  void goToNextChannel() {
    if (!canGoToNextChannel) {
      return;
    }
    // Capture current selection to avoid null access after delay
    final selectedId = _selectedChannel?.id;
    if (selectedId == null) {
      return;
    }
    final delay = Duration(milliseconds: isLoading ? 10000 : 10);
    Future.delayed(delay).then((_) async {
      // Re-validate state at execution time
      if (_isExited) {
        return;
      }
      final currentIndex = filteredChannels.indexWhere((c) => c.id == selectedId);
      if (currentIndex >= 0 && currentIndex < filteredChannels.length - 1) {
        await selectChannel(filteredChannels[currentIndex + 1]);
      }
    });
  }

  // Exit and cleanup
  Future<void> exitPlayer() async {
    debugPrint('StreamAudioProvider: Exiting player');

    // Stream audio is no longer active

    // Reset selection flag to allow exit
    _isSelectingChannel = false;

    // Remove listener to avoid notifications during cleanup
    _audioService.removeListener(_onAudioServiceChanged);

    // Stop the audio service (don't dispose here, let reinitialize handle it)
    await _audioService.stop();

    // Mark as exited and clear selected program
    _isExited = true;
    _selectedChannel = null;
    _isInitialized = false;
    isFloatingPlayerVisible = false; // Hide floating player when exiting

    debugPrint('StreamAudioProvider: Player exited successfully');
    notifyListeners();
  }

  // Handle app lifecycle changes
  void handleAppLifecycleChange(AppLifecycleState state) {
    debugPrint('StreamAudioProvider: App lifecycle changed to $state');

    switch (state) {
      case AppLifecycleState.resumed:
        // App came back to foreground - check if notification was dismissed
        if (_selectedChannel != null && !_isExited) {
          // Check if player was dismissed while app was in background
          final wasDismissed = _audioService.checkIfPlayerWasDismissed();
          if (wasDismissed) {
            debugPrint('StreamAudioProvider: Player was dismissed while app was in background');
            // exitPlayer() will be called by the callback, but ensure state is updated
            return;
          }

          // Immediately sync state to reflect actual player state
          _audioService.syncState();
          notifyListeners();

          // Audio service monitoring removed for simplicity
        }
        break;
      case AppLifecycleState.paused:
        // App went to background - audio should continue playing
        // No action needed as we want background playback
        break;
      case AppLifecycleState.inactive:
        // App is inactive (e.g., during phone call)
        // Audio will be automatically paused by system
        break;
      case AppLifecycleState.detached:
        // App is detached - prepare for termination
        break;
      case AppLifecycleState.hidden:
        // App is hidden
        break;
    }
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

  // Method to prepare for mini app navigation - reduces memory usage
  Future<void> prepareForMiniAppNavigation() async {
    debugPrint('StreamAudioProvider: Preparing for mini app navigation');

    try {
      // Cancel background monitoring temporarily to reduce memory usage
      // _backgroundMonitorTimer?.cancel();
      // _backgroundMonitorTimer = null;

      // Cancel contextual message timer
      _contextualMessageTimer?.cancel();
      _contextualMessageTimer = null;

      // Clear any pending channels request
      _currentChannelsRequest = null;

      // If audio is playing, keep it playing but reduce monitoring
      if (_selectedChannel != null && isPlaying) {
        debugPrint('StreamAudioProvider: Audio continues playing during mini app navigation');
      }

      notifyListeners();
    } catch (e) {
      debugPrint('StreamAudioProvider: Error preparing for mini app navigation: $e');
    }
  }

  // Method to restore after mini app navigation
  // Future<void> restoreAfterMiniAppNavigation() async {
  //   debugPrint('StreamAudioProvider: Restoring after mini app navigation');
  //
  //   try {
  //     // Restart background monitoring if we have a selected channel
  //     if (_selectedChannel != null && !_isExited) {
  //       _startBackgroundMonitoring();
  //     }
  //
  //     notifyListeners();
  //   } catch (e) {
  //     debugPrint('StreamAudioProvider: Error restoring after mini app navigation: $e');
  //   }
  // }

  // Program reordering (for UI)
  // void reorderPrograms(int oldIndex, int passedNewIndex) {
  //   final ln = liveNow;
  //   if (ln == null) {
  //     return;
  //   }
  //
  //   final list = [...ln.programs];
  //   int newIndex = passedNewIndex;
  //   if (passedNewIndex > oldIndex) {
  //     newIndex = passedNewIndex - 1;
  //   }
  //   final item = list.removeAt(oldIndex);
  //   list.insert(newIndex, item);
  //
  //   liveNow = ln.copyWith(programs: list);
  // }

  @override
  void dispose() {
    debugPrint('StreamAudioProvider: Starting dispose');

    // Mark as exited to prevent further operations
    _isExited = true;

    // Cancel all timers
    _contextualMessageTimer?.cancel();
    _contextualMessageTimer = null;

    // _backgroundMonitorTimer?.cancel();
    // _backgroundMonitorTimer = null;

    // Clear any pending channels request
    _currentChannelsRequest = null;

    // Clear callback references to prevent memory leaks
    _togglePanelCallback = null;

    // Navigation coordinator removed

    // Remove listener and dispose audio service
    _audioService.removeListener(_onAudioServiceChanged);
    // _audioService.dispose();

    // Clear collections
    _channels.clear();
    filteredChannels.clear();
    _selectedChannel = null;

    super.dispose();
    debugPrint('StreamAudioProvider: Dispose completed');
  }
}

// Provider definition
final streamAudioProvider = ChangeNotifierProvider<StreamAudioProvider>(
  (ref) {
    final provider = StreamAudioProvider()..setRef(ref);
    return provider;
  },
);
