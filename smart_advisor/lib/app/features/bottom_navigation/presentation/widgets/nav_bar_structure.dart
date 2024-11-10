import 'package:flutter/material.dart';

import '../../../../core/services/services_exports.dart' show NavigationService;
import '../../../../core/utils/utils_exports.dart'
    show  ContextConversion;

class BottomNavBarStructure extends StatelessWidget {
  final double height;
  final List<Widget> children;

  const BottomNavBarStructure({
    Key? key,
    this.height = 90.0,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.only(bottom: context.bottomPadding * 0.5),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1E087972),
            blurRadius: 20,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Center(
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
      ),
    );
  }

  BuildContext get context => NavigationService.bottomNavKey.currentContext!;

  double get width => context.screenWidth;
}
