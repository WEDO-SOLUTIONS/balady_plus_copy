import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/providers/map/dgis_packages.dart';
import 'package:mapness/shared/providers/navigator_voice.dart';

class VoicePicker extends ConsumerWidget {
  const VoicePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voicePackages = ref.watch(voicePackagesProvider);

    return Column(
      children: voicePackages.map((e) => VoiceRow(package: e)).toList(),
    );
  }
}

class VoiceRow extends ConsumerWidget {
  const VoiceRow({
    super.key,
    required this.package,
  });

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
                package.id == selectedVoice
                    ? "assets/icons/svg/ic_radio_on.svg"
                    : "assets/icons/svg/ic_radio_off.svg",
                height: 24,
                width: 24,
                package: PackageConfig.packageName,
              ),
              const SizedBox(
                width: 12,
              ),
              if (packageInfo.updateStatus ==
                  PackageUpdateStatusMessage.inProgress)
                Text(
                  "$progress%",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xB21E2A36),
                    height: 1.4,
                  ),
                ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    packageInfo.name,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      height: 1.4,
                      color: const Color(0xFF1E2A36),
                    ),
                  ),
                  Text(
                    "${packageInfo.installed ? "Installed" : "Not installed"}${packageInfo.hasUpdate ? " · Update available" : ""}",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: packageInfo.installed
                          ? const Color(0xFF4CA5B4)
                          : const Color(0xFFD14733),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 12,
              ),
              SvgPicture.asset(
                "assets/icons/svg/ic_profile_lang.svg",
                height: 24,
                width: 24,
                package: PackageConfig.packageName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
