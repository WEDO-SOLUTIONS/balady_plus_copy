import 'package:flutter/material.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';

class Headergreen extends StatefulWidget {
  const Headergreen({super.key});

  @override
  State<Headergreen> createState() => _HeadergreenState();
}

class _HeadergreenState extends State<Headergreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // Green top bar with curved bottom
      Container(
        height: 180,
        decoration: BoxDecoration(
          color: AppColor.primary, // Green background color
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      const Textfield(),
    ]);
  }
}
