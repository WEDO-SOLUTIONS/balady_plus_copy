## Radio Contextual Button & Message Banner – Integration Guide

This document explains how the Message Banner attached to `radio_contextual_button.dart` works and how other modules can trigger it via the `stream_audio_prov.dart` provider.

### What it is
- **RadioContextualButton**: A small action button that opens the audio player.
- **Message Banner**: A contextual, dismissible banner rendered next to the button. It appears only when the provider exposes a visible message and there is no selected channel (i.e., no stream currently active).

### Files
- UI widget: `mapness/lib/features/stream_audio/ui/widgets/radio_contextual_button.dart`
- Provider: `mapness/lib/features/stream_audio/ui/providers/stream_audio_prov.dart`

### High‑level behavior
- The banner shows when `StreamAudioProvider.isContextualMessageVisible == true`.
- Banner title/subtitle are read from `StreamAudioProvider.contextualMessageTitle` and `StreamAudioProvider.contextualMessageSubtitle`.
- The banner auto-hides after 15 seconds unless manually hidden.
- The banner renders only if `selectedChannel == null` (no active channel). If a channel is selected, the banner stays hidden to avoid overlap with the player state.
- Banner actions:
  - Check icon: hides the banner and opens the audio player flow.
  - Close icon: hides the banner only.

### How other modules trigger the banner
Any feature/module can trigger the banner by interacting with the provider. The required steps are:
1) Set the title and subtitle on the provider
2) Call `showContextualMessage()`

Recommended call order (set text first, then show):

```dart
final notifier = ref.read(streamAudioProvider.notifier);
notifier
  ..contextualMessageTitle = 'Stuck in traffic'
  ..contextualMessageSubtitle = 'Tune into live radio'
  ..showContextualMessage();
```

To hide programmatically:

```dart
ref.read(streamAudioProvider.notifier).hideContextualMessage();
```

Notes:
- If you call `showContextualMessage()` without setting title/subtitle, the widget will fall back to defaults: title "Catch the latest" and subtitle "Tune into live radio".
- The provider already manages a 15‑second auto‑hide timer; repeated calls will reset the timer.

### Provider API surface used by the banner
- `bool get isContextualMessageVisible`
- `String? get contextualMessageTitle`
- `String? get contextualMessageSubtitle`
- `set contextualMessageTitle(String? value)`
- `set contextualMessageSubtitle(String? value)`
- `void showContextualMessage()`
- `void hideContextualMessage()`

For local testing there is also:
- `void mockUserInTraffic()` – sets a traffic message and shows the banner

### Where the logic lives in code
- Visibility and texts are driven by `StreamAudioProvider` in `stream_audio_prov.dart`.
- The UI checks `provider.isContextualMessageVisible` and reads title/subtitle in `radio_contextual_button.dart`.
- The action buttons in the banner call provider methods to hide (and optionally open the player).

### Integration examples

Within a Riverpod Consumer widget:

```dart
class SomeFeatureWidget extends ConsumerWidget {
  const SomeFeatureWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onTrafficDetected() {
      final notifier = ref.read(streamAudioProvider.notifier);
      notifier
        ..contextualMessageTitle = 'Heavy traffic ahead'
        ..contextualMessageSubtitle = 'Listen to live updates'
        ..showContextualMessage();
    }

    return const SizedBox.shrink();
  }
}
```

From imperative code with access to `WidgetRef` or a `ProviderContainer`:

```dart
final container = ProviderScope.containerOf(context, listen: false);
final notifier = container.read(streamAudioProvider.notifier);
notifier
  ..contextualMessageTitle = 'Something happened'
  ..contextualMessageSubtitle = 'Tap to tune in'
  ..showContextualMessage();
```

### UX details and constraints
- The banner is 200 px wide and overlays next to the button with a subtle shadow.
- It auto-hides after 15 seconds unless dismissed earlier.
- It is intentionally suppressed when a channel is selected to reduce UI noise during active playback.

### Troubleshooting
- Banner not showing? Confirm:
  - `RadioContextualButton` is present in the UI where you expect it.
  - You set title/subtitle before calling `showContextualMessage()`.
  - No channel is currently selected (`selectedChannel == null`). The banner does not show while the player is active.
  - The provider instance you updated is the same one observed by the widget (i.e., within the same `ProviderScope`).

### Quick checklist for integrators
- Set `contextualMessageTitle` and `contextualMessageSubtitle`.
- Call `showContextualMessage()`.
- Optionally call `hideContextualMessage()` when your context ends.


