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
      decoration: const BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                side: BorderSide(
                    color: AppColor.gray.withOpacity(0.50), width: 1),
                value: currentValue,
                onChanged: onSelect,
                checkColor: AppColor.white,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: AppColor.primary,
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Text(
                  title,
                  style: AppStyle.textRegularStyle
                      .copyWith(color: AppColor.textPrimaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
