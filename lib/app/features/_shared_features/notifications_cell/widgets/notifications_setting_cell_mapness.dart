import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_features/notifications_count/cubit_notification_count/notifications_item_cubit.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// According to the design, the NotificationsSettingsRow should not be displayed
/// Before it was displayed in the file `mapness/lib/pages/profile/profile_page.dart`
/// You need to check commits and file history to see the previous implementation
///
/// We keep it here to use it in the future if needed because design can change
/// If design will not change, we can delete this file
///
/// Task: BSA-1776
/// Figma: https://www.figma.com/design/pBvXwBiDQdtN8qZ0IjdeAA/Profile-3.0?node-id=1009-29295&p=f&t=A2UFfEtVvSPOzq6K-0
@Deprecated('Not used anymore, according to the design')
class NotificationsSettingsRow extends StatelessWidget {
  const NotificationsSettingsRow({
    required this.actionIcon,
    super.key,
  });

  final AppIcons actionIcon;

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return NotificationsCountCubit(webService: sl());
      },
      child: BlocBuilder<NotificationsCountCubit, SucceedCountState>(
        builder: (blocContext, state) {
          final cubit = blocContext.watch<NotificationsCountCubit>();

          return ContentRow(
            options: ContentRowOptions(
              customActionWidget: Row(
                children: [
                  if (state.count != null && state.count! > 0)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: 6,
                      ),
                      child: Counter(
                        count: state.count,
                      ),
                    ),
                  ContentRowAction(
                    actionOptions: ContentRowActionOptions(
                      actionIcon: actionIcon,
                    ),
                  ),
                ],
              ),
              leadingIcon: Icon(
                SystemIcons.notification,
                color: context.colors.accentDefault,
              ),
              title: context.l10n.municipalNotifications,
            ),
            onTap: () {
              NavigationService.navigatorKey.currentState!
                  .pushNamed(
                RouteName.notificationsListScreen,
              )
                  .then((value) {
                cubit.getUnreadMessages();
                Jiffy.setLocale("en");
              });
            },
          );
        },
      ),
    );
  }
}
