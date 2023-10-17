import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/app_style.dart';
import '../../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget.dart';
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
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(
                    230,
                    239,
                    239,
                    0.40,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: CustomRadioButtonWidget(
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
              ),
            ),
            SizedBox(
              width: 32,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(
                    230,
                    239,
                    239,
                    0.40,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: CustomRadioButtonWidget(
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
              ),
            ),
          ],
        );
      },
    );
  }
}
