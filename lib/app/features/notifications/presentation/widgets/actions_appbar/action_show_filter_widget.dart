import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import 'package:balady_plus/app/features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:balady_plus/app/features/delegators/presentation/widgets/delegator_list.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/app/features/notifications/presentation/bloc/notifications_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActionShowFilterWidget extends StatelessWidget {
  const ActionShowFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationsListCubit cubit = context.watch<NotificationsListCubit>();

    return IconButton(
      onPressed: () {
        if (CommonProperties.isLoggedInMunicipality) {
          showDialogParsona(cubit, context);
        } else {
          showDialog(
            context: context,
            builder: (ctx) => NeedLoginDialog(
              onSuccessLogin: (bool? isSuccess) {
                if (isSuccess ?? false) {
                  context.read<DelegatorsCubit>().loadData();
                  showDialogParsona(cubit, context);
                }
              },
            ),
          );
        }
      },
      icon: SvgPicture.asset(IconPath.users03),
    );
  }

  void showDialogParsona(NotificationsListCubit cubit, BuildContext context) async {
    await BottomSheetDialog.showDraggableSheet(
      context,
      dialogKeyName: DialogName.delegatorsDialog,
      currentRouteName: "ServicesPage",
      child: DelegatorList(delegatorsCubit: context.read<DelegatorsCubit>()),
    );
    if (!context.mounted) {
      return;
    }
    EntryPointCubit auth = context.read<EntryPointCubit>();
    // final selectedAgent = auth.state.selectedAgent;
    // final selectedDelegator = auth.state.selectedDelegator;
    if (auth.state.userInfo != null) {
      cubit.params.persoana = {
        "x-owner-actor-type-id": "person",
        "x-owner-actor-id-type-id": "identity-number",
        "x-owner-actor-id-value": auth.state.userInfo!.idNo,
        "x-owner-actor-id-source-id": "moi",
      };
    }
    cubit.getNotificationsMessagesList();
  }
}
