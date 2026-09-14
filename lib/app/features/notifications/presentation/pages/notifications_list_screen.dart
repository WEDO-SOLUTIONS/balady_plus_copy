import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/search_notifications_params.dart';
import 'package:balady_plus/app/features/notifications/data/repositories/notification_repository_implementation.dart';
import 'package:balady_plus/app/features/notifications/presentation/bloc/cubit_notification_filter/notifications_filter_cubit.dart';
import 'package:balady_plus/app/features/notifications/presentation/bloc/notifications_list_cubit.dart';
import 'package:balady_plus/app/features/notifications/presentation/widgets/actions_appbar/action_show_filter_widget.dart';
import 'package:balady_plus/app/features/notifications/presentation/widgets/actions_appbar/action_show_type_date_widget.dart';
import 'package:balady_plus/app/features/notifications/presentation/widgets/notification_search_widget.dart';
import 'package:balady_plus/app/features/notifications/presentation/widgets/notifications_filters_types_widget/notifications_filters_types_widget.dart';
import 'package:balady_plus/app/features/notifications/presentation/widgets/notifications_items_widget/notifications_list_items_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class NotificationsListScreen extends StatelessWidget {
  const NotificationsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            NotificationRepositoryImplementation filterRepository = sl();
            return NotificationsFilterCubit(filterRepository: filterRepository);
          },
        ),
        BlocProvider(
          create: (_) {
            NotificationRepositoryImplementation listRepository = sl();
            EntryPointCubit auth = context.read<EntryPointCubit>();
            // final selectedAgent = auth.state.selectedAgent;
            // final selectedDelegator = auth.state.selectedDelegator;
            late Map<String, dynamic> persoana;
            if (auth.state.userInfo != null) {
              persoana = {
                "typeId": "person",
                "ids": [
                  {"typeId": "identity-number", "value": auth.state.userInfo!.idNo, "sourceId": "moi"},
                ],
              };
            }
            return NotificationsListCubit(
              listRepository: listRepository,
              params: SearchNotificationsParams(persoana: persoana),
            );
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: DefaultAppBarWidget(
          title: "notifications".tr(),
          actions: const [ActionShowTypeDateWidget(), SizedBox(width: 10), ActionShowFilterWidget()],
        ),
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                SizedBox(height: 12),
                // NotificationsTypesWidget(),
                // SizedBox(height: 12),
                NotificationSearchWidget(),
                NotificationsFiltersTypesWidget(),
                SizedBox(height: 6),
                Expanded(child: ListItemsEventsWidget()),
              ],
            ),
          ),
        ),
        // ),
      ),
    );
  }
}
