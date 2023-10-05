import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_radio_button_widget.dart';
import '../../../../../../core/utils/constants/app_style.dart';
import '../../../bloc/compliance_bloc.dart';
import '../../../bloc/compliance_event.dart';

class DeedTypeWidget extends StatefulWidget {
  const DeedTypeWidget({super.key});

  @override
  State<DeedTypeWidget> createState() => _DeedTypeWidgetState();
}

class _DeedTypeWidgetState extends State<DeedTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return Row(
          children: [
            CustomRadioButtonWidget(
                label: 'compliance_deed_number_paper'.tr(),
                labelStyle: AppStyle.createComplianceRiyadhRadioStyle,
                radioLabelSpace: 0,
                onSelected: (p0) {
                  context
                      .read<ComplianceBloc>()
                      .add(UpdateFieldsEvent(isDeedPaper: true));
                },
                radioValue: 0,
                radioGroupValue: state.isDeedPaper == false
                    ? 1
                    : state.isDeedPaper == true
                        ? 0
                        : null),
            CustomRadioButtonWidget(
                label: 'compliance_deed_number_electronic'.tr(),
                labelStyle: AppStyle.createComplianceRiyadhRadioStyle,
                radioLabelSpace: 0,
                onSelected: (p0) {
                  context
                      .read<ComplianceBloc>()
                      .add(UpdateFieldsEvent(isDeedPaper: false));
                },
                radioValue: 1,
                radioGroupValue: state.isDeedPaper == false
                    ? 1
                    : state.isDeedPaper == true
                        ? 0
                        : null),
          ],
        );
      },
    );
  }
}
