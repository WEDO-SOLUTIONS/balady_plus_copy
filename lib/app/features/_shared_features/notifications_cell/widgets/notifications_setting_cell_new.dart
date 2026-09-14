import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/notifications/data/repositories/notification_repository_implementation.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/features/notifications/presentation/pages/notifications_settings/notifications_settings.dart';
import '../../../entry_point/presentation/cubit/auth_cubit.dart';
import '../bloc/notifications_setting_cubit.dart';
import 'package:balady_uikit/balady_uikit.dart';

class NotificationsSettingCell extends StatefulWidget {
  const NotificationsSettingCell({super.key});

  @override
  State<NotificationsSettingCell> createState() => _NotificationsSettingCellState();
}

class _NotificationsSettingCellState extends State<NotificationsSettingCell> {
  @override
  Widget build(BuildContext context) {
    EntryPointCubit auth = context.read<EntryPointCubit>();
    bool manageNotificationClicked = false;
    return auth.state.userInfo == null
        ? const SizedBox.shrink()
        : BlocProvider(
            create: (context) {
              NotificationRepositoryImplementation notificationRepositoryImplementation = sl();
              return NotificationsSettingCubit(
                notificationsSettingsListRepository: notificationRepositoryImplementation,
                notificationId: 'mobile',
              );
            },
            child: BlocBuilder<NotificationsSettingCubit, NotificationsSettingState>(
              builder: (contextCubit, state) {
                NotificationsSettingCubit cubit = contextCubit.watch<NotificationsSettingCubit>();
                if (state is InitialNotificationsSettingsState || state is LoadingEventsSettingsState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is FailureNotificationsSettingsState) {
                  return ReloadWidget(
                    onTab: () {
                      cubit.getNotificationSetting(cubit.notificationId);
                    },
                  );
                }
                if (state is SucceedEventsNotificationState) {
                  if (manageNotificationClicked) {
                    manageNotificationClicked = false;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      NavigationService.navigatorKey.currentState!.push(
                        MaterialPageRoute(
                          builder: (_) =>
                              NotificationsSettings(notificationsList: cubit.notificationsSettingsList.categories!),
                        ),
                      );

                      /*
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              NotificationsSettings(notificationsList: cubit.notificationsSettingsList.categories!)));

                      */
                    });
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContentWrapper(
                        color: context.colors.backgroundSurface4,
                        children: [
                          // ContentRow(
                          //   options: ContentRowOptions(
                          //       leadingIcon: SvgPicture.asset(
                          //         iconPath.IconPath.notificationIc2,
                          //         icon_path.IconPath.notificationIc2,
                          //
                          //         height: 24,
                          //         width: 24,
                          //         colorFilter: const ColorFilter.mode(
                          //           AppColor.primary900Light,
                          //           BlendMode.srcIn,
                          //         ),
                          //       ),
                          //       title: 'notifications'.tr(),
                          //       actionWidget: ContentRowActionOptions(
                          //         enabledToggle: true,
                          //         toggleInitialValue: state.isChecked,
                          //       )),
                          //   onToggle: (_) {
                          //     cubit.setNotificationsProfile(
                          //         SetNotificationsProfileParams(
                          //             enabled: !state.isChecked, channelId: 'mobile', applicationId: 'super-app'),
                          //         !state.isChecked);
                          //   },
                          // )
                        ],
                      ),
                      const SizedBox(height: Spacing.$2x),
                      Text(
                        'enable_disable_notifications'.tr(),
                        style: context.textStyle.caption.copyWith(
                          color: const Color(0xFF1E2A36).withValues(alpha: 0.36),
                        ),
                      ),
                      const SizedBox(height: Spacing.$2x),
                      state.isChecked
                          ? GestureDetector(
                              onTap: () {
                                manageNotificationClicked = true;
                                cubit.getNotificationSetting(cubit.notificationId);
                                /* Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => NotificationsSettings(
                                        notificationsList: cubit
                                            .notificationsSettingsList
                                            .categories!)));*/
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/svg/profile/settings.svg",
                                      height: 24,
                                      width: 24,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      'manage_notification'.tr(),
                                      style: Theme.of(
                                        context,
                                      ).extension<ThemeTextStyles>()!.text.copyWith(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          );
  }
}
