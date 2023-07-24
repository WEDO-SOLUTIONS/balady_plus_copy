import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart';
import '../../shared_feature_exports.dart';

class PlusAddButton extends StatelessWidget {
  const PlusAddButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  final Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: AppColor.primary900Light,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              size: 18,
              color: AppColor.primary900Light,
            ),
            CustomTextWidget(
              text,
              fontSize: 16,
              fontWeight: AppFontWeight.semiBold,
              fontColor: AppColor.primary900Light,
            ),
          ],
        ),
      ),
    );
  }
}
