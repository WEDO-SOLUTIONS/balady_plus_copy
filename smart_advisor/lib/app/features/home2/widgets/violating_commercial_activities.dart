import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/features/home2/widgets/tags_text.dart';
import 'package:flutter/material.dart';

import '../../details/data/models/entity_violation_activity_model.dart';

class ViolatingCommercialActivities extends StatelessWidget {
  final EntityViolationActivityModel dataModel;

  const ViolatingCommercialActivities({super.key, required this.dataModel});

  @override
  Widget build(BuildContext context) {
    return card1();
  }

  Container card1() {
    return Container(
      margin: const EdgeInsets.only(bottom: 6, top: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: AppColor.surfacePrimaryColor,
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 4, bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dataModel.isCritical == "true" ? "جسيمة" : "غير جسيمة",
              style: AppStyle.textRegularRomanStyle.copyWith(
                  color: dataModel.isCritical == "true"
                      ? const Color(0xffE0373D)
                      : AppColor.textPrimaryColor),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              dataModel.description ?? "",
              style: AppStyle.footNoteRomanStyle
                  .copyWith(color: AppColor.textPrimaryColor),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "المسوؤل عن المخالفة",
                    style: AppStyle.footNoteRomanStyle
                        .copyWith(color: AppColor.textSecondaryColor),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: dataModel.violatorList
                              ?.map(
                                (e) => RoundedCardWithText(
                                    text: e.violatorIdType ?? ""),
                              )
                              .toList() ??
                          [])
                ],
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Container(
                // height: 40,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: AppColor.surfaceSecondaryColor,
                    borderRadius: BorderRadius.circular(6)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "تبدأ من",
                      style: AppStyle.captionRomanStyle
                          .copyWith(color: AppColor.textSecondaryColor),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text:
                                    "${dataModel.fineAmount.toString() ?? ""} ",
                                style: AppStyle.calloutBoldStyle),
                            if ((dataModel.unitType ?? "").isNotEmpty)
                              TextSpan(
                                text: " / ",
                                style: AppStyle.captionRomanStyle
                                    .copyWith(color: AppColor.textPrimaryColor),
                              ),
                            TextSpan(
                              text: dataModel.unitType ?? "",
                              style: AppStyle.captionRomanStyle
                                  .copyWith(color: AppColor.textPrimaryColor),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
