import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/details_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import '../../../_shared_feature_/presentation/widgets/empty_state_widget.dart';
import '../../../_shared_feature_/presentation/widgets/need_login_widget.dart';
import '../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../domain/entities/create_retrive_page_params.dart';
import '../blocs/retrieve_vehicles_bloc/retrieve_vehicles_bloc.dart';
import '../widgets/vechicle_card.dart';
import 'dc_select_retrive_request_type.dart';

class DCVehiclesPage extends StatelessWidget {
  const DCVehiclesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RetrieveVehiclesBloc(items: [], type: "OnBehalfOfMyself")
            ..add(GetMyVehiclesEvent()),
      child: BlocBuilder<RetrieveVehiclesBloc, RetrieveVehiclesState>(
        builder: (context, state) {
          return Scaffold(
              appBar: DetailsHeader(
                title: ('dc_my_viechle').tr(),
                onPress: () {
                  //Test
                  BottomSheetDialog.showDraggableSheet(context,
                      dialogKeyName: DialogName.dcVeichlesDialog,
                      currentRouteName: RouteName.DCVeichlePage,
                      isFullHeight: false,
                      height: 550,
                      child: DCSelectRetrieveTypePage());
                },
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state.status == BlocStatus.success &&
                      (state.vehicleItem?.isNotEmpty ?? false))
                    Expanded(
                      child: ListView.builder(
                          itemCount: (state.vehicleItem?.length ?? 0),
                          itemBuilder: (context, index) {
                            return VechicleCardWidget(
                              item: state.vehicleItem![index].cardItem,
                            );
                          }),
                    ), //:

                  if (state.status == BlocStatus.loading)
                    Expanded(
                        child: CustomShimmerListWidget(
                      height: 330,
                      itemCount: 10,
                    )),

                  if (state.status == BlocStatus.success &&
                      (state.vehicleItem?.isEmpty ?? true))
                    EmptyListWidget(
                      title: ("no_veichles").tr(),
                    ),
                  if (state.status == BlocStatus.failure)
                    ReloadWidget(
                      onTab: () {
                        context
                            .read<RetrieveVehiclesBloc>()
                            .add(GetMyVehiclesEvent());
                      },
                    )
                ],
              ));
        },
      ),
    );
  }
}
