# Stream Audio Feature

A comprehensive live radio streaming feature for the Balady app that provides real-time audio streaming with advanced caching, playback controls, and native platform integration.

## 📁 Module Structure

```
stream_audio/
├── data/
│   ├── datasource/
│   │   ├── channels_data_source.dart    # Mock data source for radio channels
│   │   └── arriving_soon.dart           # Future features mock data
│   └── dto/
│       └── LiveNowDto.dart              # Data models for programs and channels
├── services/
│   └── audio_service.dart               # Core audio streaming service (singleton)
└── ui/
    ├── pages/
    │   ├── stream_audio_screen.dart     # Main overlay screen with draggable sheet
    │   └── media_catalog_screen.dart    # Full-screen media catalog page
    ├── providers/
    │   └── stream_audio_prov.dart       # Riverpod state management provider
    └── widgets/
        ├── audio_wave_icon.dart         # Animated audio wave visualization
        ├── cached_audio_progress_bar.dart # Custom progress bar with live/cached states
        ├── draggable_floating_player_controls.dart # Floating draggable player widget
        ├── explore_card.dart            # Media exploration card component
        ├── mbc_mood.dart               # MBC branding component
        ├── media_catalog_item.dart      # Individual catalog item widget
        ├── media_catalog_list.dart      # Horizontal scrollable catalog list
        ├── playing_audio_tile.dart      # Currently playing audio display
        └── radio_contextual_button.dart # Context-aware radio entry button
```

## 🏗️ Architecture Overview

### Core Components

#### 1. **AudioService** (Singleton)
- **File**: `services/audio_service.dart`
- **Purpose**: Core audio streaming engine with live buffering and caching
- **Key Features**:
  - Live stream playback with real-time caching (up to 1 hour)
  - Seamless switching between live and cached audio
  - Background streaming with file-based cache management
  - Platform-specific media session integration (Android)
  - Automatic position tracking and seek functionality

#### 2. **StreamAudioProvider** (Riverpod)
- **File**: `ui/providers/stream_audio_prov.dart`
- **Purpose**: State management and business logic layer
- **Key Features**:
  - Program selection and playback state management
  - Provider lifecycle management with reinitialization support
  - Contextual messaging system for user engagement
  - Integration bridge between UI and AudioService

#### 3. **Data Layer**
- **Models**: `LiveNowDto`, `ProgramDto` for type-safe data handling
- **DataSource**: Mock implementation with hardcoded radio stations
- **Future**: Ready for real API integration

### UI Architecture

#### Main Screen (`StreamAudioScreen`)
A sophisticated overlay system built with:
- **DraggableScrollableSheet**: Bottom sheet with three states (closed, partial, full)
- **Floating Controls**: Draggable mini-player that can be positioned anywhere
- **Auto-close Timer**: 80-second timeout for automatic sheet closure
- **Removal Zone**: Drag-to-top gesture for exiting the player

#### Media Catalog (`MediaCatalogScreen`)
Full-screen catalog interface featuring:
- **Reorderable List**: Drag-and-drop program organization
- **Live Indicators**: Visual feedback for currently playing programs
- **Future Content**: "Arriving Soon" section for upcoming features

## 🔧 Technical Implementation

### Live Audio Streaming with Caching

```dart
// Core streaming logic with dual-mode playback
Future<void> playStream({
  required String url,
  required String channelId,
  String? title,
  String? artist,
}) async {
  // Start live stream
  await _playLiveStream(url, title, artist);
  
  // Begin background caching
  await _startCaching(url);
  _startCacheTimer();
}
```

**Key Features**:
- **Live Mode**: Direct stream consumption with real-time position tracking
- **Cache Mode**: File-based playback for seeking and time-shifting
- **Smart Switching**: Automatic mode selection based on user position relative to live
- **FIFO Caching**: Rolling 1-hour cache with automatic cleanup

### Platform Integration

#### Android Media Session
- **File**: `android/app/src/main/kotlin/momra/balady/android/MediaSessionHandler.kt`
- **Features**:
  - Lock screen media controls
  - Notification-based playback controls
  - Android Auto compatibility
  - Background playback support

```kotlin
// Native Android integration
class MediaSessionHandler {
    fun initMediaSession()
    fun updateMediaMetadata(metadata: Map<String, Any>)
    fun setPlaybackState(playing: Boolean, position: Long, duration: Long)
}
```

### State Management Pattern

```dart
// Riverpod-based reactive state management
final streamAudioProvider = ChangeNotifierProvider<StreamAudioProvider>(
  (ref) => StreamAudioProvider(),
);

// Usage in widgets
Consumer(builder: (context, ref, child) {
  final provider = ref.watch(streamAudioProvider);
  return PlayerWidget(
    isPlaying: provider.isPlaying,
    progress: provider.progress,
    // ...
  );
})
```

## 📱 User Interface Components

### Floating Player Controls
- **Drag & Drop**: Repositionable mini-player
- **Shape Morphing**: Expands from pill to circle when edge-docked
- **Momentum Physics**: Natural dragging behavior with velocity-based momentum
- **Removal Gesture**: Drag to top edge to exit player

### Progress Bar System
- **Live Indicator**: Red progress bar when listening live
- **Time Behind**: Orange indicator showing delay from live
- **Seek Functionality**: Tap or drag to navigate cached content
- **Go Live Button**: One-tap return to live broadcast

### Contextual Integration
- **Traffic Awareness**: Context-sensitive radio suggestions
- **Auto-hide Messages**: 15-second timeout for contextual prompts
- **Smart Entry Points**: Integration with navigation and map controls

## 🔌 External Dependencies & Integration Points

### Flutter Packages
```yaml
dependencies:
  just_audio: ^0.10.5              # Core audio playback engine
  just_audio_background: ^0.0.1-beta.17
  flutter_riverpod: 2.6.1          # State management
  path_provider: 2.1.4             # File system access for caching
  http: ^0.13.0                    # HTTP streaming
```

### Internal Integration Points

#### 1. **Entry Point Integration**
- **File**: `lib/entry_point.dart`
- **Integration**: App-wide initialization and provider setup

#### 2. **Dashboard Integration**  
- **File**: `lib/widgets/landing/dashboard/dashboard.dart`
- **Integration**: Stream audio controls embedded in main dashboard

#### 3. **Navigation Integration**
- **File**: `lib/widgets/path_nav/ui/map_controls/path_nav_map_controls.dart`
- **Integration**: `RadioContextualButton` in navigation interface

#### 4. **Routing Integration**
- **File**: `lib/app/auto_route/app_routes.gr.dart`
- **Integration**: Auto-route configuration for media catalog screen

### Asset Dependencies
```dart
// Generated asset references
Assets.icons.svg.audio.pause
Assets.icons.svg.audio.resume
Assets.icons.svg.audio.seekForward
Assets.images.audioPlaceholders.*
```

## 🎯 Key Features

### Live Streaming Capabilities
- ✅ **Real-time Audio Streaming**: Direct HTTP stream consumption
- ✅ **Background Caching**: Automatic 1-hour rolling cache
- ✅ **Seek & Time-shift**: Navigate through cached content
- ✅ **Live Sync**: One-tap return to live broadcast
- ✅ **Smart Buffering**: Intelligent cache management

### User Experience
- ✅ **Floating Mini-player**: Draggable, repositionable controls
- ✅ **Contextual Entry**: Smart radio suggestions based on context
- ✅ **Auto-management**: Automatic cleanup and session handling
- ✅ **Gesture Controls**: Intuitive drag-to-remove functionality
- ✅ **Visual Feedback**: Audio waves, progress indicators, live status

### Platform Integration
- ✅ **Android Media Session**: Lock screen and notification controls
- ✅ **Background Playback**: Continues when app is backgrounded
- ✅ **Native UI Integration**: Platform-consistent media controls
- ✅ **Lifecycle Management**: Proper resource cleanup and reinitialization

## 🚀 Getting Started

### Prerequisites
1. Flutter SDK 3.27.0
3. Valid audio stream URLs

### Basic Usage

```dart
// 1. Initialize the provider (automatically done in entry_point.dart)
final provider = ref.read(streamAudioProvider);

// 2. Load available programs
await provider.getLiveNow();

// 3. Select and play a program
await provider.selectProgram(program);

// 4. Control playback
await provider.togglePlayPause();
await provider.seekForward();
await provider.goLive();
```

### Integration Example

```dart
// Add to your screen
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamAudio(
      child: YourMainContent(),
    );
  }
}
```

## 🔧 Configuration

### Audio Stream URLs
Currently configured with mock data in `channels_data_source.dart`:
- Panorama FM: `https://azuralive.streams.ovh/radio/8160/radio.mp3`
- MBC FM: `https://stream-179.zeno.fm/...`
- MBC Loud: `https://azuralive.streams.ovh/radio/8160/radio.mp3`
- Al Arabiya FM: `https://a2.asurahosting.com:6460/radio.mp3`

### Customization Options
- Cache duration: Modify `_maxCacheDuration` in `AudioService`
- Auto-close timer: Adjust timeout in `StreamAudioScreen`
- UI theming: Update colors and styling in widget files

## 🐛 Troubleshooting

### Common Issues

1. **Audio Not Playing**
   - Check internet connectivity
   - Verify stream URL validity
   - Ensure audio permissions are granted

2. **Cache Issues**
   - Clear temporary directory
   - Restart audio service
   - Check available storage space

3. **UI State Issues**
   - Call `provider.reset()` to reinitialize
   - Check provider lifecycle management
   - Verify Riverpod integration

### Debug Information
Enable debug logging in `AudioService` by uncommenting `debugPrint` statements.

## 📝 Development Notes

### Code Style
- Follow Flutter/Dart conventions
- Use Riverpod for all state management
- Implement proper error handling and loading states
- Add comprehensive documentation for public APIs

---

**Note**: This feature is currently in active development. Some functionality may change as requirements evolve. Always refer to the latest code for the most up-to-date implementation details.
