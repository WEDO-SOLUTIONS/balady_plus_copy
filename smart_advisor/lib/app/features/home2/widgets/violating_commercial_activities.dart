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
      margin: const EdgeInsets.all(10),
      color: AppColor.surfacePrimaryColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 4, bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "المخالفة",
              style: AppStyle.footNoteRomanStyle
                  .copyWith(color: AppColor.textSecondaryColor),
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
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColor.surfaceSecondaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
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
            Container(
                height: 65,
                margin: const EdgeInsets.only(
                    top: 5, left: 12, right: 12, bottom: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(
                    "تبدأ من",
                    style: AppStyle.captionRomanStyle
                        .copyWith(color: AppColor.textSecondaryColor),
                  ),
                  trailing: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: dataModel.fineAmount.toString() + " ",
                            style: AppStyle.calloutBoldStyle),
                        TextSpan(
                          text: dataModel.unitType ?? "",
                          style: AppStyle.captionRomanStyle
                              .copyWith(color: AppColor.textPrimaryColor),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Container card2() {
    return Container(
      height: 218,
      margin: const EdgeInsets.all(10),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 4, bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "المخالفة",
              style: AppStyle.footNoteRomanStyle
                  .copyWith(color: AppColor.textSecondaryColor),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "ممارسة النشاط دون الحصول على ترخيص بلدي",
              style: AppStyle.footNoteRomanStyle
                  .copyWith(color: AppColor.textPrimaryColor),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 75,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColor.surfaceSecondaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RoundedCardWithText(text: "مكتب هندسي"),
                      RoundedCardWithText(text: "شركة"),
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 5, left: 12, right: 12, bottom: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6)),
              child: ListTile(
                title: Text(
                  "تبدأ من",
                  style: AppStyle.captionRomanStyle
                      .copyWith(color: AppColor.textSecondaryColor),
                ),
                trailing: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "200", style: AppStyle.calloutBoldStyle),
                      TextSpan(
                        text: ' ريال / للرخصة',
                        style: AppStyle.captionRomanStyle
                            .copyWith(color: AppColor.textPrimaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
