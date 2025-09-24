import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/features/_shared_features/auth_quick_access_biometric_widget/widgets/auth_quick_access_biometric_widget.dart';
import 'package:balady_plus/app/features/_shared_features/notifications_cell/widgets/notifications_setting_cell.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/widgets/profile/language_picker.dart';

import '../../_generated/assets/assets.gen.dart';

@RoutePage()
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  // According to task BALADY-416 to hide flags we temporary hide it with boolean flag
  // We don't delete it because this goes against the design of this feature
  static const showFlags = false;

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Directionality(
          textDirection: ref.watch(uiDirectionProvider),
          child: Material(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: Spacing.$4x),
              child: Scaffold(
                appBar: BaladyTopBar.iconAndText(
                  systemUiOverlayStyle: SystemUiOverlayStyle.dark,
                  title: context.l10n.settings,
                  colorEnabled: context.colors.accentDefault,
                  leading: ActionModel(
                    onPressed: () => context.router.popForced(),
                    icon: SystemIcons.arrowCornerLeftLarge,
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    left: 12,
                    right: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContentWrapper(
                        color: context.colors.backgroundSurface4,
                        children: const [
                          NotificationsSettingCell(),
                        ],
                      ),
                      const SizedBox(height: Spacing.$4x),
                      ContentWrapper(
                        color: context.colors.backgroundSurface4,
                        children: const [
                          AuthQuickAccessBiometricWidget(),
                        ],
                      ),
                      const SizedBox(height: Spacing.$4x),
                      Consumer(
                        builder: (context, ref, child) {
                          final language = ref.watch(appLanguageProvider);
                          return ContentWrapper(
                            color: context.colors.backgroundSurface4,
                            children: [
                              ContentRowExpandable(
                                options: ContentRowOptions(
                                  title: context.l10n.language,
                                  subtitle: language.title,
                                  leadingIcon: leadingIcon(language),
                                ),
                                content: const LanguagePicker(),
                                expandIconColor: context.colors.foregroundSoft,
                              ),
                            ],
                          );
                        },
                      ),
                      Spacing.$2x.heightBox,
                      ContentWrapper(
                        color: context.colors.backgroundSurface4,
                        children: [
                          ContentRow(
                            onTap: () => context.router.push(const DarkMapRoute()),
                            options: ContentRowOptions(
                              leadingIcon: AppIcons(
                                iconData: GeneralIcons.darkMode,
                                color: context.colors.accentDefault,
                                size: 24,
                              ),
                              title: context.l10n.darkMap,
                              actionWidget: ContentRowActionOptions(
                                actionIcon: AppIcons(
                                  iconData: SystemIcons.arrowCornerRightLarge,
                                  color: context.colors.foregroundSoft,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Spacing.$2x.heightBox,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget? leadingIcon(Language language) => showFlags
      ? SvgPicture.asset(
          switch (language) {
            Language.arabic => Assets.icons.svg.saFlag.keyName,
            Language.english => Assets.icons.svg.ukFlag.keyName,
          },
          height: 16,
          width: 22,
        )
      : SvgPicture.asset(
          color: context.colors.accentDefault,
          Assets.icons.svg.icLanguageChange.keyName,
          height: 24,
          width: 24,
        );
}
