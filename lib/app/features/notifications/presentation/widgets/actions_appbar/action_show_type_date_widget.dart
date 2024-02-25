import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';

class ActionShowTypeDateWidget extends StatelessWidget {
  const ActionShowTypeDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPopupMenu<int>(
      menuItems: const [
        PopupMenuItem(
          value: 1,
          child: Text('تحديد الكل كمقروء'),
        ),
        PopupMenuItem(
          value: 2,
          child: Text('حذف الكل'),
        ),
      ],
      initialValue: 0,
      onSelected: (int value) {

      },
      onCanceled: () {

      },
      tooltip: "",
      elevation: 12,
      icon: const Icon(Icons.menu,color: Colors.black,),
      offset: const Offset(0, 65),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),

      ),

      color: Colors.white,
    );
  }
}
