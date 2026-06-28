import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';

//!
class CustomSubCardsOfSubCategory extends StatelessWidget {
  final String iconPath;

  const CustomSubCardsOfSubCategory({super.key, required this.iconPath});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: context.w(36),
    height: context.h(36),
    child: Padding(
      padding: const EdgeInsets.all(2),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF01222E) : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: CustomNetworkImageWidget(
            iconPath,
            isVerifyingKey: true,
            imageWidth: context.w(26),
            imageHeight: context.h(26),
          ),
        ),
      ),
    ),
  );
}
