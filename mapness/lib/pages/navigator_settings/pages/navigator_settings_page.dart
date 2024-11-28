import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/core/utils/constants.dart';
import 'package:balady_uikit/gen/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/app/routes/dark_map.dart';
import 'package:mapness/app/routes/sound_settings.dart';
import 'package:mapness/features/free_roam/free_roam_autostart_settings.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/navigator_route_settings.dart';
import 'package:mapness/shared/providers/map/navigator_speed_cameras_settings.dart';
import 'package:urbi_utils/urbi_utils.dart';

class NavigatorSettingsPage extends ConsumerWidget {
  const NavigatorSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigatorCamerasSettingsNotifier = ref.read(navigatorSpeedCamerasSettingsProvider.notifier);
    final navigatorRouteSettingsNotifier = ref.read(navigatorRouteSettingsProvider.notifier);
    final betterRouteSettingsNotifier = ref.read(betterRouteSuggestionsProvider.notifier);

    final colorsV2 = context.colorsV2;
    final l10n = context.l10n;
    final color = context.color;
    final textStyleV3 = context.textStyleV3;
    final textStyle = context.textStyle;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: ref.watch(uiDirectionProvider),
        child: Material(
          color: colorsV2.backgroundSurface4,
          child: Padding(
            padding: const EdgeInsets.only(top: Spacing.$4x),
            child: Scaffold(
              appBar: BaladyTopBar.iconAndText(
                systemUiOverlayStyle: SystemUiOverlayStyle.dark,
                title: l10n.navigatorSettings,
                textStyle: textStyleV3.bodyLargeSemiBold.copyWith(
                  color: colorsV2.foregroundDefault,
                ),
                leading: ActionModel(
                  onPressed: () => context.pop(),
                  icon: SystemIcons.arrowCornerLeftLarge,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ContentColumn(
                      headerTitle: l10n.navigation,
                      content: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(RadiusBorder.l),
                            color: color.surfaceBaseTertiary,
                          ),
                          child: Column(
                            children: [
                              Consumer(builder: (context, ref, _) {
                                final navigatorRouteSettings = ref.watch(navigatorRouteSettingsProvider);

                                return ContentRow(
                                  onToggle: (_) => navigatorRouteSettingsNotifier.toggleAvoidTollRoads(),
                                  options: ContentRowOptions(
                                    title: l10n.avoidTollRoads,
                                    dividerEnabled: true,
                                    titleStyle: textStyle.text.copyWith(color: color.textAndIconsBasePrimary),
                                    actionWidget: ContentRowActionOptions(
                                      enabledToggle: true,
                                      toggleInitialValue: navigatorRouteSettings.avoidTollRoads,
                                    ),
                                  ),
                                );
                              }),
                              Consumer(builder: (context, ref, _) {
                                final navigatorRouteSettings = ref.watch(navigatorRouteSettingsProvider);
                                return ContentRow(
                                  onToggle: (_) => navigatorRouteSettingsNotifier.toggleAvoidUnpavedRoads(),
                                  options: ContentRowOptions(
                                    title: l10n.avoidUnpavedRoads,
                                    dividerEnabled: true,
                                    titleStyle: textStyle.text.copyWith(color: color.textAndIconsBasePrimary),
                                    actionWidget: ContentRowActionOptions(
                                      enabledToggle: true,
                                      toggleInitialValue: navigatorRouteSettings.avoidUnpavedRoads,
                                    ),
                                  ),
                                );
                              }),
                              Consumer(builder: (context, ref, _) {
                                final betterRouteSettings = ref.watch(betterRouteSuggestionsProvider);
                                return ContentRow(
                                  onToggle: (_) => betterRouteSettingsNotifier.toggle(),
                                  options: ContentRowOptions(
                                    title: l10n.suggestRouteBetter,
                                    dividerEnabled: true,
                                    titleStyle: textStyle.text.copyWith(color: color.textAndIconsBasePrimary),
                                    actionWidget: ContentRowActionOptions(
                                      enabledToggle: true,
                                      toggleInitialValue: betterRouteSettings,
                                    ),
                                  ),
                                );
                              }),
                              Consumer(builder: (context, ref, _) {
                                final autorun = ref.watch(freeRoamAutostartSettingsProvider.notifier).isEnabled;
                                return ContentRow(
                                  onToggle: (_) {
                                    ref.read(freeRoamAutostartSettingsProvider.notifier).toggleAutostart();
                                  },
                                  options: ContentRowOptions(
                                    title: l10n.autorunNavigator,
                                    titleStyle: textStyle.text.copyWith(color: color.textAndIconsBasePrimary),
                                    subtitle: l10n.automaticallyLaunchNavigator,
                                    subtitleMaxlines: 2,
                                    actionWidget: ContentRowActionOptions(
                                      enabledToggle: true,
                                      toggleInitialValue: autorun,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ContentColumn(
                      headerTitle: l10n.mapStyle,
                      content: [
                        ContentRow(
                          onTap: () => const DarkMapRoute().push(context),
                          options: ContentRowOptions(
                            wrapperColor: color.surfaceBaseTertiary,
                            wrapperEnabled: true,
                            title: l10n.darkMap,
                            titleStyle: textStyle.text.copyWith(color: color.textAndIconsBasePrimary),
                            actionWidget: ContentRowActionOptions(
                              actionIcon: AppIcons(
                                iconData: SystemIcons.arrowCornerRightLarge,
                                color: colorsV2.foregroundSoft,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ContentColumn(
                      headerTitle: l10n.soundAndAlerts,
                      content: [
                        ContentRow(
                          onTap: () => const SoundSettingsRoute().push(context),
                          options: ContentRowOptions(
                            titleStyle: textStyleV3.bodyLargeRegular.copyWith(
                              color: colorsV2.foregroundDefault,
                            ),
                            wrapperColor: color.surfaceBaseTertiary,
                            wrapperEnabled: true,
                            title: l10n.soundSettings,
                            actionWidget: ContentRowActionOptions(
                              actionIcon: AppIcons(
                                iconData: SystemIcons.arrowCornerRightLarge,
                                color: colorsV2.foregroundSoft,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ContentColumn(
                      headerTitle: l10n.roadEvents,
                      content: [
                        Consumer(builder: (context, ref, _) {
                          final navigatorCamerasSettings = ref.watch(navigatorSpeedCamerasSettingsProvider);

                          return ContentRow(
                            options: ContentRowOptions(
                              wrapperColor: color.surfaceBaseTertiary,
                              wrapperEnabled: true,
                              leadingIcon: Assets.icons.maneuver.roadEventCam.svg(
                                package: packageName,
                                fit: BoxFit.fill,
                              ),
                              title: l10n.speedCameras,
                              titleStyle: textStyle.text.copyWith(color: color.textAndIconsBasePrimary),
                              actionWidget: ContentRowActionOptions(
                                enabledToggle: true,
                                toggleInitialValue: navigatorCamerasSettings,
                              ),
                            ),
                            onToggle: (val) => navigatorCamerasSettingsNotifier.toggle(),
                          );
                        }),
                      ],
                    ),
                  ].insertBetween(Spacing.$4x.heightBox).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
