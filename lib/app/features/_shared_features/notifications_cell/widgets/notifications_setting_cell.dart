import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/notifications/presentation/pages/notifications_settings/notifications_settings.dart';
import 'package:balady_uikit/balady_uikit.dart' hide IconPath;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../entry_point/presentation/cubit/auth_cubit.dart';
import '../../../notifications/data/repositories/notification_repository_implementation.dart';
import '../../../notifications/domain/entities/set_notifications_profile_params.dart';
import '../bloc/notifications_setting_cubit.dart';

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
    return CommonProperties.isLoggedInMunicipality
        ? BlocProvider(
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
                  return const SizedBox(
                    // We set this height because of glich effect. In normal state it takes 112px
                    // So the wrapper will not rebuild its height
                    height: 112,
                    child: Center(child: CircularProgressIndicator()),
                  );
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
                    });
                  }

                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          cubit.setNotificationsProfile(
                            SetNotificationsProfileParams(
                              enabled: !state.isChecked,
                              channelId: 'mobile',
                              applicationId: 'super-app',
                            ),
                            !state.isChecked,
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          height: 48,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  IconPath.notificationIc2,
                                  height: 24,
                                  width: 24,
                                  colorFilter: const ColorFilter.mode(AppColor.primary900Light, BlendMode.srcIn),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 2.0),
                                    child: Text(
                                      'notifications'.tr(),
                                      style: Theme.of(context).extension<ThemeTextStyles>()!.text.copyWith(
                                        color: context.colors.foregroundDefault,
                                      ),
                                    ),
                                  ),
                                ),

                                IgnorePointer(child: Toggle(value: state.isChecked)),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Text(
                              'enable_disable_notifications'.tr(),
                              style: Theme.of(context).extension<ThemeTextStyles>()!.caption.copyWith(
                                color: context.colors.foregroundDefault.withValues(alpha: 0.36),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/svg/profile/settings.svg",
                                      height: 24,
                                      width: 24,
                                      colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                                    ),
                                    const SizedBox(width: 4),
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
                      const SizedBox(height: 8),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          )
        : const SizedBox.shrink();
  }
}
