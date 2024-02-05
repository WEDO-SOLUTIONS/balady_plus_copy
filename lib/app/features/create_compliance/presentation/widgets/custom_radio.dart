import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_bloc.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_event.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';

class RadioCustomWidget extends StatelessWidget {
  const RadioCustomWidget({
    super.key,
    required this.feesStatus,
    required this.subtitle,
    required this.title,
    this.value,
  });
  final String title;
  final String subtitle;
  final int? value;
  final String feesStatus;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), //Rev: should be 8 not 5
              border: Border.all(
                width: 1, //Rev: should be 1 not 1.5
                color: AppColor.blueSkyLight800,
              )),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Radio(
              value: value,
              activeColor: state.benificiaryTypeSelection == value
                  ? AppColor.primary700Light
                  : null,
              groupValue: state.benificiaryTypeSelection,
              onChanged: (value) {
                context
                    .read<ComplianceBloc>()
                    .add(UpdateFieldsEvent(benificiaryTypeSelection: value));
              },
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    title,
                    textAlign: TextAlign.start,
                    textStyle: AppStyle.complianceFirstSubmitTitleRadioStyle,
                  ),
                  CustomVerticalSpace(
                    height: 4,
                  ),
                  CustomTextWidget(
                    subtitle,
                    maxLines: 4,
                    textAlign: TextAlign.start,
                    textStyle: AppStyle.complianceFirstSubmitSubtitleStyle,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    'fees'.tr(),
                    textStyle: AppStyle.complianceFeesStyle,
                  ),
                  CustomTextWidget(
                    feesStatus,
                    maxLines: 3,
                    textStyle: AppStyle.complianceFeesStatusStyle,
                  ),
                ],
              ),
            )
          ]),
        );
      },
    );
  }
}

class CustomRadio1 extends StatelessWidget {
  const CustomRadio1({
    super.key,
    required this.feesStatus,
    required this.subtitle,
    required this.title,
    this.value,
  });
  final String title;
  final String subtitle;
  final int? value;
  final String feesStatus;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return Container(
          // padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), //Rev: should be 8 not 5
              border: Border.all(
                width: 1, //Rev: should be 1 not 1.5
                color: AppColor.blueSkyLight800,
              )),
          child: RadioListTile(
            value: value ?? 0,
            contentPadding: EdgeInsets.all(8),
            groupValue: state.benificiaryTypeSelection,
            title: CustomTextWidget(
              title,
              maxLines: 10,
              textAlign: TextAlign.start,
              textStyle: AppStyle.complianceFirstSubmitTitleRadioStyle,
            ),
            subtitle: CustomTextWidget(
              subtitle,
              maxLines: 2,
              textAlign: TextAlign.start,
              height: 1.6,
              textStyle: AppStyle.complianceFirstSubmitSubtitleStyle,
            ),
            onChanged: (val) {
              context
                  .read<ComplianceBloc>()
                  .add(UpdateFieldsEvent(benificiaryTypeSelection: val));
            },
            activeColor: state.benificiaryTypeSelection == value
                ? AppColor.primary700Light
                : null,
            secondary: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextWidget(
                  'fees'.tr(),
                  textAlign: TextAlign.start,
                  textStyle: AppStyle.complianceFeesStyle,
                ),
                CustomTextWidget(
                  feesStatus,
                  textAlign: TextAlign.start,
                  textStyle: AppStyle.complianceFeesStatusStyle,
                ),
              ],
            ),
            selected: false,
          ),
        );
      },
    );
  }
}
