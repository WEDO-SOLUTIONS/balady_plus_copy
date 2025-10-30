import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/blocs/choose_muncipality_bloc.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/expandable_with_controller_widget.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class LocationInfoWidget extends StatelessWidget {
  final ChooseMuncipalityState state;
  final ExpandableController expandableController;

  const LocationInfoWidget({
    super.key,
    required this.state,
    required this.expandableController,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableWithControllerWidget(
      controller: expandableController,
      title: 'location'.tr(),
      expanded: Column(
        children: [
          CustomLookUpLongDialog(
            showOptional: false,
            isDisbaled: true,
            items: state.lstMunicipalityLookUp ?? [],
            value: state.requestData?.municipality,
            onEmptyList: () async {},
            onChangeType: (LookUpItem? item) {
              if (item != null) {}
            },
            label: "license_health_municipality".tr(),
            hint: "license_health_municipality".tr(),
          ),
          CustomLookUpLongDialog(
            showOptional: false,
            items: state.lstCitesLookUp ?? [],
            value: state.requestData?.city,
            onEmptyList: () async {
              return context.read<ChooseMuncipalityBloc>().getCityList(
                state.requestData!.municipality!.strId!,
              );
            },
            onChangeType: (LookUpItem? item) {
              if (item != null) {
                state.requestData!.district = null;

                context.read<ChooseMuncipalityBloc>().add(
                  SetRequestDataEvent(
                    dataModel: state.requestData!.copyWith(
                      city: item,

                    ),
                  ),
                );

                context.read<ChooseMuncipalityBloc>().getDistrictByCityIdList(
                  item.strId!,
                );
              }
            },
            label: "city".tr(),
            hint: "city".tr(),
          ),
          CustomLookUpLongDialog(
            showOptional: false,
            items: state.lstDistrictLookUp ?? [],
            value: state.requestData?.district,
            onEmptyList: () async {
              context.read<ChooseMuncipalityBloc>().getCityList(
                state.requestData!.municipality!.strId!,
              );
            },
            onChangeType: (LookUpItem? item) {
              if (item != null) {
                context.read<ChooseMuncipalityBloc>().add(
                  SetRequestDataEvent(
                    dataModel: state.requestData!.copyWith(
                      district: item,
                    ),
                  ),
                );
              }
            },
            label: "district".tr(),
            hint: "district".tr(),
          ),
        ],
      ),
    );
  }
}
