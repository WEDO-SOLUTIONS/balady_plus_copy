import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/map/sound_settings.dart';

class SoundControl extends ConsumerStatefulWidget {
  const SoundControl({super.key});

  @override
  ConsumerState<SoundControl> createState() => _SoundControlState();
}

class _SoundControlState extends ConsumerState<SoundControl> {
  // Remembers the last active (non-muted) index so toggling back restores it.
  int _lastNonMutedIndex = 2; // SoundToggleType.all

  @override
  Widget build(BuildContext context) {
    final soundSettings = ref.watch(soundSettingsProvider);
    final soundNotifier = ref.read(soundSettingsProvider.notifier);
    final isMuted = soundSettings.voiceInstructionIndex == 0;

    if (!isMuted) {
      _lastNonMutedIndex = soundSettings.voiceInstructionIndex;
    }

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final iconData = isMuted ? SystemIcons.notificationFill:SystemIcons.notification;

    return MapButton(
      onTap: () {
        if (isMuted) {
          soundNotifier.toggleVoiceInstruction(currentVoiceInstruction: _lastNonMutedIndex);
        } else {
          soundNotifier.toggleVoiceInstruction(currentVoiceInstruction: 0);
        }
      },
      child: iconData.icon(color: context.colors.foregroundDefault),
    );
  }
}
