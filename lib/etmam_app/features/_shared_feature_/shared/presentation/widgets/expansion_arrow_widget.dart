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
      width: 25.0,
      height: 25.0,
      decoration: const BoxDecoration(
        color: AppColor.white6,
        shape: BoxShape.circle,
      ),
      child: RotatedBox(
        quarterTurns: expanded ? 1 : 3,
        child: const Icon(Icons.arrow_back_ios_new, size: 13.0),
      ),
    );
  }
}
