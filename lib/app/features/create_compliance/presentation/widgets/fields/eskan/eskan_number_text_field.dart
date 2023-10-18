import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/create_compliance/domain/use_cases/get_land_contract.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../_shared_feature_/presentation/widgets/check_boxes/text_field_with_check_btn.dart';
import '../../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../bloc/compliance_bloc.dart';
import '../../../bloc/compliance_event.dart';
import '../../../bloc/compliance_state.dart';

class EskanNumberTextField extends StatefulWidget {
  const EskanNumberTextField({super.key});

  @override
  State<EskanNumberTextField> createState() => _EskanNumberTextFieldState();
}

class _EskanNumberTextFieldState extends State<EskanNumberTextField> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return TextWithCheckBtn(
          title: "user_data_applicant_id".tr(),
          hint: "user_data_applicant_id".tr(),
          controller: controller,
          currentValue: CommonProperties.selectedAgent != null
              ? CommonProperties.selectedAgent?.grantorNumber
              : CommonProperties.userInfo?.idNo,
          // keyboardType: TextInputType.text,
          //  inputFormatters: [],

          onTextChanged: (String? text) {},
          verify: () {
            context
                .read<ComplianceBloc>()
                .add(const GetComplianceLandContractEvent());
          },
          enabled: false,
          backgroundColor: Colors.transparent,
          isValidate: state.landSubsidyContract != null,
          validate: (String? t) {},
        );
      },
    );
  }
}
