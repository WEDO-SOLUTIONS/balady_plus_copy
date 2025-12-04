import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:flutter/material.dart';

class CustomSubCardsOfLargCard extends StatelessWidget {
  final String iconPath;
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
            child: CustomNetworkImageWidget(
              iconPath,
              sso: true,
              ssoAuth: true,
              imageWidth: context.w(42),
              imageHeight: context.h(42),
            ),
          )
          /*
         Center(
          child: SvgPicture.asset(
            iconPath ?? "",
            width: context.w(42),
            height: context.h(42),
          ),
        ),
        */
          ),
    );
  }
}
