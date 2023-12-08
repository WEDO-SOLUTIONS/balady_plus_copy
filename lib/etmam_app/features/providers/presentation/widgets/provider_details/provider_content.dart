import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../app/core/utils/constants/app_colors.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class ProviderDetailsContentContainer extends StatelessWidget {
  const ProviderDetailsContentContainer({
    required this.title,
    required this.content,
    this.isCenter = false,
    this.icon,
    this.fontSize = 13,
    this.onTap,
    super.key,
  });
  final String title;
  final Widget content;
  final String? icon;
  final bool isCenter;
  final double fontSize;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 72,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              isCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  isCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                icon != null
                    ? SvgPicture.asset(
                        icon!,
                        width: 16,
                        height: 16,
                      )
                    : const SizedBox(),
                const SizedBox(
                  width: 5,
                ),
                CustomTextWidget(
                  title,
                  fontSize: fontSize,
                  fontWeight: AppFontWeight.bold,
                  fontColor: AppColor.blackModern800Light,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            content,
          ],
        ),
      ),
    );
  }
}
