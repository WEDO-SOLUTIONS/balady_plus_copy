import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

class GaussianSplattingEntryPointCard extends StatelessWidget {
  final String title;
  final String path;
  final String? subtitle;
  final String buttonText;
  final List<Color> gradientColors;
  final VoidCallback? onTap;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? ctaBackground;
  final Color? ctaTextColor;

  const GaussianSplattingEntryPointCard({
    required this.path,
    required this.gradientColors,
    required this.title,
    this.subtitle,
    this.buttonText = 'Start virtual tour',
    this.onTap,
    this.titleColor,
    this.subtitleColor,
    this.ctaBackground,
    this.ctaTextColor,
    super.key,
  });

  static const double _cardHeight = 177;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
    child: GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: _cardHeight,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(RadiusBorder.xl),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(path, package: AssetGenImage.package, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(Spacing.$4x),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 216,
                        child: Text(
                          title,
                          style: context.textStyles.h3SemiBold.copyWith(
                            color: titleColor ?? const Color(0xFF4A3016),
                          ),
                        ),
                      ),
                      if (subtitle != null && subtitle!.isNotEmpty) ...[
                        const SizedBox(height: Spacing.$1x),
                        SizedBox(
                          width: 216,
                          child: Text(
                            subtitle!,
                            style: context.textStyles.h3SemiBold.copyWith(
                              color: subtitleColor ?? const Color.fromARGB(255, 19, 14, 8),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              height: 16 / 13,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.$3x,
                            vertical: Spacing.$2x,
                          ),
                          decoration: BoxDecoration(
                            color: ctaBackground ?? context.colors.staticWhite,
                            borderRadius: BorderRadius.circular(
                              Spacing.$2x,
                            ),
                          ),
                          child: Text(
                            buttonText,
                            style: context.textStyles.h3SemiBold.copyWith(
                              color: ctaTextColor ?? const Color(0xFFC56846),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 16 / 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
