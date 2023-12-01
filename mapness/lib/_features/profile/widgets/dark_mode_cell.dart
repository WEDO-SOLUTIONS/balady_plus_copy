import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/dark_mode.dart';

import '../../../shared/config/package_config.dart';

class DarkModeCell extends ConsumerWidget {
  const DarkModeCell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            ref.read(darkModeProvider.notifier).toggle();
          },
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 48,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: IgnorePointer(
                      child: CupertinoSwitch(
                        onChanged: (bool value) {},
                        value: darkMode,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Text(
                      context.l10n.darkMode,
                      style: Theme.of(context).extension<ThemeTextStyles>()!.textM.copyWith(color: const Color(0xFF1E2A36)),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  SvgPicture.asset(
                    "assets/icons/svg/ic_profile_dark.svg",
                    height: 24,
                    width: 24,
                    package: PackageConfig.packageName,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
