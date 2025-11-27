import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSubCardsOfLargCard extends StatelessWidget {
  final String? iconPath;
  const CustomSubCardsOfLargCard({super.key, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.w(64.37),
      height: context.h(64.37),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0XFFE5EBED),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: SvgPicture.asset(
            iconPath ?? "",
            width: context.w(42),
            height: context.h(42),
          ),
        ),
      ),
    );
  }
}
