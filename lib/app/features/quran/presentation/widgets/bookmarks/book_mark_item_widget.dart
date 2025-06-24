import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../data/models/quran_book_mark_item_model.dart';

class BookMarkItem extends StatelessWidget {
  final QuranBookMarkItemModel item;

  const BookMarkItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      margin: EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: AppColor.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        CustomTextWidget(
          item.suraName,
          maxLines: 2,
          fontWeight: AppFontWeight.medium,
          fontSize: 26,
          fontColor: AppColor.black,
        ),
        Column(
          children: [
            SvgPicture.asset(IconPath.quranMarkIcon),
            Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(IconPath.suraIcon),
                CustomTextWidget(
                  (item.pageNumber).toString(),
                  fontColor: AppColor.primary800Light,
                  fontSize: 14,
                  fontWeight: AppFontWeight.semiBold,
                )
              ],
            ),
          ],
        )
      ]),
    );
  }
}
