import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/widgets/self_rating_result_widgets/self_rating_result_section_item.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SelfRatingResultViolation extends StatelessWidget {
  final String title;
  final List<String> procdures;
  const SelfRatingResultViolation(
      {super.key, required this.title, required this.procdures});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 32),
      decoration: ShapeDecoration(
        color: AppColor.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomTextWidget(
              title,
              fontColor: AppColor.blackModern900Light,
              fontSize: 15,
              maxLines: 10,
              height: 1.3,
              fontWeight: AppFontWeight.bold,
            ),
            CustomVerticalSpace(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: ShapeDecoration(
                color: Color(0xFFF3F7F8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: procdures.length,
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 3,
                            width: 3,
                            decoration: BoxDecoration(
                                color: AppColor.black,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                          ),
                          CustomHorizontalSpace(width: 8),
                          Flexible(
                            child: CustomTextWidget(
                              procdures[index],
                              fontColor: AppColor.blackModern700Light,
                              fontSize: 12,
                              height: 1.3,
                              maxLines: 90,
                              fontWeight: AppFontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            )
          ]),
    );
  }
}
