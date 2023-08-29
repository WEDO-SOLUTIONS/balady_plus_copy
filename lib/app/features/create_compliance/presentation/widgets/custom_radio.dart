import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_bloc.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_event.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

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
        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    width: 1.5,
                    color: AppColor.blueSkyLight800,
                  )),
              child: RadioListTile(
                value: value ?? 0,
                groupValue: state.radioSelect,
                title: CustomTextWidget(
                  title,
                  textAlign: TextAlign.right,
                  textStyle: AppStyle.complianceFirstSubmitTitleRadioStyle,
                ),
                subtitle: CustomTextWidget(
                  subtitle,
                  maxLines: 2,
                  textAlign: TextAlign.right,
                  textStyle: AppStyle.complianceFirstSubmitSubtitleStyle,
                ),
                onChanged: (val) {
                  context
                      .read<ComplianceBloc>()
                      .add(RadioSelectEvent(val ?? 0));
                },
                activeColor:
                    state.radioSelect == value ? Color(0xff447F91) : null,
                secondary: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    CustomTextWidget(
                      'fees'.tr(),
                      textStyle: AppStyle.complianceFeesStyle,
                    ),
                    CustomTextWidget(
                      feesStatus,
                      textStyle: AppStyle.complianceFeesStatusStyle,
                    ),
                  ],
                ),
                selected: false,
              ),
            )
          ],
        );
      },
    );
  }
}
