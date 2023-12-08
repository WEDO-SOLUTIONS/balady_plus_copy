import 'package:flutter/material.dart';

import '../../../../../../app/core/utils/constants/app_colors.dart';

class ExpansionArrowWidget extends StatelessWidget {
  final bool expanded;

  const ExpansionArrowWidget({
    Key? key,
    required this.expanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: AppColor.primary800Light2,
        shape: BoxShape.circle,
      ),
      child: RotatedBox(
        quarterTurns: expanded ? 1 : 3,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 11.0,
            color: AppColor.white,
          ),
        ),
      ),
    );
  }
}
