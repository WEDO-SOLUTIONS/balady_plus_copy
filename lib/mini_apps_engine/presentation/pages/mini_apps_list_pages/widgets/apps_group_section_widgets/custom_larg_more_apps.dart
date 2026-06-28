import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:flutter/material.dart';

class CustomLargMoreApps extends StatelessWidget {
  final double? width;
  final double? height;
  final double? iconWidth;
  final double? iconHeight;
  final double? textWidth;
  final double? textHeight;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final Widget? child;
  final String? text;
  final bool withCardEffect;
  final List<BoxShadow>? boxShadow;
  final void Function()? onTap;
  final List<MiniApp> apps;
  final int totalAppCount;

  final String categoryName;
  final String categoryIconPath;

  const CustomLargMoreApps({
    super.key,
    this.width,
    this.height,
    this.textWidth,
    this.textHeight,
    this.iconHeight,
    this.iconWidth,
    this.backgroundColor,
    this.borderRadius,
    this.child,
    this.text,
    this.withCardEffect = false,
    this.boxShadow,
    required this.onTap,
    required this.apps,
    required this.totalAppCount,
    required this.categoryName,
    required this.categoryIconPath,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaler.scale(1.0);
    final cardHeight = height ?? (context.h(98) * (1.0 + (textScale - 1.0) * 0.45));

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            width: context.w(117),
            height: cardHeight,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              color: Theme.of(context).primaryColorLight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomNetworkImageWidget(
                    categoryIconPath,
                    isVerifyingKey: true,
                    imageFit: BoxFit.contain,
                    imageWidth: context.w(51),
                    imageHeight: context.h(51),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: AutoSizeText(
                          maxLines: 3,
                          maxFontSize: 14,
                          minFontSize: 10,
                          categoryName,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center, // Good practice for grid items
                          style: const TextStyle(fontFamily: GeneralKey.appFontType, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyCardWidget extends StatelessWidget {
  const EmptyCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.w(64.37),
      height: context.h(64.37),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
