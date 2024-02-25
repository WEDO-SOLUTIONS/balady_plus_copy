import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/notifications/presentation/widgets/actions_appbar/action_show_filter_widget.dart';
import 'package:balady_plus/app/features/notifications/presentation/widgets/actions_appbar/action_show_type_date_widget.dart';
import 'package:balady_plus/app/features/notifications/presentation/widgets/notifications_filters_types_widget/notifications_filters_types_widget.dart';
import 'package:balady_plus/app/features/notifications/presentation/widgets/notifications_items_widget/notifications_list_items_widget.dart';
import 'package:balady_plus/app/features/notifications/presentation/widgets/notifications_types_widget/notifications_types_select_widget.dart';
import 'package:balady_plus/app/features/profile_features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class NotificationsListPage extends StatelessWidget {
  const NotificationsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DelegatorsCubit>.value(
      value: sl<DelegatorsCubit>(),
      child: Scaffold(
        appBar: DefaultAppBarWidget(
          title: "notifications".tr(),
          actions: const [
            ActionShowTypeDateWidget(),
            SizedBox(width: 10),
            ActionShowFilterWidget(),
          ],
        ),
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                SizedBox(height: 12),
                NotificationsTypesWidget(),
                // add Search
                NotificationsFiltersTypesWidget(),
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
