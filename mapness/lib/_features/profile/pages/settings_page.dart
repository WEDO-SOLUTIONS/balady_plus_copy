import 'package:balady_plus/app/features/_shared_features/notifications_cell/widgets/notifications_setting_cell.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

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
            child: Padding(
              padding:
                  const EdgeInsets.only(top: Spacing.verticalBaseToTopModal),
              child: Scaffold(
                appBar: BaladyTopBar.iconAndText(
                  title: context.l10n.settings,
                  colorEnabled: context.color.textAndIconsStatusAccent,
                  leading: ActionModel(
                    onPressed: () => context.pop(),
                    icon: context.isLTR
                        ? SystemIcons.arrowCornerLeftL
                        : SystemIcons.arrowCornerRightL,
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
                        color: context.color.surfaceBaseSecondary,
                        children: const [
                          /* ContentRow(
                            options: ContentRowOptions(
                                leadingIcon: AppIcons(
                                  iconData: GeneralIcons.darkMode,
                                  color: context.color.textAndIconsStatusAccent,
                                  size: 24,
                                ),
                                title: 'Notifications',
                                actionWidget: const ContentRowActionOptions(
                                  enabledToggle: true,
                                  // Initial toggle value
                                  toggleInitialValue: true,
                                )),
                            onToggle: (_) {
                              // Do something when the toggle is changed
                            },
                          ),*/
                          NotificationsSettingCell()
                        ],
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
