import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchTitle extends StatelessWidget {
  final String text;
  const SearchTitle({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextWidget(
      text,
      fontColor: AppColor.hunterGreen,
      fontSize: 14,
      maxLines: 2,
    );
  }
}
