import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../bloc/compliance_bloc.dart';
import '../../../bloc/compliance_event.dart';
import '../../../bloc/compliance_state.dart';

class ElectricityNumberTextField extends StatelessWidget {
  const ElectricityNumberTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return CustomTextFieldWithValueWidget(
          label: "compliance_electricity_number".tr(),
          hintText: "compliance_electricity_number".tr(),
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
      },
    );
  }
}
