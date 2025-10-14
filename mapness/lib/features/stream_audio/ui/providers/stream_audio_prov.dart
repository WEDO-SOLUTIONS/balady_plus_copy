import 'dart:async';
import 'package:balady_plus/app/core/services/local/shared_prefs_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stream_audio/data/datasource/channels_data_source.dart';
import 'package:mapness/features/stream_audio/data/dto/channel_dto.dart';
import 'package:mapness/features/stream_audio/data/dto/filtered_channel.dart';
import 'package:mapness/features/stream_audio/services/audio_service.dart';

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

  StreamAudioProvider() {
    _initializeService();
  }

  Future<void> _initializeService() async {
    await _audioService.init();
    _audioService.addListener(_onAudioServiceChanged);
    _isInitialized = true;
    notifyListeners();
  }

  void _onAudioServiceChanged() {
    try {
      // Only notify if not disposed
      if (!_isExited) {
        notifyListeners();
      }
    } catch (e) {
      debugPrint('StreamAudioProvider: Error in _onAudioServiceChanged: $e');
    }
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

  bool get isLoading => _audioService.isLoading;

  bool get hasError => _audioService.hasError;

  String? get errorMessage => _audioService.errorMessage;

  bool get isExited => _isExited;

  bool get needsReinitialization => _isExited || selectedChannel == null;

  bool get isInitialized => _isInitialized;

  // Load channels data
  Future<void> getChannels() async {
    if (_channels.isEmpty) {
      try {
        _channels = await ChannelsDataSource().getChannels();
        filterChannels();
        await _applySavedChannelOrder();
        notifyListeners();
        debugPrint('StreamAudioProvider: Loaded ${_channels.length} channels');
      } catch (e) {
        debugPrint('StreamAudioProvider: Failed to load channels: $e');
      }
    }
  }

  void filterChannels() {
    filteredChannels.clear();
    for (final ChannelDTO channel in _channels) {
      if (channel.audioUrl != null && channel.audioUrl!.isNotEmpty) {
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
    if (oldIndex < 0 ||
        newIndex < 0 ||
        oldIndex >= filteredChannels.length ||
        newIndex >= filteredChannels.length) {
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
    debugPrint(
        'StreamAudioProvider: Reordered channels from index $oldIndex to $adjustedNewIndex');
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
      debugPrint(
          'StreamAudioProvider: Saved channel order to SharedPreferences');
    } catch (e) {
      debugPrint('StreamAudioProvider: Error saving channel order: $e');
    }
  }

  // Program selection and playback
  Future<void> selectChannel(FilteredChannel? channel) async {
    if (channel == null ||
        channel.audioUrl == null ||
        channel.audioUrl?.isEmpty == true) {
      return;
    }

    debugPrint('StreamAudioProvider: Selecting program: ${channel.name}');

    // If we were previously exited, reinitialize the audio service
    if (_isExited) {
      debugPrint('StreamAudioProvider: Reinitializing after exit');
      await _reinitializeAudioService();
    }

    _selectedChannel = channel;
    _isExited = false;

    try {
      await _audioService.playStream(
        url: channel.audioUrl!,
        channelId: channel.id.toString(),
        title: channel.name,
        programName: channel.currentPlayedProgram?.name ?? 'on Air',
      );
      debugPrint(
          'StreamAudioProvider: Successfully started playing ${channel.name}');
    } catch (e) {
      debugPrint('StreamAudioProvider: Error playing stream: $e');
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
    _audioService.addListener(_onAudioServiceChanged);
    _isInitialized = true;

    debugPrint('StreamAudioProvider: Audio service reinitialized');
  }

  // Playback controls
  Future<void> playStream() async {
    if (_selectedChannel == null ||
        _selectedChannel?.audioUrl == null ||
        _selectedChannel?.audioUrl?.isEmpty == true) {
      return;
    }

    debugPrint(
        'StreamAudioProvider: Playing stream for ${_selectedChannel?.name}');

    // If we were previously exited, reinitialize
    if (_isExited) {
      await _reinitializeAudioService();
    }

    _isExited = false;

    try {
      await _audioService.playStream(
        url: _selectedChannel!.audioUrl!,
        channelId: _selectedChannel!.id!.toString(),
        title: _selectedChannel!.name,
        programName: _selectedChannel!.currentPlayedProgram?.name ?? 'on Air',
      );
      debugPrint('StreamAudioProvider: Stream playing successfully');
    } catch (e) {
      debugPrint('StreamAudioProvider: Error in playStream: $e');
    }

    notifyListeners();
  }

  Future<void> pauseStream() async {
    await _audioService.pause();
    notifyListeners();
  }

  Future<void> resumeStream() async {
    await _audioService.resume();
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    await _audioService.togglePlayPause();
  }

  // Channel navigation
  bool get canGoToPreviousChannel {
    if (_selectedChannel == null || filteredChannels.isEmpty) {
      return false;
    }
    final currentIndex =
        filteredChannels.indexWhere((c) => c.id == _selectedChannel!.id);
    return currentIndex > 0;
  }

  bool get canGoToNextChannel {
    if (_selectedChannel == null || filteredChannels.isEmpty) {
      return false;
    }
    final currentIndex =
        filteredChannels.indexWhere((c) => c.id == _selectedChannel!.id);
    return currentIndex >= 0 && currentIndex < filteredChannels.length - 1;
  }

  Future<void> goToPreviousChannel() async {
    if (!canGoToPreviousChannel) {
      return;
    }
    final currentIndex =
        filteredChannels.indexWhere((c) => c.id == _selectedChannel!.id);
    if (currentIndex > 0) {
      await selectChannel(filteredChannels[currentIndex - 1]);
    }
  }

  Future<void> goToNextChannel() async {
    if (!canGoToNextChannel) {
      return;
    }
    final currentIndex =
        filteredChannels.indexWhere((c) => c.id == _selectedChannel!.id);
    if (currentIndex >= 0 && currentIndex < filteredChannels.length - 1) {
      await selectChannel(filteredChannels[currentIndex + 1]);
    }
  }

  // Exit and cleanup
  Future<void> exitPlayer() async {
    debugPrint('StreamAudioProvider: Exiting player');

    // Remove listener to avoid notifications during cleanup
    _audioService.removeListener(_onAudioServiceChanged);

    // Stop the audio service (don't dispose here, let reinitialize handle it)
    await _audioService.stop();

    // Mark as exited and clear selected program
    _isExited = true;
    _selectedChannel = null;
    _isInitialized = false;

    debugPrint('StreamAudioProvider: Player exited successfully');
    notifyListeners();
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
    // Cancel the contextual message timer if active
    _contextualMessageTimer?.cancel();

    _audioService
      ..removeListener(_onAudioServiceChanged)
      ..dispose();
    super.dispose();
  }
}

// Provider definition
final streamAudioProvider = ChangeNotifierProvider<StreamAudioProvider>(
  (ref) => StreamAudioProvider(),
);
