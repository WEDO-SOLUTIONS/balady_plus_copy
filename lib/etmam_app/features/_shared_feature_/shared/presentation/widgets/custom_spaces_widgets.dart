import 'package:flutter/material.dart';

class CustomVerticalSpace extends StatelessWidget {
  final double height;
  const CustomVerticalSpace({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class CustomHorizontalSpace extends StatelessWidget {
  final double width;
  const CustomHorizontalSpace({Key? key, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}
