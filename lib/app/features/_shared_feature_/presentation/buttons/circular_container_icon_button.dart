import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CircularContainerForIcons extends StatelessWidget {
  const CircularContainerForIcons({
    required this.iconPath,
    required this.width,
    required this.height,
    this.color,
    this.onTap,
    super.key,
  });
  final String iconPath;
  final double width;
  final double height;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 16),
        width: width,
        height: height,
        decoration: BoxDecoration(color: color ?? const Color(0x1FCDE0E0), shape: BoxShape.circle),
        child: Center(child: SvgPicture.asset(iconPath)),
      ),
    );
  }
}
