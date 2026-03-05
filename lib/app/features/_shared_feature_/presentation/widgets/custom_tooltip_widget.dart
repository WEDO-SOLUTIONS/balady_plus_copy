import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';

class CustomTooltipWidget extends StatelessWidget {
  final Widget child;
  final String message;

  const CustomTooltipWidget({Key? key, required this.message, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(7),
      preferBelow: true,
      showDuration: const Duration(seconds: 3),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.black100, width: 1),
        boxShadow: const [BoxShadow(color: Color(0x1c000000), offset: Offset(0, 2), blurRadius: 4, spreadRadius: 0)],
        color: const Color(0xfffdfcfc),
      ),
      textStyle: const TextStyle(color: Color(0xff8a8a89), fontFamily: Constants.appFontType),
      triggerMode: TooltipTriggerMode.tap,
      message: message,
      child: child,
    );
  }
}
