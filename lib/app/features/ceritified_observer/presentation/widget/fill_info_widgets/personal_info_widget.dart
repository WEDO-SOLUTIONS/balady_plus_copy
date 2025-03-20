import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
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
        CustomTextFieldWidget(
          textFieldVerticalPadding: 14,
          label: "mobile_number".tr(),
          hintText: "mobile_number".tr(),
          onChanged: (text) {
            context.read<ChooseMuncipalityBloc>().add(
                  SetRequestDataEvent(
                    dataModel: state.requestData!.copyWith(
                      mobileNumber: text,
                    ),
                  ),
                );
          },
          onValidate: Helpers.validateMobile,
        ),
        const SizedBox(height: 12),
        CustomTextFieldWidget(
          textFieldVerticalPadding: 14,
          label: "email".tr(),
          hintText: "email".tr(),
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
    );
  }
}
