import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';

import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/dark_mode.dart';

import '../../../shared/config/package_config.dart';

class DarkModeCell extends ConsumerWidget {
  const DarkModeCell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);

    return Directionality(
      textDirection: ref.watch(uiDirectionProvider),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(8),
          color: context.color.surface_base_secondary,
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
                    SvgPicture.asset(
                      "assets/icons/svg/ic_profile_dark.svg",
                      height: 24,
                      width: 24,
                      package: PackageConfig.packageName,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Text(
                        context.l10n.darkMap,
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .textM
                            .copyWith(color: context.color.text_and_icons_base_primary),
                      ),
                    ),
                    const Spacer(),
                    IgnorePointer(
                      child: CupertinoSwitch(
                        onChanged: (bool value) {},
                        value: darkMode,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
