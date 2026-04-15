# MBC Audio Player Feature - Complete Documentation

## Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Core Components](#core-components)
4. [UI Components](#ui-components)
5. [Data Models](#data-models)
6. [State Management](#state-management)
7. [Audio Service](#audio-service)
8. [Platform Integration](#platform-integration)
9. [Dependencies](#dependencies)
10. [API Integration](#api-integration)
11. [Features](#features)
12. [Usage Guide](#usage-guide)
13. [Configuration](#configuration)

---

## Overview

The MBC Audio Player is a comprehensive live radio streaming feature integrated into the Balady application. It provides seamless audio playback with background support, lock screen controls, notification management, and integration with the navigation system for audio ducking.

### Key Capabilities
- Live radio streaming from multiple MBC channels
- Background audio playback
- Lock screen and notification controls
- Orientation-aware UI (Portrait/Landscape)
- Floating draggable mini player
- Channel navigation (previous/next)
- Audio ducking for navigation voice guidance
- Real-time program information display
- Channel reordering and persistence

---

## Architecture

The MBC Audio Player follows a layered architecture:

```
┌─────────────────────────────────────────────────┐
│              UI Layer (Flutter)                 │
│  - StreamAudioScreen                            │
│  - PlayingAudioTile                             │
│  - DraggableFloatingPlayerControls              │
│  - MediaCatalogList                             │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│          State Management Layer                 │
│  - StreamAudioProvider (Riverpod)               │
│  - AudioService (ChangeNotifier)                │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│             Service Layer                       │
│  - AudioService (just_audio wrapper)            │
│  - ChannelsDataSource (API client)              │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│          Platform Integration Layer             │
│  - iOS: MethodChannel for audio coordination    │
│  - Android: Background service via              │
│    just_audio_background                        │
└─────────────────────────────────────────────────┘
```

---

## Core Components

### 1. AudioService (`audio_service.dart`)

**Location**: `mapness/lib/features/stream_audio/services/audio_service.dart`

**Purpose**: Core audio playback service managing stream playback, state, and platform coordination.

**Key Features**:
- Singleton pattern for global audio management
- Background audio initialization
- Stream playback management
- State synchronization
- iOS audio coordination
- Notification dismissal detection
- Audio interruption handling

#### Key Methods

```dart
// Initialization
Future<void> init()                              // Initialize audio service
static Future<void> initializeGlobally()         // Global background init
Future<void> reinitialize()                      // Reinitialize after cleanup

// Playback Control
Future<void> playStream({required String url, ...})  // Start stream playback
Future<void> pause()                                // Pause playback
Future<void> resume()                               // Resume playback
Future<void> stop()                                 // Stop and cleanup
Future<void> togglePlayPause()                      // Toggle play/pause

// State Management
void syncState()                                    // Sync internal state with player
bool checkIfPlayerWasDismissed()                    // Detect notification dismissal

// iOS Coordination
Future<void> _setupIOSAudioCoordination()           // Setup iOS method channel
Future<void> _handleDuckAudio(dynamic arguments)    // Handle navigation ducking
Future<void> _handleRestoreAudio(dynamic arguments) // Restore after ducking
```

#### State Properties

```dart
bool isInitialized         // Service initialization status
bool isPlaying             // Current playback state
bool isLoading             // Buffering/loading state
bool hasError              // Error state
String? errorMessage       // Error details
bool isDucked              // Audio ducking state
String? currentChannelId   // Active channel identifier
```

#### Notification Dismissal Detection

The service implements multiple mechanisms to detect when the audio notification is dismissed:

1. **Player State Monitoring**: Listens to `playerStateStream` for unexpected stops
2. **Playback Event Monitoring**: Monitors `playbackEventStream` for state changes
3. **Periodic Timer**: Checks every 2 seconds as a backup detection method

When dismissal is detected, it:
- Resets expectations (`_expectsToBePlaying = false`)
- Clears current stream info
- Notifies iOS that MBC is inactive
- Calls the notification dismissed callback

---

### 2. StreamAudioProvider (`stream_audio_prov.dart`)

**Location**: `mapness/lib/features/stream_audio/ui/providers/stream_audio_prov.dart`

**Purpose**: Riverpod provider managing audio player UI state and business logic.

**Responsibilities**:
- Channel management (loading, filtering, ordering)
- Playback state coordination
- UI state management
- App lifecycle handling
- Language change handling

#### Key Methods

```dart
// Channel Management
Future<void> getChannels({bool forceRefresh = false})  // Load channels from API
Future<void> refreshChannels()                         // Refresh on language change
void filterChannels()                                   // Filter channels with valid stream URLs
Future<void> reorderChannels(int oldIndex, int newIndex) // Reorder and persist

// Playback Control
Future<void> selectChannel(FilteredChannel? channel)   // Select and play channel
Future<void> playStream()                              // Start playback
Future<void> pauseStream()                             // Pause playback
Future<void> resumeStream()                            // Resume playback
Future<void> togglePlayPause()                         // Toggle play/pause
void goToPreviousChannel()                             // Switch to previous channel
void goToNextChannel()                                 // Switch to next channel

// State Management
Future<void> exitPlayer()                              // Exit and cleanup
Future<void> reset()                                   // Reset provider state
void handleAppLifecycleChange(AppLifecycleState state) // Handle app lifecycle
```

#### State Properties

```dart
FilteredChannel? selectedChannel      // Currently selected channel
List<FilteredChannel> filteredChannels // Available channels
bool isPlaying                        // Playback state (from AudioService)
bool isLoading                        // Loading state (from AudioService)
bool hasError                         // Error state (from AudioService)
bool isExited                         // Exit state
bool isFloatingPlayerVisible          // Mini player visibility
bool isLoadingChannels                // Channels loading state
```

#### Channel Ordering Persistence

Channels can be reordered by users, and the order is persisted to SharedPreferences:

```dart
await sharedPrefs.saveChannelOrder(channelOrder);  // Save order
final savedOrder = sharedPrefs.getChannelOrder();  // Load order
```

---

## UI Components

### 1. StreamAudioScreen (`stream_audio_screen.dart`)

**Location**: `mapness/lib/features/stream_audio/ui/pages/stream_audio_screen.dart`

**Purpose**: Main container widget providing orientation-aware layout with draggable sheets.

**Features**:
- **Portrait Mode**: Bottom sheet that slides up from bottom
- **Landscape Mode**: Side sheet that slides from left (RTL) or right (LTR)
- Auto-close timer (8 seconds) when panel opens
- Keyboard-aware: Closes sheet when keyboard opens
- Smooth orientation transitions
- Removal zone for exiting player (drag to top)

#### Layout Structure

**Portrait**:
```
┌─────────────────────────────┐
│                             │
│      Child Widget           │  ← Main content (map/view)
│      (offset upward)        │
│                             │
├─────────────────────────────┤
│                             │
│   Draggable Bottom Sheet    │  ← Audio controls
│   - PlayingAudioTile        │
│   - MediaCatalogList        │
│                             │
└─────────────────────────────┘
        ↑
   Floating Mini Player (when sheet closed)
```

**Landscape**:
```
┌────────────┬─────────────────┐
│            │                 │
│   Child    │  Side Sheet     │
│   Widget   │  - PlayingAudio │
│   (pushed) │  - MediaCatalog │
│            │                 │
└────────────┴─────────────────┘
```

#### Key Properties

```dart
double _minChildSize = 0.0      // Minimum sheet size (closed)
double _maxChildSize = 0.34     // Maximum sheet size (open)
double _landscapeMaxWidth = 0.4 // Landscape sheet max width (40%)
Timer? _autoCloseTimer          // 8-second auto-close timer
```

#### Auto-Close Behavior

When the panel opens:
- An 8-second timer starts
- If panel height drops below 150px, timer cancels and panel closes immediately
- Timer resets when user interacts with channel list

---

### 2. PlayingAudioTile (`playing_audio_tile.dart`)

**Location**: `mapness/lib/features/stream_audio/ui/widgets/playing_audio_tile.dart`

**Purpose**: Displays current playing channel information and playback controls.

**Layouts**:
- **Portrait**: Horizontal layout with album art, title/subtitle, controls
- **Landscape**: Vertical layout with larger album art, centered text, vertical controls

#### Components

1. **Album Art**: 
   - Shows current program image if available
   - Falls back to channel logo
   - Supports both raster (PNG/JPG) and vector (SVG) images
   - Size: 48px (portrait) or 120px (landscape)

2. **Title/Subtitle**:
   - Title: Current program name or "On Air" / "على الهواء"
   - Subtitle: Channel name

3. **Controls**:
   - Previous channel button (left/up)
   - Play/Pause button (center)
   - Next channel button (right/down)
   - Loading indicator when buffering
   - Error-aware play/pause icon

---

### 3. DraggableFloatingPlayerControls (`draggable_floating_player_controls.dart`)

**Location**: `mapness/lib/features/stream_audio/ui/widgets/draggable_floating_player_controls.dart`

**Purpose**: Floating mini player widget that can be dragged around the screen.

**Features**:
- Draggable anywhere on screen
- Collapses to circle when dragged to edges
- Expands to full width when dragged to center
- Tap to open main panel
- Drag to top removal zone to exit player
- Orientation-aware edge detection
- Momentum-based movement

#### States

1. **Expanded**: Full width (220px) showing channel info and controls
2. **Collapsed**: Circle (60px) showing audio wave icon
3. **Removal Zone**: When dragged to top, shows removal UI

#### Edge Behaviors

**Portrait**:
- Bottom edge: Opens panel
- Left/Right edges: Collapses to circle
- Top edge: Enters removal zone

**Landscape (RTL)**:
- Left edge: Opens panel
- Right edge: Collapses to circle

**Landscape (LTR)**:
- Right edge: Opens panel
- Left edge: Collapses to circle

#### Animations

- Scale animation on press (0.95x)
- Shape morphing between rectangle and circle
- Smooth position snapping
- Momentum physics for natural movement

---

### 4. MediaCatalogList (`sheet_channels_list.dart`)

**Location**: `mapness/lib/features/stream_audio/ui/widgets/sheet_channels_list.dart`

**Purpose**: Horizontal (portrait) or vertical (landscape) scrollable list of channels.

**Features**:
- Shows all available channels
- Highlights selected channel
- Tap channel to select and play
- Loading indicator when channels are loading

---

### 5. ChannelItem (`channel_item.dart`)

**Location**: `mapness/lib/features/stream_audio/ui/widgets/channel_item.dart`

**Purpose**: Individual channel card widget.

**Components**:
- Program/channel image (96x96)
- Current program name or "On Air"
- Channel name
- Channel logo badge (circled, positioned bottom-right)
- Wave animation overlay when selected
- Blur effect for channels without current program

---

## Data Models

### 1. ChannelDTO (`channel_dto.dart`)

**Location**: `mapness/lib/features/stream_audio/data/dto/channel_dto.dart`

**Purpose**: Data transfer object for API channel data.

**Key Fields**:
```dart
int? id                          // Channel ID
String? name                     // Channel name
String? logo                     // Logo URL
String? streamUrl                // Stream URL (M3U8/HLS)
List<Program>? programs          // Current programs schedule
List<Podcasts>? podcasts         // Available podcasts
bool? hasVoiceNote              // Voice note feature
bool? hasMessaging              // Messaging feature
int? channelOrder               // Display order
```

### 2. FilteredChannel (`filtered_channel.dart`)

**Location**: `mapness/lib/features/stream_audio/data/dto/filtered_channel.dart`

**Purpose**: Extended channel model with computed properties.

**Additional Features**:
- Extends `ChannelDTO`
- Computes current playing program based on time
- Parses program time ranges (e.g., "6:00 AM - 10:00 AM")

**Key Method**:
```dart
Program? get currentPlayedProgram {
  // Finds program that matches current time
  // Compares now with startTime and endTime
}
```

**Time Parsing**:
- Supports formats: "6:00 AM", "6:00AM", "10:00 PM"
- Handles 12-hour format conversion
- Uses current date as base for DateTime creation

---

## State Management

### Provider Setup

The audio player uses **Riverpod** for state management:

```dart
final streamAudioProvider = ChangeNotifierProvider<StreamAudioProvider>(
  (ref) {
    final provider = StreamAudioProvider();
    provider.setRef(ref);  // Setup language change listener
    return provider;
  },
);
```

### State Flow

```
User Action
    ↓
StreamAudioProvider (business logic)
    ↓
AudioService (playback control)
    ↓
just_audio (platform player)
    ↓
State Update → notifyListeners()
    ↓
UI Rebuild (ConsumerWidget)
```

### Lifecycle Management

The provider handles app lifecycle changes:

```dart
void handleAppLifecycleChange(AppLifecycleState state) {
  switch (state) {
    case AppLifecycleState.resumed:
      // Check if notification was dismissed
      // Sync state with actual player state
      break;
    case AppLifecycleState.paused:
      // Audio continues in background
      break;
  }
}
```

---

## Audio Service

### Initialization Flow

```
1. AudioService.initializeGlobally() [Optional, called at app start]
   ↓
2. JustAudioBackground.init() [Background service setup]
   ↓
3. AudioService.init()
   ↓
4. Create AudioPlayer instance
   ↓
5. Setup player listeners (state, playback events)
   ↓
6. Setup iOS audio coordination (if iOS)
   ↓
7. Ready for playback
```

### Playback Flow

```
1. playStream(url, channelId, ...)
   ↓
2. Set current stream metadata
   ↓
3. Create AudioSource.uri() with MediaItem tag
   ↓
4. Set audio source on player
   ↓
5. Call player.play()
   ↓
6. Notify iOS that MBC is active
   ↓
7. Start dismissal check timer
   ↓
8. Update UI state
```

### Background Audio

**Android**:
- Uses `just_audio_background` plugin
- Creates foreground service with notification
- Notification shows playback controls
- Ongoing notification (cannot be dismissed by swipe, but can be stopped)

**iOS**:
- Uses `AVAudioSession` with playback category
- Lock screen controls automatically available
- Notification from `just_audio_background`

### Notification Configuration

```dart
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
);
```

---

## Platform Integration

### iOS Audio Coordination

**Method Channel**: `com.balady.audio_coordination`

**Methods Called from iOS**:
- `duckAudio`: Lower volume for navigation voice
- `restoreAudio`: Restore volume after navigation
- `onAudioInterrupted`: Audio interruption started
- `onAudioInterruptionEnded`: Audio interruption ended
- `onAudioRouteChanged`: Audio route changed (e.g., headphones)

**Methods Called to iOS**:
- `notifyMBCActive`: MBC audio playback started
- `notifyMBCInactive`: MBC audio playback stopped

**Purpose**: Coordinate audio playback with navigation voice guidance to prevent conflicts.

### Audio Ducking

When navigation voice plays:
1. iOS calls `duckAudio` with target volume (default: 0.3)
2. AudioService stores original volume
3. Gradually reduces player volume
4. Sets `_isNavigationDucking = true`
5. When navigation ends, iOS calls `restoreAudio`
6. Volume is restored to original level

### Audio Session Configuration

```dart
await _audioSession!.configure(const AudioSessionConfiguration(
  avAudioSessionCategory: AVAudioSessionCategory.playback,
  avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.allowBluetooth,
  avAudioSessionMode: AVAudioSessionMode.defaultMode,
  androidAudioAttributes: AndroidAudioAttributes(
    contentType: AndroidAudioContentType.music,
    usage: AndroidAudioUsage.media,
  ),
  androidWillPauseWhenDucked: false,  // Important: Don't pause, just duck
));
```

---

## Dependencies

### Core Audio Packages

```yaml
# pubspec.yaml
just_audio: ^0.9.46                    # Core audio player
just_audio_background: ^0.0.1-beta.17  # Background playback support
audio_session: ^0.1.x                  # Audio session management (if used)
```

### State Management

```yaml
flutter_riverpod: ^2.x                 # State management
```

### Additional Dependencies

```yaml
flutter_keyboard_visibility: ^x.x.x    # Keyboard detection
```

---

## API Integration

### Channels Data Source (`channels_data_source.dart`)

**Endpoint**: `GET /v1/mbc-services/channels`

**Headers**:
```
Accept-Language: ar | en
```

**Response Structure**:
```json
{
  "data": {
    "result": [
      {
        "id": 1,
        "name": "MBC FM",
        "logo": "https://...",
        "stream_url": "https://d2ssktsthzv4nj.cloudfront.net/mbcfm-radio.m3u8",
        "programs": [
          {
            "id": 123,
            "name": "Morning Show",
            "start_time": "6:00 AM",
            "end_time": "10:00 AM",
            "image": "https://..."
          }
        ]
      }
    ]
  }
}
```

### Error Handling

- Network timeouts: 30 seconds
- Retry logic: Not implemented (handled by Dio interceptor if configured)
- Error states: Displayed in UI with error message

---

## Features

### 1. Multi-Channel Support
- Load multiple radio channels from API
- Switch between channels seamlessly
- Navigate previous/next channels
- Persistent channel ordering

### 2. Real-Time Program Information
- Displays current playing program
- Automatically updates based on schedule
- Shows "On Air" when no program is scheduled
- Program images and metadata

### 3. Background Playback
- Continues playing when app is backgrounded
- Lock screen controls
- Notification controls
- Works with system media controls

### 4. Orientation Support
- Portrait: Bottom sheet
- Landscape: Side sheet (RTL/LTR aware)
- Smooth transitions between orientations
- Floating player adapts to orientation

### 5. Audio Ducking
- Automatically lowers volume during navigation
- Restores volume after navigation ends
- iOS-only feature via native coordination

### 6. Error Recovery
- Detects network errors
- Handles playback errors gracefully
- Error messages displayed in UI
- Automatic state recovery

### 7. Notification Management
- Detects notification dismissal
- Exits player when notification is dismissed
- Multiple detection methods for reliability

### 8. Channel Ordering
- Drag-and-drop reordering (if implemented in UI)
- Persistent storage in SharedPreferences
- Maintains order across app restarts

---

## Usage Guide

### Basic Integration

1. **Wrap your app with StreamAudio widget**:
```dart
StreamAudio(
  child: YourMainWidget(),
)
```

2. **Access provider in your widgets**:
```dart
final provider = ref.watch(streamAudioProvider);

// Play a channel
await provider.selectChannel(channel);

// Toggle play/pause
await provider.togglePlayPause();

// Navigate channels
provider.goToNextChannel();
provider.goToPreviousChannel();
```

3. **Handle app lifecycle** (if needed):
```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  ref.read(streamAudioProvider).handleAppLifecycleChange(state);
}
```

### Programmatic Control

```dart
// Get provider instance
final provider = ref.read(streamAudioProvider);

// Load channels
await provider.getChannels();

// Select and play channel
final channel = provider.filteredChannels.first;
await provider.selectChannel(channel);

// Control playback
await provider.pauseStream();
await provider.resumeStream();

// Exit player
await provider.exitPlayer();
```

### Accessing Audio Service Directly

```dart
final audioService = AudioService();

// Check state
bool isPlaying = audioService.isPlaying;
bool isLoading = audioService.isLoading;
String? error = audioService.errorMessage;

// Control playback
await audioService.pause();
await audioService.resume();
await audioService.stop();
```

---

## Configuration

### Android Configuration

**AndroidManifest.xml**:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>

<service
    android:name="com.ryanheise.just_audio_background.AudioService"
    android:foregroundServiceType="mediaPlayback"
    android:exported="false"/>
```

### iOS Configuration

**Info.plist**:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

**AppDelegate.swift** (if implementing native audio coordination):
- Setup MethodChannel: `com.balady.audio_coordination`
- Implement duck/restore audio methods
- Handle MBC active/inactive notifications

### Notification Channel (Android)

The notification channel is created automatically by `just_audio_background`:
- ID: `com.balady.audio.channel`
- Name: `Live Radio`
- Description: `Live radio streaming controls`
- Importance: High (for ongoing notification)

---

## File Structure

```
mapness/lib/features/stream_audio/
├── data/
│   ├── datasource/
│   │   └── channels_data_source.dart      # API client
│   └── dto/
│       ├── channel_dto.dart               # API response model
│       └── filtered_channel.dart          # Extended model
├── services/
│   └── audio_service.dart                 # Core audio service
└── ui/
    ├── pages/
    │   └── stream_audio_screen.dart       # Main container
    ├── providers/
    │   └── stream_audio_prov.dart         # State management
    └── widgets/
        ├── playing_audio_tile.dart        # Current playing info
        ├── draggable_floating_player_controls.dart  # Mini player
        ├── sheet_channels_list.dart       # Channel list
        ├── channel_item.dart              # Channel card
        └── audio_wave_icon.dart           # Wave animation
```

---

## Troubleshooting

### Audio Not Playing
1. Check internet connection
2. Verify stream URL is valid
3. Check Android permissions
4. Check iOS background modes
5. Review error messages in logs

### Notification Not Showing
1. Verify `just_audio_background` initialization
2. Check notification channel setup (Android)
3. Verify notification permissions (Android 13+)
4. Check iOS background modes

### Notification Dismissal Not Detected
1. Check dismissal check timer is running
2. Verify player state listeners are active
3. Check `_expectsToBePlaying` flag is set correctly

### Audio Ducking Not Working
1. Verify iOS method channel is set up
2. Check native iOS code implementation
3. Verify `_isNavigationDucking` flag logic

### Orientation Issues
1. Check `OrientationBuilder` usage
2. Verify sheet controller state
3. Check transition delays/timing

---

## Best Practices

1. **Always initialize AudioService before use**:
   ```dart
   await AudioService().init();
   ```

2. **Handle app lifecycle properly**:
   ```dart
   // Check state when app resumes
   audioService.checkIfPlayerWasDismissed();
   ```

3. **Clean up resources**:
   ```dart
   // When exiting player
   await provider.exitPlayer();
   ```

4. **Error handling**:
   ```dart
   // Always check for errors
   if (provider.hasError) {
     // Show error message
   }
   ```

5. **State synchronization**:
   ```dart
   // Sync state before checking
   audioService.syncState();
   bool isPlaying = audioService.isPlaying;
   ```

---

## Future Enhancements

Potential improvements and features:

1. **Playlist Support**: Queue multiple channels
2. **Favorites**: Save favorite channels
3. **History**: Track recently played channels
4. **Search**: Search channels by name
5. **Offline Support**: Cache recently played streams
6. **Analytics**: Track playback statistics
7. **Social Sharing**: Share currently playing program
8. **Sleep Timer**: Auto-stop after specified time

---

## Support

For issues or questions:
1. Check logs for debug messages (prefixed with `AudioService:` or `StreamAudioProvider:`)
2. Review error messages in UI
3. Verify platform-specific configurations
4. Test on both iOS and Android devices

---

## Changelog

### Version 1.0.0
- Initial implementation
- Background playback support
- Notification controls
- iOS audio coordination
- Orientation-aware UI
- Channel management
- Program information display

---

**Document Version**: 1.0  
**Last Updated**: 2024  
**Maintained by**: Balady Development Team

