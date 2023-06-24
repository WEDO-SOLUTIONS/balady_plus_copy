import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/details_header.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/empty_state_widget.dart';
import '../../../data/model/veichles_list_page_params.dart';
import '../../../domain/entities/create_retrive_page_params.dart';
import '../../blocs/retrieve_vehicles_bloc/retrieve_vehicles_bloc.dart';
import '../../widgets/check_veichles_page/car_plate_widget.dart';

class VeichlesListPage extends StatefulWidget {
  final VeichlesListPageParams params;
  const VeichlesListPage({super.key, required this.params});

  @override
  State<VeichlesListPage> createState() => _VeichlesListPageState();
}

class _VeichlesListPageState extends State<VeichlesListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RetrieveVehiclesBloc(
          type: widget.params.type, items: widget.params.items),
      child: BlocConsumer<RetrieveVehiclesBloc, RetrieveVehiclesState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: DetailsHeader(
              title: "عرض المركبات",
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (state.status == BlocStatus.success &&
                          (state.vehicleItem?.isEmpty ?? true))
                        EmptyStateWidget(
                          title: ("no_veichles").tr(),
                        ),
                      if (state.vehicleItem?.isNotEmpty ?? false) ...[
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.vehicleItem?.length ?? 0,
                            itemBuilder: (ctx, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CarPlateWidget(
                                  plate: state
                                      .vehicleItem?[index].vehiclePlateNumber,
                                  type: state.vehicleItem?[index].vehicleDetails
                                      ?.modelAndType,
                                  currentId: state.selectedVehicle?.pyId,
                                  id: state.vehicleItem?[index].pyId,
                                  onChange: (String id) {
                                    print(id);
                                    context
                                        .read<RetrieveVehiclesBloc>()
                                        .add(SelectViehclesEvent(id: id));
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: EnhancedCustomElevatedButtonWidget(
                              btnColor: state.selectedVehicle == null
                                  ? AppColor.black200
                                  : AppColor.primary900Light,
                              btnTextColor: state.selectedVehicle == null
                                  ? AppColor.black400
                                  : AppColor.white,
                              btnText: "إختيار",
                              btnPressed: () {
                                NavigationService.navigatorKey.currentState
                                    ?.pushNamed(
                                        RouteName.CreateRetriveDetailsPage,
                                        arguments: CreateRetrivePageParams(
                                            item: state.selectedVehicle!,
                                            type: state.type ?? ""));
                              },
                            ))
                      ]
                    ],
                  ),
                ),
                if (state.status == BlocStatus.loading)
                  CustomCircularLoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
