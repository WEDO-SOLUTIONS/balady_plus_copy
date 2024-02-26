import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import 'package:balady_plus/app/features/profile_features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:balady_plus/app/features/profile_features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:balady_plus/app/features/profile_features/delegators/presentation/widgets/delegator_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActionShowFilterWidget extends StatelessWidget {
  const ActionShowFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<DelegatorsCubit>().getDelegators();
    context.read<DelegatorsCubit>().getAgents();
    DashboardBloc bloc = BlocProvider.of<DashboardBloc>(context);
    return IconButton(
      onPressed: () async {
        if (CommonProperties.isLoggedIn) {
          await BottomSheetDialog.showDraggableSheet(
            context,
            dialogKeyName: DialogName.delegatorsDialog,
            currentRouteName: "ServicesPage",
            child: DelegatorList(
              delegatorsCubit: context.read<DelegatorsCubit>(),
            ),
          );
          bloc.add(DashboardEventInitial());
        } else {
          showDialog(
            context: context,
            builder: (ctx) => NeedLoginDialog(
              onSuccessLogin: (bool? isSuccess) async {
                if (isSuccess ?? false) {
                  context.read<DelegatorsCubit>().getDelegators();
                  context.read<DelegatorsCubit>().getAgents();
                  await BottomSheetDialog.showDraggableSheet(
                    context,
                    dialogKeyName: DialogName.delegatorsDialog,
                    currentRouteName: "ServicesPage",
                    child: DelegatorList(
                      delegatorsCubit: context.read<DelegatorsCubit>(),
                    ),
                  );
                  bloc.add(DashboardEventInitial());
                }
              },
            ),
          );
        }
      },
      icon: SvgPicture.asset(IconPath.users03),
    );
  }

}
