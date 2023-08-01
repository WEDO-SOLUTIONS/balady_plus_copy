import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../home_page/home_exports.dart';
import '../../violations_exports.dart'
    show ViolationsParameter, ViolationsEntity;

class ViolationsListItem extends StatelessWidget {
  final ViolationsEntity violations;
  final Function onApply;
  final Function onDetails;
  const ViolationsListItem(
      {super.key,
      required this.violations,
      required this.onApply,
      required this.onDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: AppColor.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const DrawIconBasedTypeWidget(icon: IconPath.requests),
              const SizedBox(width: 4),
              CustomTextWidget(
                'المخالفه'.tr(),
                textStyle: AppStyle.cardTitleTextStle,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: CustomTextWidget(
                  '#${violations.violationNumber}',
                  textStyle: AppStyle.requestNumberTextStle,
                ),
              ),
              HomeTag(
                title: violations.billStatusName ?? '',
                backgroundColor: AppColor.secondary100Light,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              children: [
                ViolationsParameter(
                  title: 'رقم فاتورة المخالفة'.tr(),
                  value: violations.billNumber??'',
                ),
                ViolationsParameter(
                  title: 'تاريخ اصدار المخالفه'.tr(),
                  value: violations.violationIssueDate != null
                      ? DateFormat.yMd().format(violations.violationIssueDate!)
                      : "",
                ),
                ViolationsParameter(
                  title: 'اخر موعد للاعتراض'.tr(),
                  value: violations.objectionLastApplyDate != null
                      ? DateFormat.yMd().format(violations.objectionLastApplyDate!)
                      : "",
                ),
                ViolationsParameter(
                  title: 'قيمه الغرامه'.tr(),
                  value: violations.violationAmount.toString(),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                  flex: 10,
                  child: ElevatedButtonWidget.details(
                      onPressed: () => onDetails())),
              // if (violations.isAllowedForObjection?.toLowerCase() ==
              //     "true") ...[
              //   const Expanded(flex: 1, child: CustomVerticalSpace(height: 16)),
              //   Expanded(
              //       flex: 10,
              //       child: ElevatedButtonWidget.applyObjection(
              //           onPressed: () => onApply())),

            ],
          ),
        ],
      ),
    );
  }
}
