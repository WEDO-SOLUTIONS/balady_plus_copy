import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';

class ActivityItemCard extends StatelessWidget {
  final String id;
  final String name;
  final int index;
  final bool isSelected;
  final Function onPress;
  const ActivityItemCard(
      {super.key,
      required this.id,
      required this.name,
      required this.index,
      required this.isSelected,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPress(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: const Color(0xff568F64), width: 1.5)
              : null,
          color: AppColor.surfaceTertairyColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                name,
                style: AppStyle.textRegularStyle
                    .copyWith(color: AppColor.textPrimaryColor),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            //   SvgPicture.asset(IconPath.arrowLeftSide)
          ],
        ),
      ),
    );
  }
}
