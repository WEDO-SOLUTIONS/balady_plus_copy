import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

class BetterRouteButton extends StatelessWidget {
  const BetterRouteButton({
    required this.title,
    this.onTap,
    this.onCloseTap,
    Key? key,
  }) : super(key: key);

  final String title;
  final VoidCallback? onTap;
  final VoidCallback? onCloseTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Material(
          color: Colors.transparent,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.color.surfaceStatusAccent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  SvgPicture.asset(
                    Assets.icons.svg.icBestRoute.keyName,
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: context.textStyle.footNoteBold.copyWith(
                        color: context.color.textAndIconsBaseInversePrimary,
                      ),
                    ),
                  ),
                  AppButton(
                    buttonColorScheme: ButtonColorScheme.accent,
                    size: ButtonSize.small,
                    trailing: SvgPicture.asset(
                      Assets.icons.svg.icClose.keyName,
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        context.color.textAndIconsBaseInversePrimary,
                        BlendMode.srcATop,
                      ),
                    ),
                    onTap: onCloseTap,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
