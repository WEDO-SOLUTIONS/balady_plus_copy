import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/fields/read_only_field.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/blocs/choose_muncipality_bloc.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class BankInfoWidget extends StatelessWidget {
  final ChooseMuncipalityState state;

  const BankInfoWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'bank_info'.tr(),
      children: [
        const SizedBox(height: 20),
        CustomLookUpLongDialog(
          showOptional: false,
          items: state.lstBanks ?? [],
          value: state.requestData?.bankInfo,
          onEmptyList: () async {
            return context
                .read<ChooseMuncipalityBloc>()
                .getBanksList();
          },
          onChangeType: (LookUpItem? item) {
            if (item != null) {
              context.read<ChooseMuncipalityBloc>().add(
                SetRequestDataEvent(
                  dataModel: state.requestData!.copyWith(
                    bankInfo: item,
                  ),
                ),
              );
            }
          },
          label: "bank_name".tr(),
          hint: "bank_name".tr(),
        ),


        CustomTextFieldWidget(
          textFieldVerticalPadding: 14,
          label: "bank_iban".tr(),
          hintText: "bank_iban".tr(),
          onChanged: (text){

            context.read<ChooseMuncipalityBloc>().add(
              SetRequestDataEvent(
                dataModel: state.requestData!.copyWith(
                  iban: text,
                ),
              ),
            );
          },
          onValidate: (text) => text?.isEmpty ?? true
              ? "${"bank_iban".tr()} ${"required".tr()}"
              : null,
          // decoration: BoxDecoration(
          //   color: AppColor.blackModern300Light.withOpacity(0.4),
          //   borderRadius: BorderRadius.circular(8),
          // ),
        )
      ],
    );
  }
}
