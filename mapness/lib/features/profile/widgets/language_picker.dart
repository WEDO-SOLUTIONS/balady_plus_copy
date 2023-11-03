import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/config/package_config.dart';
import '../../common/providers/app_language.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        LanguageRow(language: Language.arabic),
        LanguageRow(language: Language.english),
      ],
    );
  }
}

class LanguageRow extends ConsumerWidget {
  const LanguageRow({
    super.key,
    required this.language,
  });

  final Language language;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(appLanguageProvider);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          ref.read(appLanguageProvider.notifier).update(language);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                currentLanguage == language
                    ? "assets/icons/svg/ic_radio_on.svg"
                    : "assets/icons/svg/ic_radio_off.svg",
                height: 24,
                width: 24,
                package: PackageConfig.packageName,
              ),
              const Spacer(),
              Text(
                language.title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  height: 1.4,
                  color: const Color(0xFF1E2A36),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              SvgPicture.asset(
                language.icon,
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
