import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/notifications/presentation/bloc/notifications_list_cubit.dart';
import 'package:balady_plus/app/features/notifications/presentation/widgets/notifications_items_widget/notifications_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListItemsEventsWidget extends StatelessWidget {
  const ListItemsEventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationsListCubit cubit = context.watch<NotificationsListCubit>();
    return BlocBuilder<NotificationsListCubit, NotificationsListState>(
      bloc: cubit,
      builder: (_, state) {
        if (state is InitialNotificationsListState ||
            state is LoadingEventsListState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is FailureNotificationsListState) {
          return ReloadWidget(
            onTab: () => cubit.getNotificationsMessagesList(cubit.params),
          );
        }
        /////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////
        // View Loading In after list item in list
        if (state is SucceedWithPaginationNotificationsListState) {
          ScrollController scrollController = ScrollController();
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index == state.listMessages.length
                  ? const Center(child: CircularProgressIndicator())
                  : const NotificationsItemWidget();
            },
            controller: scrollController
              ..addListener(
                () {
                  if (scrollController.position.pixels ==
                      scrollController.position.maxScrollExtent) {
                    cubit.getNotificationsMessagesList(cubit.params);
                  }
                },
              ),
            itemCount: state.listMessages.length + 1,
          );
        }
        if (state is SucceedEventsListState) {
          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemBuilder: (BuildContext context, int index) {
              return const NotificationsItemWidget();
            },
            itemCount: state.listMessages.length,
          );
        }

        return const SizedBox();
      },
    );
  }
}
