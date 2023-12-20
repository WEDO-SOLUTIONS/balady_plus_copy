import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/profile/widgets/dark_mode_cell.dart';
import 'package:mapness/_features/profile/widgets/expandable_cell.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';

import '../widgets/language_picker.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          color: Colors.white,
          child: ListView(
            children: [
              const SizedBox(
                width: 12,
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 40,
                      ),
                      const Spacer(),
                      Text(
                        context.l10n.settings,
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .accentM
                            .copyWith(color: const Color(0xFF1E2A36)),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Material(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFFF5F7FA),
                          child: InkWell(
                            onTap: () {
                              context.pop();
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: SvgPicture.asset(
                                'assets/icons/svg/ic_chevron_right.svg',
                                height: 24,
                                width: 24,
                                package: PackageConfig.packageName,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF1E2A36),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Consumer(
                builder: (context, ref, child) {
                  final language = ref.watch(appLanguageProvider);

                  return ExpandableCell(
                    title: context.l10n.language,
                    subtitle: language.title,
                    count: 2,
                    icon: "assets/icons/svg/ic_profile_lang.svg",
                    content: const LanguagePicker(),
                  );
                },
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Spacer(),
                    Text(
                      context.l10n.chooseTheLanguageOfAll,
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .textXS
                          .copyWith(
                              color: const Color(0xFF1E2A36).withOpacity(0.36)),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const DarkModeCell(),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Spacer(),
                    Text(
                      context.l10n.changeTheColorSchemeOfAnApp,
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .textXS
                          .copyWith(
                              color: const Color(0xFF1E2A36).withOpacity(0.36)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
