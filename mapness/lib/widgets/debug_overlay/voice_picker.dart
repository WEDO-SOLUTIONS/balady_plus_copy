import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/providers/map/dgis_packages.dart';
import 'package:mapness/shared/providers/navigator_voice.dart';

class VoicePicker extends ConsumerWidget {
  const VoicePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voicePackages = ref.watch(voicePackagesProvider);

    return Column(
      children: voicePackages.map((e) => VoiceRow(package: e.packageMessage)).toList(),
    );
  }
}

class VoiceRow extends ConsumerWidget {
  const VoiceRow({
    required this.package,
    super.key,
  });

  static const installed = 'Installed';
  static const notInstalled = 'Not installed';
  static const updateAvailable = ' · Update available';

  final PackageMessage package;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(packageProgressProvider(package));
    final packageInfo = ref.watch(packageInfoProvider(package));
    final selectedVoice = ref.watch(navigatorVoiceProvider);

    ref.listen(packageProgressProvider(package), (prev, next) {
      if (next == 100) {
        ref.read(navigatorVoiceProvider.notifier).update(package.id);
      }
    });

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          if (packageInfo.installed) {
            ref.read(navigatorVoiceProvider.notifier).update(package.id);
          } else {
            ref.read(voicePackagesProvider.notifier).install(package);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                package.id == selectedVoice ? Assets.icons.svg.icRadioOn.keyName : Assets.icons.svg.icRadioOff.keyName,
                height: 24,
                width: 24,
              ),
              const SizedBox(
                width: 12,
              ),
              if (packageInfo.updateStatus == PackageUpdateStatusMessage.inProgress)
                Text(
                  '$progress%',
                  style: context.textStyle.caption.copyWith(color: context.color.textAndIconsBasePrimary),
                ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    packageInfo.name,
                    style: context.textStyle.text.copyWith(color: context.color.textAndIconsBasePrimary),
                  ),
                  Text(
                    '${packageInfo.installed ? installed : notInstalled}'
                    '${packageInfo.hasUpdate ? updateAvailable : ''}',
                    style: context.textStyle.caption.copyWith(
                      color: packageInfo.installed ? context.color.strokeAccent : NonThemeColor.color1,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 12,
              ),
              SvgPicture.asset(
                Assets.icons.svg.icProfileLang.keyName,
                height: 24,
                width: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
