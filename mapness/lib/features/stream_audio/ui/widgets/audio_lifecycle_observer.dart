import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';

/// Widget that observes app lifecycle changes and handles audio playback accordingly
class AudioLifecycleObserver extends ConsumerStatefulWidget {
  final Widget child;

  const AudioLifecycleObserver({
    required this.child,
    super.key,
  });

  @override
  ConsumerState<AudioLifecycleObserver> createState() => _AudioLifecycleObserverState();
}

class _AudioLifecycleObserverState extends ConsumerState<AudioLifecycleObserver> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Notify the audio provider about lifecycle changes
    ref.read(streamAudioProvider).handleAppLifecycleChange(state);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
