import 'package:flutter/material.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';

class NotificationTypeWidget extends StatelessWidget {
  final bool isSelected;
  final String title;
  final int count;

  const NotificationTypeWidget({
    super.key,
    required this.isSelected,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        color: isSelected ? AppColor.primary700Light : AppColor.white10,
        elevation: isSelected ? 2 : 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: SizedBox(
          height: 40,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppStyle.blackTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.grey,
                  ),
                ),
                const SizedBox(width: 4, height: double.maxFinite),
                Text(
                  '($count)',
                  style: AppStyle.serviceTitleStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.grey,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
