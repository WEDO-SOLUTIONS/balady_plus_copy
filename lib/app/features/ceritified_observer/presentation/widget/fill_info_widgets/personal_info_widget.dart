import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import 'package:balady_plus/app/features/ceritified_observer/domain/entity/register_observer_request.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/blocs/choose_muncipality_bloc.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class PersonalInfoWidget extends StatelessWidget {
  final ChooseMuncipalityState state;

  const PersonalInfoWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'vd_user_info'.tr(),
      children: [
        const SizedBox(height: 20),
        CustomLookUpLongDialog(
          showOptional: false,
          items: state.lstDegrees ?? [],
          value: state.getDegreeByName(
              state.requestData?.academicQualification),
          onEmptyList: () async {
            return context
                .read<ChooseMuncipalityBloc>()
                .getDegreeList();
          },
          onChangeType: (LookUpItem? item) {
            if (item != null) {
              context.read<ChooseMuncipalityBloc>().add(
                setRequestDataEvent(
                  dataModel: RegisterObserverRequest(
                    academicQualification: item.name,
                  ),
                ),
              );
            }
          },
          label: "degree".tr(),
          hint: "degree".tr(),
        ),
        CustomLookUpLongDialog(
          showOptional: false,
          items: state.lstMaritalStatus ?? [],
          value: state.getMaritalStatusByName(
              state.requestData?.maritalStatus),
          onEmptyList: () async {
            return context
                .read<ChooseMuncipalityBloc>()
                .getMaritalStatusList();
          },
          onChangeType: (LookUpItem? item) {
            if (item != null) {
              context.read<ChooseMuncipalityBloc>().add(
                setRequestDataEvent(
                  dataModel: RegisterObserverRequest(
                    maritalStatus: item.name,
                  ),
                ),
              );
            }
          },
          label: "marital_status".tr(),
          hint: "marital_status".tr(),
        ),
      ],
    );
  }
}
