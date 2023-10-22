import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_bloc.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../_shared_feature_/presentation/widgets/check_boxes/text_field_with_check_btn.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../bloc/compliance_event.dart';

class MobileNumberField extends StatefulWidget {
  const MobileNumberField({super.key});

  @override
  State<MobileNumberField> createState() => _MobileNumberFieldState();
}

class _MobileNumberFieldState extends State<MobileNumberField> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return TextWithCheckBtn(
          controller: controller,
          maxLength: 10,
          backgroundColor: Colors.transparent,
          validate: (String? t) {},
          isValidate: state.contactMobileVerified ?? false,
          currentValue: state.contactMobileNumber,

          onTextChanged: (String text) {
            context
                .read<ComplianceBloc>()
                .add(UpdateFieldsEvent(mobileNumber: text));
          },
          title: ("vd_mobile_number").tr(),
          errorText: state.phoneErrorText,
          verify: () {
            context.read<ComplianceBloc>().add(SendOTPEvent(showOTPPage: true));
          },
          //currentValue: "ww",
          hint: ("vd_mobile_number").tr(),
        );
      },
    );
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
