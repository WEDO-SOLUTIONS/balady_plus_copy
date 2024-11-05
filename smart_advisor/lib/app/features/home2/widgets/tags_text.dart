import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import 'package:flutter/material.dart';

class RoundedCardWithText extends StatefulWidget {
  final String text;
  const RoundedCardWithText({super.key, required this.text});

  @override
  State<RoundedCardWithText> createState() => _RoundedCardWithTextState();
}

class _RoundedCardWithTextState extends State<RoundedCardWithText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(left: 2, right: 2),
      decoration: BoxDecoration(
          //   color: const Color(0x1C568F64),
          borderRadius: BorderRadius.circular(6)),
      //margin: const EdgeInsets.all(8),
      //padding: const EdgeInsets.all(4),

      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Center(
          child: Text(
            widget.text,
            style: AppStyle.footNoteMediumStyle
                .copyWith(color: AppColor.textPrimaryColor),
          ),
        ),
      ),
    );
  }
}
