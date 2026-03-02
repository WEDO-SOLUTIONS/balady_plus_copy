import 'package:flutter/material.dart';

import '../../../../core/services/services_exports.dart' show NavigationService;
import '../../../../core/utils/utils_exports.dart' show AppColor, ContextConversion;

class BottomNavBarStructure extends StatelessWidget {
  final double height;
  final List<Widget> children;

  const BottomNavBarStructure({
    Key? key,
    this.height = 100.0,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.only(bottom: context.bottomPadding * 0.5),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.primary900Light,
            AppColor.primary900Light,
            AppColor.primary900Light,
          ],
        ),
      ),
      child: Row(
        children: [
          ...children
              .map((child) => Container(
                    width: width / children.length,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: child,
                  ))
              .toList()
        ],
      ),
    );
  }

  BuildContext get context => NavigationService.bottomNavKey.currentContext!;
  double get width => context.screenWidth;
}
