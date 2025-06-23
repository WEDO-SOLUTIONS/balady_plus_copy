import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/models/quran_sura_info_model.dart';

class QuranJozzCardWidget extends StatelessWidget {
  final int index;
  final Function onTap;

  const QuranJozzCardWidget(
      {super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
          padding: EdgeInsets.all(16),
          height: 90,
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
                          Flexible(
                            child: CustomTextWidget(
                              "الجزء $index",
                              maxLines: 2,
                              fontWeight: AppFontWeight.medium,
                              fontSize: 26,
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
                    (index).toString(),
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
