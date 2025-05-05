import 'package:flutter/widgets.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

String localizeVoicePackageName(BuildContext context, String? name) {
  if (name == null) {
    return '';
  }
  return switch (name) {
    'Saud' => context.l10n.voicePackageSaud,
    'Sara' => context.l10n.voicePackageSara,
    'Daniel' => context.l10n.voicePackageDaniel,
    'Jennifer' => context.l10n.voicePackageJennifer,
    _ => name,
  };
}
