import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomCircularContainerForIcons extends StatelessWidget {
  const CustomCircularContainerForIcons({
    required this.child,
    this.color,
    Key? key,
  }) : super(key: key);

  CustomCircularContainerForIcons.green({
    required this.child,
    Key? key,
  })  : color = Color(0xFF358281).withOpacity(0.1),
        super(key: key);

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
          color: color ?? Color(0x1FCDE0E0), shape: BoxShape.circle),
      child: Center(child: child),
    );
  }
}
