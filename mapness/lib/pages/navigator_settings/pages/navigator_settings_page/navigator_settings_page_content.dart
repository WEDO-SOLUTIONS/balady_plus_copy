import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/core/utils/constants.dart';
import 'package:balady_uikit/gen/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart' as mappness;
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/free_roam/free_roam_autostart_settings.dart';
import 'package:mapness/features/navigation_cursor/navigation_cursor.dart';
import 'package:mapness/features/navigation_cursor/navigation_cursor_controller.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/navigator_auto_enable_parking.dart';
import 'package:mapness/shared/providers/map/navigator_route_settings.dart';
import 'package:mapness/shared/providers/map/navigator_speed_cameras_settings.dart';
import 'package:urbi_utils/urbi_utils.dart';

class NavigatorSettingsPageContent extends ConsumerWidget {
  const NavigatorSettingsPageContent({required this.showDarkModeSection, super.key});
  final bool showDarkModeSection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigatorCamerasSettingsNotifier = ref.read(navigatorSpeedCamerasSettingsProvider.notifier);
    final navigatorRouteSettingsNotifier = ref.read(navigatorRouteSettingsProvider.notifier);
    final betterRouteSettingsNotifier = ref.read(betterRouteSuggestionsProvider.notifier);
    final cardColor = context.profileCardColor;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ContentColumn(
              headerTitle: context.l10n.navigation,
              content: [
                ContentWrapper(
                  color: cardColor,
                  children: [
                    Consumer(
                      builder: (context, ref, _) {
                        final navigatorRouteSettings = ref.watch(navigatorRouteSettingsProvider);

                        return ContentRow(
                          onToggle: (_) => navigatorRouteSettingsNotifier.toggleAvoidTollRoads(),
                          options: ContentRowOptions(
                            title: context.l10n.avoidTollRoads,
                            dividerEnabled: true,
                            titleStyle: context.textStyle.text.copyWith(color: context.colors.foregroundDefault),
                            actionWidget: ContentRowActionOptions(
                              enabledToggle: true,
                              toggleInitialValue: navigatorRouteSettings.avoidTollRoads,
                            ),
                          ),
                        );
                      },
                    ),
                    Consumer(
                      builder: (context, ref, _) {
                        final navigatorRouteSettings = ref.watch(navigatorRouteSettingsProvider);
                        return ContentRow(
                          onToggle: (_) => navigatorRouteSettingsNotifier.toggleAvoidUnpavedRoads(),
                          options: ContentRowOptions(
                            title: context.l10n.avoidUnpavedRoads,
                            dividerEnabled: true,
                            titleStyle: context.textStyle.text.copyWith(color: context.colors.foregroundDefault),
                            actionWidget: ContentRowActionOptions(
                              enabledToggle: true,
                              toggleInitialValue: navigatorRouteSettings.avoidUnpavedRoads,
                            ),
                          ),
                        );
                      },
                    ),
                    Consumer(
                      builder: (context, ref, _) {
                        final betterRouteSettings = ref.watch(betterRouteSuggestionsProvider);
                        return ContentRow(
                          onToggle: (_) => betterRouteSettingsNotifier.toggle(),
                          options: ContentRowOptions(
                            title: context.l10n.suggestRouteBetter,
                            dividerEnabled: true,
                            titleStyle: context.textStyle.text.copyWith(color: context.colors.foregroundDefault),
                            actionWidget: ContentRowActionOptions(
                              enabledToggle: true,
                              toggleInitialValue: betterRouteSettings,
                            ),
                          ),
                        );
                      },
                    ),
                    Consumer(
                      builder: (context, ref, _) {
                        final autoEnableParking = ref.watch(navigatorAutoEnableParkingProvider) ?? false;
                        return ContentRow(
                          onToggle: (_) => ref
                              .read(navigatorAutoEnableParkingProvider.notifier)
                              .toggleAutoEnableParking(value: !autoEnableParking),
                          options: ContentRowOptions(
                            title: context.l10n.automaticParkingLayer,
                            dividerEnabled: true,
                            titleStyle: context.textStyle.text.copyWith(color: context.colors.foregroundDefault),
                            actionWidget: ContentRowActionOptions(
                              enabledToggle: true,
                              toggleInitialValue: autoEnableParking,
                            ),
                          ),
                        );
                      },
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final autorun = ref.watch(freeRoamAutostartSettingsProvider.notifier).isEnabled;

                        return ContentRow(
                          onToggle: (_) => ref.read(freeRoamAutostartSettingsProvider.notifier).toggleAutostart(),
                          options: ContentRowOptions(
                            title: context.l10n.autorunNavigator,
                            titleStyle: context.textStyle.text.copyWith(color: context.colors.foregroundDefault),
                            subtitle: context.l10n.automaticallyLaunchNavigator,
                            subtitleMaxlines: 2,
                            actionWidget: ContentRowActionOptions(enabledToggle: true, toggleInitialValue: autorun),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            if (showDarkModeSection)
              ContentColumn(
                headerTitle: context.l10n.mapStyle,
                content: [
                  ContentRow(
                    onTap: () => context.router.push(const DarkMapRoute()),
                    options: ContentRowOptions(
                      wrapperColor: cardColor,
                      wrapperEnabled: true,
                      title: context.l10n.darkMap,
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
            ContentColumn(
              headerTitle: context.l10n.soundAndAlerts,
              content: [
                ContentRow(
                  onTap: () => context.router.push(const SoundSettingsRoute()),
                  options: ContentRowOptions(
                    titleStyle: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundDefault),
                    wrapperColor: cardColor,
                    wrapperEnabled: true,
                    leadingIcon: mappness.Assets.icons.svg.icNotification.svg(color: context.colors.accentDefault),
                    title: context.l10n.soundSettings,
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
            ContentColumn(
              headerTitle: context.l10n.roadEvents,
              content: [
                Consumer(
                  builder: (context, ref, _) {
                    final navigatorCamerasSettings = ref.watch(navigatorSpeedCamerasSettingsProvider);

                    return ContentRow(
                      options: ContentRowOptions(
                        wrapperColor: cardColor,
                        wrapperEnabled: true,
                        leadingIcon: Assets.icons.maneuver.roadEventCam.svg(package: packageName, fit: BoxFit.fill),
                        title: context.l10n.speedCameras,
                        titleStyle: context.textStyle.text.copyWith(color: context.colors.foregroundDefault),
                        actionWidget: ContentRowActionOptions(
                          enabledToggle: true,
                          toggleInitialValue: navigatorCamerasSettings,
                        ),
                      ),
                      onToggle: (val) => navigatorCamerasSettingsNotifier.toggle(),
                    );
                  },
                ),
              ],
            ),
            ContentColumn(
              // Reuse the single Localazy string for both the section-header
              // (upper case per existing conventions like `soundAndAlerts:
              // "SOUND AND ALERTS"`) and the picker page title.
              headerTitle: context.l10n.cursorsNavigatorCustomization.toUpperCase(),
              content: [
                Consumer(
                  builder: (context, ref, _) {
                    final active = ref.watch(navigationCursorControllerProvider).active;
                    return ContentRow(
                      onTap: () => context.router.push(const CursorsRoute()),
                      options: ContentRowOptions(
                        wrapperColor: cardColor,
                        wrapperEnabled: true,
                        title: context.l10n.cursors,
                        titleStyle: context.textStyle.text.copyWith(color: context.colors.foregroundDefault),
                        // BALADY-3761: value only — regular weight, no icon
                        // next to the selected cursor name (Figma 2287-3277).
                        actionWidget: ContentRowActionOptions(
                          actionText: active.title(context),
                          actionTextStyle: context.textStyles.bodySmallRegular.copyWith(
                            color: context.colors.foregroundSoft,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ].insertBetween(Spacing.$4x.heightBox).toList(),
        ),
      ),
    );
  }
}
