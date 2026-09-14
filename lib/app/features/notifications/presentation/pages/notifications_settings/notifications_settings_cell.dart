import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/notifications/presentation/bloc/notifications_settings/notifications_list_settings_cubit.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/constants/app_style.dart';
import '../../../data/model/notifications_settings_list/category.dart';
import '../../../data/repositories/notification_repository_implementation.dart';
import '../../../domain/entities/set_notifications_profile_products_params.dart';

class NotificationsSettingsCell extends StatefulWidget {
  final Category category;
  const NotificationsSettingsCell({super.key, required this.category});

  @override
  State<NotificationsSettingsCell> createState() => _NotificationsSettingsCellState();
}

class _NotificationsSettingsCellState extends State<NotificationsSettingsCell> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      trailing: Icon(Icons.keyboard_arrow_down, color: context.colors.accentActive),
      shape: const Border(),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.category.name!,
          style: AppStyle.cardTitleTextStle.copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      children: List.generate(
        widget.category.products!.length,
        (index) => BlocProvider(
          create: (context) {
            NotificationRepositoryImplementation notificationRepositoryImplementation = sl();
            return NotificationsListSettingsCubit(
              notificationsSettingsListRepository: notificationRepositoryImplementation,
              isChecked: widget.category.products![index].enabled!,
            );
          },
          child: BlocBuilder<NotificationsListSettingsCubit, NotificationsListSettingsState>(
            builder: (blocContext, state) {
              NotificationsListSettingsCubit cubit = blocContext.watch<NotificationsListSettingsCubit>();
              if (state is LoadingEventsSettingsState) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is FailureNotificationsSettingsState) {
                return ReloadWidget(
                  onTab: () {
                    cubit.setNotificationsProfileProducts(
                      SetNotificationsProfileProductsParams(
                        enabled: !cubit.isChecked,
                        channelId: 'mobile',
                        productId: widget.category.products![index].id,
                        applicationId: 'super-app',
                      ),
                    );
                  },
                );
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  borderRadius: BorderRadius.circular(8),

                  child: InkWell(
                    onTap: () {
                      cubit.setNotificationsProfileProducts(
                        SetNotificationsProfileProductsParams(
                          enabled: !cubit.isChecked,
                          channelId: 'mobile',
                          productId: widget.category.products![index].id,
                          applicationId: 'super-app',
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: Theme.of(context).cardColor,
                      height: 48,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2.0),
                              child: Text(
                                widget.category.products![index].name!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontFamily: GeneralKey.appFontType,
                                ),
                                // style: Theme.of(
                                //   context,
                                // ).extension<ThemeTextStyles>()!.text,
                              ),
                            ),
                            const Spacer(),
                            IgnorePointer(child: Toggle(value: cubit.isChecked)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
