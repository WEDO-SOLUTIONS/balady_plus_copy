import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const colorShadow = NonThemeColor.color71;
const colorIconPositive = NonThemeColor.color3;
const colorIconError = NonThemeColor.color1;

const headerHeight = 124.0;
const footerHeight = 50.0;
const gapHeight = 16.0;

const borderRadius = BorderRadius.all(Radius.circular(8));
const customBoxDecoration = BoxDecoration(borderRadius: borderRadius);

class FooterIconButton extends StatelessWidget {
  const FooterIconButton({
    this.assetName,
    this.desc,
    this.onTap,
    this.colorIcon,
    this.colorButton,
    this.flex = 1,
    super.key,
  });

  final String? assetName;
  final void Function()? onTap;
  final Color? colorIcon;
  final Color? colorButton;
  final Widget? desc;
  final int flex;

  @override
  Widget build(BuildContext context) {
    final description = desc;
    final defaultBgColor = context.color.textAndIconsBasePrimary.withOpacity(0.05);
    return Flexible(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: colorButton ?? defaultBgColor,
          borderRadius: borderRadius,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onTap,
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 40,
                maxHeight: 40,
                minWidth: 52,
              ),
              decoration: customBoxDecoration,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (assetName != null)
                      SvgPicture.asset(
                        key: ValueKey(assetName),
                        assetName!,
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(
                          colorIcon ?? context.color.textAndIconsBasePrimary,
                          BlendMode.srcATop,
                        ),
                        matchTextDirection: true,
                      ),
                    if (description != null) ...[
                      const SizedBox(width: 8),
                      Flexible(child: description),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
