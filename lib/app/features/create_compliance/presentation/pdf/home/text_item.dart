import 'package:flutter/material.dart';

import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';

class TextItem extends StatelessWidget {
  final String name;
  final double size;
  final String desc;
  const TextItem(
      {super.key, required this.name, required this.desc, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              color: const Color(0xFF145E75),
              fontSize: size,
              fontFamily: 'packages/balady_uikit/Frutiger',
              fontWeight: FontWeight.w700,
            ),
          ),
          const CustomVerticalSpace(
            height: 8,
          ),
          Text(
            desc,
            style: const TextStyle(
              color: Color(0xFF52525B),
              fontSize: 14,
              height: 1.4,
              fontFamily: 'packages/balady_uikit/Frutiger',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
