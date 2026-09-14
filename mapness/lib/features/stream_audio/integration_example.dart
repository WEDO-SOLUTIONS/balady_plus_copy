// Example of how to integrate the AudioLifecycleObserver in your main app

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stream_audio/ui/widgets/audio_lifecycle_observer.dart';

/// Example integration of AudioLifecycleObserver
///
/// This should be placed at the root of your app to ensure
/// proper audio lifecycle management throughout the app.
class ExampleAppWithAudioLifecycle extends StatelessWidget {
  const ExampleAppWithAudioLifecycle({super.key});

  @override
  Widget build(BuildContext context) => const ProviderScope(
    child: AudioLifecycleObserver(
      child: MaterialApp(
        title: 'Balady Audio App',
        home: ExampleHomePage(),
      ),
    ),
  );
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Audio Lifecycle Example'),
    ),
    body: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Audio Lifecycle Observer is now active!',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Text(
            'The app will now properly handle:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('• Phone call interruptions'),
          Text('• Background/foreground transitions'),
          Text('• Audio focus changes'),
          Text('• Automatic recovery from audio issues'),
        ],
      ),
    ),
  );
}
