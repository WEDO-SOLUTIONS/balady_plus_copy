import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/details_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../blocs/retrieve_vehicles_bloc/retrieve_vehicles_bloc.dart';
import '../../widgets/check_veichles_page/fields/car_owner_field.dart';
import '../../widgets/check_veichles_page/fields/dc_agent_number.dart';
import '../../widgets/check_veichles_page/fields/dc_cr_number.dart';
import '../../widgets/check_veichles_page/fields/dead_person_field.dart';

class CheckVeichlesPage extends StatefulWidget {
  const CheckVeichlesPage({super.key});

  @override
  State<CheckVeichlesPage> createState() => _CheckVeichlesPageState();
}

class _CheckVeichlesPageState extends State<CheckVeichlesPage> {
  @override
  Widget build(BuildContext context) {
    String type = ModalRoute.of(context)!.settings.arguments as String;

    return BlocProvider(
      create: (context) => RetrieveVehiclesBloc(type: type, items: []),
      child: BlocConsumer<RetrieveVehiclesBloc, RetrieveVehiclesState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return Scaffold(
              appBar: DetailsHeader(
                title: "retrieve_title".tr(),
              ),
              body: Stack(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 32, left: 16, right: 16),
                    child: Column(children: [
                      if (state.type == "Agent") ...[
                        CarOwnerIdField(),
                        CustomVerticalSpace(height: 16),
                        CarDCAgentNumberField()
                      ],
                      if (state.type == "Owner/ManagerOfTheFacility") ...[
                        CarCrField(),
                      ],
                      if (state.type == "OnBehalfOfDeadPerson") ...[
                        CarDeadPersonField(),
                      ],
                    ]),
                  ),
                  SafeArea(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: EnhancedCustomElevatedButtonWidget(
                          btnColor: !state.isFormValid()
                              ? AppColor.black200
                              : AppColor.primary900Light,
                          btnTextColor: !state.isFormValid()
                              ? AppColor.black400
                              : AppColor.white,
                          btnText: "retrieve_btn_text".tr(),
                          btnRadius: 8,
                          horizontalMargin: 16,
                          btnPressed: state.isFormValid()
                              ? () {
                                  context
                                      .read<RetrieveVehiclesBloc>()
                                      .add(GetViehclesEvent());
                                }
                              : null,
                        )),
                  ),
                  if (state.status == BlocStatus.loading)
                    CustomCircularLoadingWidget(),
                  if (state.status == BlocStatus.retry)
                    ReloadWidget(onTab: () {
                      if (state.type == "OnBehalfOfMyself")
                        context
                            .read<RetrieveVehiclesBloc>()
                            .add(GetMyVehiclesEvent());
                    }),
                ],
              ));
        },
      ),
    );
  }
}
