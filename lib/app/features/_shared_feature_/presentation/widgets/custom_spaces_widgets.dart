import 'package:flutter/material.dart';

class CustomVerticalSpace extends StatelessWidget {
  final double height;
  const CustomVerticalSpace({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class CustomHorizontalSpace extends StatelessWidget {
  final double width;
  const CustomHorizontalSpace({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}
