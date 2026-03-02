import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/providers/map/dgis_packages.dart';
import 'package:mapness/shared/providers/navigator_voice.dart';
import 'package:mapness/shared/utils/text_utils/voice_settings_utils.dart';

class VoiceRowWidget extends ConsumerWidget {
  final PackageMessage package;

  const VoiceRowWidget({required this.package, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedVoice = ref.watch(navigatorVoiceProvider);

    final progress = ref.watch(packageProgressProvider(package));
    final packageInfo = ref.watch(packageInfoProvider(package));

    ref.listen(packageProgressProvider(package), (prev, next) {
      if (next == 100) {
        ref.read(navigatorVoiceProvider.notifier).update(package.id);
      }
    });

    return ContentRow(
      onTap: () {
        if (packageInfo.updateStatus != PackageUpdateStatusMessage.inProgress) {
          if (packageInfo.installed) {
            ref.read(navigatorVoiceProvider.notifier).update(package.id);
          } else {
            ref.read(voicePackagesProvider.notifier).install(package);
          }
        }
      },
      options: ContentRowOptions(
        padding: const EdgeInsets.symmetric(vertical: Spacing.$2x, horizontal: Spacing.$4x),
        wrapperColor: context.colors.backgroundSurface1,
        wrapperEnabled: true,
        leadingIcon: selectedVoice == package.id ? Assets.icons.svg.icRadioOn.svg() : Assets.icons.svg.icRadioOff.svg(),
        title: localizeVoicePackageName(context, packageInfo.name),
        titleStyle: context.textStyles.bodyLargeRegular.copyWith(
          color: packageInfo.installed ? context.colors.foregroundDefault : context.colors.foregroundDisabled,
        ),
        customActionWidget: Builder(
          builder: (context) {
            if (packageInfo.updateStatus == PackageUpdateStatusMessage.inProgress) {
              return Column(
                children: [
                  Loading(
                    value: (progress / 100).toDouble(),
                    title: '$progress%',
                    color: context.colors.accentDefault,
                    backgroundColor: context.colors.accentDefault.withOpacity(0.1),
                  ),
                ],
              );
            } else if (selectedVoice == package.id) {
              return Padding(
                padding: const EdgeInsets.only(right: Spacing.$3x),
                child: Icon(SystemIcons.checkmark, color: context.colors.accentDefault),
              );
            } else if (packageInfo.installed) {
              return Spacing.$6x.heightBox;
            } else {
              return Padding(
                padding: const EdgeInsets.only(right: Spacing.$3x),
                child: Icon(SystemIcons.download, color: context.colors.foregroundSoft),
              );
            }
          },
        ),
      ),
    );
  }
}
