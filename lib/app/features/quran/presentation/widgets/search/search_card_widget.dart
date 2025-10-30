import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/models/quran_search_sura_model.dart';
import '../../../data/models/quran_sura_info_model.dart';

class QuranSearchCardWidget extends StatelessWidget {
  final QuranSearchSuraModel item;
  final Function onTap;

  const QuranSearchCardWidget(
      {super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: AppColor.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextWidget(
                            "سورة ${item.suraName}",
                            fontWeight: AppFontWeight.semiBold,
                            fontSize: 12,
                            fontColor: AppColor.primary800Light,
                          ),
                          CustomVerticalSpace(height: 16),
                          Flexible(
                            child: CustomTextWidget(
                              item.aya,
                              maxLines: 10,
                              fontWeight: AppFontWeight.medium,
                              fontSize: 16,
                              fontFamily: "HafsSmart",
                              fontColor: AppColor.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(IconPath.suraIcon),
                  CustomTextWidget(
                    (item.ayahNo).toString(),
                    fontColor: AppColor.primary800Light,
                    fontSize: 14,
                    fontWeight: AppFontWeight.semiBold,
                  )
                ],
              ),
            ],
          )),
    );
  }
}
