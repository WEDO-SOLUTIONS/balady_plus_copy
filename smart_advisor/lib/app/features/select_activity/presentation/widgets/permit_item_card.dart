import '/app/core/utils/utils_exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../shared_features/widgets/check_box_item.dart';

class PermitItemCard extends StatelessWidget {
  final bool currentValue;
  final Function(bool?) onSelect;
  final String title;
  final bool isFreeOfCharge;

  const PermitItemCard(
      {super.key,
      required this.currentValue,
      required this.onSelect,
      required this.title,
      required this.isFreeOfCharge});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.surfaceSecondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: currentValue,
                onChanged: onSelect,
                checkColor: AppColor.white,
                activeColor: AppColor.statusAccentColor,
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Text(
                  title,
                  style: AppStyle.textRegularRomanStyle
                      .copyWith(color: AppColor.textPrimaryColor),
                ),
              ),
            ],
          ),
          Text(
            isFreeOfCharge ? "برسوم" : "بدون رسوم",
            style: AppStyle.textRegularRomanStyle
                .copyWith(color: AppColor.textSecondaryColor),
          ),
        ],
      ),
    );
  }
}
