import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CircularContainerForIcons extends StatelessWidget {
  const CircularContainerForIcons({
    required this.iconPath,
    required this.width,
    required this.height,
    Key? key,
  }) : super(key: key);
  final String iconPath;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      width: width,
      height: height,
      decoration:
          const BoxDecoration(color: Color(0x1FCDE0E0), shape: BoxShape.circle),
      child: Center(child: SvgPicture.asset(iconPath)),
    );
  }
}
