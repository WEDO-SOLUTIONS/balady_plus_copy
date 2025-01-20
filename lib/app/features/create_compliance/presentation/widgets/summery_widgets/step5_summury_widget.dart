import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../domain/entities/comliance_request_details.dart';
import '../../bloc/compliance_bloc.dart';
import '../../bloc/compliance_state.dart';
import '../../dialogs/complince_notes_dialog.dart';
import '../compliance_clauses_submit_item_widget.dart';
import '../compliance_submission/sixth_submit_step.dart';
import 'field_data.dart';
import 'package:collection/collection.dart';

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
                        item: state.requestDetails!.emtithalItems![index]),
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

//ComplianceClauseSubmitItem
class ComplianceFieldData extends StatelessWidget {
  final EmtithalItem item;
  final BorderRadius? radius;

  const ComplianceFieldData({super.key, required this.item, this.radius});

  @override
  Widget build(BuildContext context) {
    ItemData? lastNote = item.itemData
        ?.firstWhereOrNull((element) => element.isLastNote == true);
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
                  item.itemDesc ?? "",
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
                item.submitterAnswer == 1
                    ? "compliance".tr()
                    : item.submitterAnswer == 0
                        ? "nonـcompliance".tr()
                        : item.submitterAnswer == 2
                            ? "Not_Applicable".tr()
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
                item.empAnswer == 1
                    ? "compliance".tr()
                    : item.empAnswer == 0
                        ? "nonـcompliance".tr()
                        : item.empAnswer == 2
                            ? "Not_Applicable".tr()
                            : "",
                fontColor: AppColor.blackModern600Light,
                fontSize: 13,
                maxLines: 1,
                textAlign: TextAlign.start,
                fontWeight: AppFontWeight.semiBold,
              ),
            ],
          ),
          if (item.itemData?.isNotEmpty ?? false) ...[
            if (lastNote != null) ComplianceClauseNotesItem(item: lastNote),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                CustomPopUpsWidgets.showBottomSheet(
                    NavigationService.navigatorKey.currentContext!,
                    child: ComplainceNotesDialog(
                      itemData: item.itemData,
                    ));
              },
              child: CustomTextWidget(
                "compliance_show_prevoius_notes".tr(),
                fontColor: AppColor.primary900Light,
                fontSize: 16,
              ),
            )
          ]
        ],
      ),
    );
  }
}
