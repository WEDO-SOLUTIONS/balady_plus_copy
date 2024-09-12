import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

extension SoundTypeExtension on SoundToggleType {
  String mapVoiceInstructionsToTitle(BuildContext context) => switch (this) {
        SoundToggleType.all => context.l10n.announcedEvents,
        SoundToggleType.important => context.l10n.onlyImportantManeuvers,
        SoundToggleType.none => context.l10n.voiceIsOff,
      };
}
