import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_bloc.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../bloc/compliance_event.dart';

class MobileNumberField extends StatelessWidget {
  const MobileNumberField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
        builder: (context, state) {
      return CustomTextFieldWidget(
        initialValue: state.contactMobileNumber ?? "",
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.phone,
        errorText: state.phoneErrorText,
        onValidate: (String? value) {},
        onChanged: (String? text) {
          context
              .read<ComplianceBloc>()
              .add(UpdateFieldsEvent(mobileNumber: text));
        },
        fillColor: Colors.transparent,
      );
    });
  }
}
