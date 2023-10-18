import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart';

class CardStructure extends StatelessWidget {
  final Widget child;
  const CardStructure({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: UIHelper.mediumPadding,
        horizontal: UIHelper.smallPadding,
      ),
      margin: const EdgeInsets.only(bottom: UIHelper.smallPadding),
      decoration: BoxDecoration(
        color: AppColor.blue,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColor.gray),
      ),
      child: child,
    );
  }
}
