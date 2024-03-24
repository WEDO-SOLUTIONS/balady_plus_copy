import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../bloc/compliance_bloc.dart';
import '../../bloc/compliance_state.dart';
import 'field_data.dart';

class Step5SummeryWidget extends StatelessWidget {
  const Step5SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("compliance_clauses_title").tr(),
          leading: SvgPicture.asset(IconPath.vdSummuryDesc),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: state.requestDetails?.emtithalItems?.length ?? 0,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ComplianceFieldData(
                      title: state
                              .requestDetails?.emtithalItems?[index].itemDesc ??
                          "",
                      submitterAnswer: state.requestDetails
                          ?.emtithalItems?[index].submitterAnswer,
                      empAnswer:
                          state.requestDetails?.emtithalItems?[index].empAnswer,
                    ),
                    CustomVerticalSpace(height: 8),
                  ],
                );
              },
            )
          ],
        );
      },
    );
  }
}

class ComplianceFieldData extends StatelessWidget {
  final String title;
  final bool? submitterAnswer;
  final bool? empAnswer;
  final BorderRadius? radius;

  const ComplianceFieldData(
      {super.key,
      required this.title,
      this.submitterAnswer,
      this.empAnswer,
      this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Color(0x80E6EFEF),
          borderRadius: radius ?? BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: CustomTextWidget(
                  title,
                  fontColor: AppColor.primary700Light,
                  fontSize: 12,
                  maxLines: 10,
                  fontWeight: AppFontWeight.semiBold,
                ),
              ),
            ],
          ),
          const CustomVerticalSpace(height: 16),
          Row(
            children: [
              CustomTextWidget(
                "submitter_compliance_text".tr(),
                fontColor: AppColor.blackModern600Light,
                fontSize: 14,
                maxLines: 1,
                textAlign: TextAlign.start,
                fontWeight: AppFontWeight.semiBold,
              ),
              CustomTextWidget(
                submitterAnswer == true
                    ? "yes".tr()
                    : submitterAnswer == false
                        ? "no".tr()
                        : "",
                fontColor: AppColor.blackModern600Light,
                fontSize: 13,
                maxLines: 1,
                textAlign: TextAlign.start,
                fontWeight: AppFontWeight.semiBold,
              ),
            ],
          ),
          const CustomVerticalSpace(height: 8),
          Row(
            children: [
              CustomTextWidget(
                "emp_compliance_text".tr(),
                fontColor: AppColor.blackModern600Light,
                fontSize: 14,
                maxLines: 1,
                textAlign: TextAlign.start,
                fontWeight: AppFontWeight.semiBold,
              ),
              CustomTextWidget(
                empAnswer == true
                    ? "yes".tr()
                    : empAnswer == false
                        ? "no".tr()
                        : "",
                fontColor: AppColor.blackModern600Light,
                fontSize: 13,
                maxLines: 1,
                textAlign: TextAlign.start,
                fontWeight: AppFontWeight.semiBold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
