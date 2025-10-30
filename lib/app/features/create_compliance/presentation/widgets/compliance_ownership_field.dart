import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../bloc/compliance_bloc.dart';
import '../bloc/compliance_state.dart';

class ComplianceOwnerShipField extends StatelessWidget {
  const ComplianceOwnerShipField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return CustomTextFieldWithValueWidget(
          label: "compliance_ownership_text".tr(),
          hintText: "compliance_ownership_text".tr(),
          value: state.ownershipText,
          keyboardType: TextInputType.text,
          inputFormatters: [],
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
