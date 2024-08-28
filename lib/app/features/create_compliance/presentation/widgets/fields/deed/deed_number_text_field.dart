import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../_shared_feature_/presentation/widgets/check_boxes/text_field_with_check_btn.dart';
import '../../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../bloc/compliance_bloc.dart';
import '../../../bloc/compliance_event.dart';
import '../../../bloc/compliance_state.dart';

class DeadNumberTextField extends StatefulWidget {
  const DeadNumberTextField({super.key});

  @override
  State<DeadNumberTextField> createState() => _DeadNumberTextFieldState();
}

class _DeadNumberTextFieldState extends State<DeadNumberTextField> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return state.isDeedPaper == false
            ? TextWithCheckBtn(
                title: "compliance_deed_number_text".tr(),
                hint: "compliance_deed_number_text".tr(),
                controller: controller,
                currentValue: state.ownershipText,
                // keyboardType: TextInputType.text,
                //  inputFormatters: [],
                onTextChanged: (String? text) {
                  context
                      .read<ComplianceBloc>()
                      .add(UpdateFieldsEvent(ownershipText: text));
                },
                verify: () {
                  if(controller.text.isNotEmpty){
                    context
                        .read<ComplianceBloc>()
                        .add(const GetComplianceDeedInfoEvent());
                  } else {
                    CommonFunctions.showError("required_field_must_number_12_digits".tr());
                  }
                },
                backgroundColor: Colors.transparent,
                isValidate: state.deedInfo?.deedNumber != null,
                validate: (String? t) {},
              )
            : CustomTextFieldWithValueWidget(
                label: "compliance_deed_number_text".tr(),
                hintText: "compliance_deed_number_text".tr(),
                value: state.ownershipText,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp('[٠١٢٣٤٥٦٧٨٩]')),
                ],
                onChanged: (String? text) {
                  context
                      .read<ComplianceBloc>()
                      .add(UpdateFieldsEvent(ownershipText: text));
                },
                onValidate: (String? t) {},
              );
        ;
      },
    );
  }
}
