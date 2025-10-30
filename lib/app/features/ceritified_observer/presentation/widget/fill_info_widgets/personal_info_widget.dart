import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/blocs/choose_muncipality_bloc.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/expandable_with_controller_widget.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class PersonalInfoWidget extends StatelessWidget {
  final ChooseMuncipalityState state;
  final ExpandableController expandableController;

  const PersonalInfoWidget({
    super.key,
    required this.state,
    required this.expandableController,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableWithControllerWidget(
      controller: expandableController,
      title: 'vd_user_info'.tr(),
      expanded: Column(
        children: [
          CustomTextFieldWidget(
            textFieldVerticalPadding: 14,
            label: "email".tr(),
            hintText: "email".tr(),
            controller: state.emailController,
            onChanged: (text) {
              context.read<ChooseMuncipalityBloc>().add(
                SetRequestDataEvent(
                  dataModel: state.requestData!.copyWith(
                    email: text,
                  ),
                ),
              );
            },
            onValidate: Helpers.validateEmail,
          ),
          const SizedBox(height: 12),
          CustomLookUpLongDialog(
            showOptional: false,
            items: state.lstDegrees ?? [],
            value: state.requestData?.academicQualification,
            onEmptyList: () async {
              return context.read<ChooseMuncipalityBloc>().getDegreeList();
            },
            onChangeType: (LookUpItem? item) {
              if (item != null) {
                context.read<ChooseMuncipalityBloc>().add(
                  SetRequestDataEvent(
                    dataModel: state.requestData!.copyWith(
                      academicQualification: item,
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
            value: state.requestData?.maritalStatus,
            onEmptyList: () async {
              return context.read<ChooseMuncipalityBloc>().getMaritalStatusList();
            },
            onChangeType: (LookUpItem? item) {
              if (item != null) {
                context.read<ChooseMuncipalityBloc>().add(
                  SetRequestDataEvent(
                    dataModel: state.requestData!.copyWith(
                      maritalStatus: item,
                    ),
                  ),
                );
              }
            },
            label: "marital_status".tr(),
            hint: "marital_status".tr(),
          ),
        ],
      )
    );
  }
}
