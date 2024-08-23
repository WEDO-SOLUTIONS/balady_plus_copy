import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/core/utils/constants.dart';
import 'package:balady_uikit/gen/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/app/routes/navigator_settings.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:urbi_utils/urbi_utils.dart';

class NavigatorSettingsPage extends ConsumerStatefulWidget {
  const NavigatorSettingsPage({super.key});

  @override
  ConsumerState<NavigatorSettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<NavigatorSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final dark = ref.watch(darkModeProvider);
    final arrowIcon = context.isLTR ? SystemIcons.arrowCornerRightLarge : SystemIcons.arrowCornerLeftLarge;
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
                  icon: context.isLTR ? SystemIcons.arrowCornerLeftLarge : SystemIcons.arrowCornerRightLarge,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ContentColumn(
                      headerTitle: l10n.mapStyle,
                      content: [
                        ContentRow(
                          onToggle: (_) {
                            ref.read(darkModeProvider.notifier).toggle();
                            Metrics.logEventAdvanced(MetricsConstants.navigationKeys.darkMode,
                                group: MetricsConstants.navigationTag,
                                action: MetricAction.tap.toString(),
                                props: {
                                  'dark': !dark,
                                });
                          },
                          options: ContentRowOptions(
                            wrapperColor: color.surfaceBaseTertiary,
                            wrapperEnabled: true,
                            title: l10n.darkMap,
                            titleStyle: textStyle.text.copyWith(color: color.textAndIconsBasePrimary),
                            actionWidget: ContentRowActionOptions(
                              enabledToggle: true,
                              toggleInitialValue: dark,
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
                                iconData: arrowIcon,
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
                        ContentRow(
                          onToggle: (_) {},
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
                              toggleInitialValue: dark,
                            ),
                          ),
                        ),
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
