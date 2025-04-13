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

class BankInfoWidget extends StatelessWidget {
  final ChooseMuncipalityState state;
  final ExpandableController expandableController;

  const BankInfoWidget({
    super.key,
    required this.state,
    required this.expandableController,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableWithControllerWidget(
      controller: expandableController,
      title: "bank_info".tr(),
      expanded: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CustomLookUpLongDialog(
              showOptional: false,
              items: state.lstBanks ?? [],
              value: state.requestData?.bankInfo,
              onEmptyList: () async {
                return context.read<ChooseMuncipalityBloc>().getBanksList();
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
              controller: state.bankIbanController,
              onChanged: (text) {
                context.read<ChooseMuncipalityBloc>().add(
                      SetRequestDataEvent(
                        dataModel: state.requestData!.copyWith(
                          iban: text,
                        ),
                      ),
                    );
              },
              onValidate: Helpers.validateIBAN,
              // decoration: BoxDecoration(
              //   color: AppColor.blackModern300Light.withOpacity(0.4),
              //   borderRadius: BorderRadius.circular(8),
              // ),
            )
          ],
        ),
      ),
    );
  }
}
