import '/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

class TitleSubTitleWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  const TitleSubTitleWidget(
      {super.key, required this.subTitle, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyle.heading2BoldStyle
              .copyWith(color: AppColor.textPrimaryColor),
        ),
        /* const SizedBox(
          height: 8,
        ),
        Text(
          subTitle,
          style: AppStyle.footNoteRomanStyle.copyWith(color: Color(0xff566069)),
        ),*/
      ],
    );
  }
}
