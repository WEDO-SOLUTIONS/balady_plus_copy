import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/search_text_field_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class BookMarkAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BookMarkAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                ImagePath.zmzmBackground,
              ))),
      child: Column(children: [
        CustomVerticalSpace(height: MediaQuery.of(context).padding.top),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close,
                  color: AppColor.white,
                )),
            CustomTextWidget(
              ("bookmarks").tr(),
              fontColor: AppColor.blackModern50Light,
              fontSize: 20,
              fontWeight: AppFontWeight.bold,
            ),
            Container(
              height: 24,
              width: 24,
            )
          ],
        ),
      ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(136);
}
