import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/drop_downs/drop_down_box_with_title.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/notifications_message_item.dart';
import 'package:balady_plus/app/features/notifications/presentation/bloc/cubit_notification_filter/notifications_filter_cubit.dart';
import 'package:balady_plus/app/features/notifications/presentation/bloc/notifications_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class NotificationsFiltersTypesWidget extends StatelessWidget {
  const NotificationsFiltersTypesWidget({key});

  @override
  Widget build(BuildContext context) {
    NotificationsFilterCubit cubit = context.watch<NotificationsFilterCubit>();
    NotificationsListCubit cubitList = context.watch<NotificationsListCubit>();
    return Column(
      children: [
        BlocBuilder<NotificationsFilterCubit, NotificationsFilterState>(
          bloc: cubit,
          builder: (_, state) {
            if (state is InitialNotificationsFilterState || state is LoadingNotificationsFilterState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FailureNotificationsFilterState) {
              return ReloadWidget(
                onTab: () => cubit.getNotificationsProducts(),
              );
            }
            if (state is SucceedServicesFilterState) {
              return Column(
                children: [
                  DropDownWithTitle(
                    title: "product".tr(),
                    selectedValue: state.selectedProduct?.text,
                    onTap: () {
                      BottomSheetDialog.showDraggableSheet(
                        context,
                        dialogKeyName: DialogName.notificationsServicesDialog,
                        currentRouteName: RouteName.notificationsListScreen,
                        child: GenericBottomSheetList<NotificationType>(
                          title: "product".tr(),
                          items: state.listProducts,
                          selectedValue: null,
                          onTap: (item) {
                            cubit.getNotificationsServicesProducts(product: item);
                            cubitList.params = cubitList.params.copyWith(
                              productId: item.id,
                              serviceId: null,
                            );
                            cubitList.getNotificationsMessagesList();
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                  state.selectedProduct != null && state.listServices.isNotEmpty
                      ? DropDownWithTitle(
                          title: "services".tr(),
                          selectedValue: state.selectedServices?.text,
                          onTap: () {
                            BottomSheetDialog.showDraggableSheet(
                              context,
                              dialogKeyName: DialogName.notificationsServicesDialog,
                              currentRouteName: RouteName.notificationsListScreen,
                              child: GenericBottomSheetList<NotificationType>(
                                title: "services".tr(),
                                items: state.listServices,
                                selectedValue: null,
                                onTap: (item) {
                                  cubit.selectedServices(service: item);
                                  cubitList.params = cubitList.params.copyWith(
                                    serviceId: item.id,
                                  );
                                  cubitList.getNotificationsMessagesList();
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                        )
                      : const SizedBox(),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ],
    );
    // return SizedBox(
    //   height: 60,
    //   child: ListView.builder(
    //     itemBuilder: (BuildContext context, int index) {
    //       return NotificationTypeWidget(
    //         isSelected: index == 0,
    //         title: types[index],
    //         count: types.length - index,
    //       );
    //     },
    //     scrollDirection: Axis.horizontal,
    //     itemCount: types.length,
    //   ),
    // );
  }
}
