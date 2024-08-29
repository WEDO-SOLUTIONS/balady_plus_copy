import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EtaShareControlSheet extends StatelessWidget {
  const EtaShareControlSheet({super.key});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: context.color.surfaceBaseSecondary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(RadiusBorder.xl),
            topRight: Radius.circular(RadiusBorder.xl),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ContentRow(
                options: ContentRowOptions(
                  padding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 10,
                  ),
                  title: 'Route is sharing',
                  titleStyle: context.textStyle.heading2.copyWith(
                    color: context.color.textAndIconsBasePrimary,
                  ),
                  customActionWidget: AppButton.close(
                    onTap: () => context.pop(),
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                  ),
                ),
              ),
              const ContentWrapper(color: Colors.white, children: [
                ContentRow(
                  options: ContentRowOptions(
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.$4x,
                      vertical: Spacing.$3x,
                    ),
                    dividerEnabled: true,
                    title: 'Share more',
                    leadingIcon: Icon(SystemIcons.share),
                  ),
                ),
                ContentRow(
                  options: ContentRowOptions(
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.$4x,
                      vertical: Spacing.$3x,
                    ),
                    title: 'Stop sharing',
                    leadingIcon: Icon(GeneralIcons.clearCircle),
                  ),
                )
              ]),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      );
}
