import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActionShowTypeDateWidget extends StatelessWidget {
  const ActionShowTypeDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPopupMenu<int>(
      menuItems:  [
        PopupMenuItem(
          value: 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(IconPath.check),
              const SizedBox(width: 12),
              const Text('تحديد الكل كمقروء'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(IconPath.trash01),
              const SizedBox(width: 12),
              const Text('حذف الكل'),
            ],
          ),
        ),
      ],
      initialValue: 0,
      onSelected: (int value) {

      },
      onCanceled: () {

      },
      tooltip: "",
      elevation: 12,
      icon: SvgPicture.asset(IconPath.dotsVertical),
      offset: const Offset(0, 65),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),

      ),
      color: Colors.white,
    );
  }
}
