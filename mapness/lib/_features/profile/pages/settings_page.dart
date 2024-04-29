import 'package:balady_plus/app/features/_shared_features/notifications_cell/widgets/notifications_setting_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/debug_state.dart';
import 'package:mapness/widgets/profile/dark_mode_cell.dart';
import 'package:mapness/widgets/profile/expandable_cell.dart';
import 'package:mapness/widgets/profile/language_picker.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  int tapsToGo = 7;

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Directionality(
          textDirection: ref.watch(uiDirectionProvider),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Material(
                            borderRadius: BorderRadius.circular(8),
                            color: context.color.surfaceBaseSecondary,
                            child: InkWell(
                              onTap: () {
                                context.pop();
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: SvgPicture.asset(
                                  ref.watch(uiDirectionProvider) ==
                                          TextDirection.ltr
                                      ? 'assets/icons/svg/ic_chevron_left.svg'
                                      : 'assets/icons/svg/ic_chevron_right.svg',
                                  height: 24,
                                  width: 24,
                                  package: PackageConfig.packageName,
                                  colorFilter: ColorFilter.mode(
                                    context.color.textAndIconsBasePrimary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            setState(() {
                              tapsToGo -= 1;
                            });
                            if (tapsToGo == 0) {
                              ref.read(debugStateProvider.notifier).enable();
                            }
                          },
                          child: Text(
                            context.l10n.settings,
                            style: context.textStyle.accent.copyWith(
                                color: context.color.textAndIconsBasePrimary),
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(
                          width: 40,
                        ),
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
                      icon: 'assets/icons/svg/ic_profile_lang.svg',
                      content: const LanguagePicker(),
                    );
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        context.l10n.chooseTheLanguageOfAll,
                        style: context.textStyle.caption.copyWith(
                          color: context.color.textAndIconsBasePrimary
                              .withOpacity(0.36),
                        ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        context.l10n.changeTheColorSchemeOfAnApp,
                        style: context.textStyle.caption.copyWith(
                          color: context.color.textAndIconsBasePrimary
                              .withOpacity(0.36),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),

               //hamed hide nofication settings
                const NotificationsSettingCell()
              ],
            ),
          ),
        ),
      );
}
