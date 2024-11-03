import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';

class HomeCardItems extends StatelessWidget {
  final String title;
  final String image;
  final bool isLast;
  const HomeCardItems(
      {super.key,
      required this.title,
      required this.image,
      this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 221,
      width: ((MediaQuery.of(context).size.width - 48)) / 2,
      // margin: isLast ? null : const EdgeInsetsDirectional.only(end: 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        image: DecorationImage(
          image: AssetImage(image), // Path to your image
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(top: 26, end: 22, start: 16),
        child: Text(
          title,
          style: AppStyle.heading2BoldStyle.copyWith(color: AppColor.white),
        ),
      ),
    );
  }
}
