import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/_shared_features/auth_quick_access_biometric_widget/widgets/auth_quick_access_biometric_widget.dart';
import 'package:balady_plus/app/features/_shared_features/notifications_cell/widgets/notifications_setting_cell.dart';
import 'package:balady_plus/app/features/accecipilities/balady_theme_controller.dart';
import 'package:balady_plus/app/features/accecipilities/presentation/pages/accessibility_settings_page.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/widgets/profile/language_picker.dart';
import 'package:provider/provider.dart' as p; // Add this import
import 'package:urbi_utils/urbi_utils.dart';

import '../../_generated/assets/assets.gen.dart';

@RoutePage()
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  static const showFlags = false;

  @override
  Widget build(BuildContext context) {
    final isDGA =
        context.read<ThemeController>().currentTheme == BaladyAppThemes.darkDGA ||
            context.read<ThemeController>().currentTheme == BaladyAppThemes.lightDGA;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: ref.watch(uiDirectionProvider),
        child: Material(
          color: context.colors.backgroundSurface4,
          child: Padding(
            padding: const EdgeInsets.only(top: Spacing.$4x),
            child: Scaffold(
              appBar: BaladyTopBar.iconAndText(
                systemUiOverlayStyle: SystemUiOverlayStyle.dark,
                title: context.l10n.settings,
                colorEnabled: context.colors.accentDefault,
                leading: ActionModel(
                  onPressed: () => context.router.pop(),
                  icon: SystemIcons.arrowCornerLeftLarge,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(Spacing.$4x),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // I added this check here because those widgets take up zero space and we can not determine if
                    // there is any data and decide whether we need add spacers after them
                    if (CommonProperties.isLoggedInMunicipality) ...[
                      ContentWrapper(
                        color: isDGA ? context.colors.accentSecondarySoft : context.colors.backgroundSurface1,
                        children: const [NotificationsSettingCell()],
                      ),
                      ContentWrapper(
                        color: isDGA ? context.colors.accentSecondarySoft : context.colors.backgroundSurface1,
                        children: const [AuthQuickAccessBiometricWidget()],
                      ),
                    ],
                    ContentWrapper(
                      color: isDGA ? context.colors.accentSecondarySoft : context.colors.backgroundSurface1,
                      children: [
                        ContentRow(
                          onTap: () => context.router.push(const DarkMapRoute()),
                          options: ContentRowOptions(
                            title: context.l10n.darkMode,
                            leadingIcon: AppIcons(
                              iconData: GeneralIcons.darkMode,
                              color: context.colors.accentDefault,
                              size: 24,
                            ),
                            titleStyle: context.textStyle.text.copyWith(color: context.colors.foregroundDefault),
                            actionWidget: ContentRowActionOptions(
                              actionIcon: AppIcons(
                                iconData: SystemIcons.arrowCornerRightLarge,
                                color: context.colors.foregroundSoft,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ContentWrapper(
                      color: isDGA ? context.colors.accentSecondarySoft : context.colors.backgroundSurface1,
                      children: [
                        ContentRow(
                          onTap: () => context.router.push(
                            NavigatorSettingsRoute(showDarkModeSection: false),
                          ),
                          leading: AppIcons(
                            iconData: TransportIcons.locationFullLTR,
                            color: context.colors.accentDefault,
                            size: 24,
                          ),
                          text: ContentRowTextOptions(
                            title: context.l10n.navigatorSettings,
                          ),
                          trailing: ContentRowTextTrailingOptions(
                            icon: SystemIcons.arrowCornerRightLarge,
                            iconColor: context.colors.foregroundSoft,
                          ),
                        ),
                      ],
                    ),
                    ContentWrapper(
                      color: isDGA ? context.colors.accentSecondarySoft : context.colors.backgroundSurface1,
                      children: [
                        ContentRow(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AccessibilitySettingsPage(),
                            ),
                          ),
                          options: ContentRowOptions(
                            leadingIcon: AppIcons(
                              iconData: GeneralIcons.accessibilityWheels,
                              color: context.colors.accentDefault,
                              size: 24,
                            ),
                            title: context.l10n.accessibility,
                            actionWidget: ContentRowActionOptions(
                              actionIcon: AppIcons(
                                iconData: SystemIcons.arrowCornerRightLarge,
                                color: context.colors.foregroundSoft,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final language = ref.watch(appLanguageProvider);
                        return ContentWrapper(
                          color: isDGA ? context.colors.accentSecondarySoft : context.colors.backgroundSurface1,
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
                  ].insertBetween(const SizedBox(height: Spacing.$4x)).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? leadingIcon(Language language) => showFlags
      ? SvgPicture.asset(
          switch (language) {
            Language.arabic => Assets.icons.svg.saFlag.keyName,
            Language.english => Assets.icons.svg.ukFlag.keyName,
          },
          height: 16,
          width: 22,
        )
      : AppIcons(
          iconData: GeneralIcons.web,
          color: context.colors.accentDefault,
          size: 24,
        );
}
