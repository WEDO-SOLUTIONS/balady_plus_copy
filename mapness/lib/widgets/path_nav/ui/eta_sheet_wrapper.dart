import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/measure_size.dart';

class EtaSheetWrapper extends StatelessWidget {
  final Widget child;
  final OnWidgetSizeChange? onSizeChanged;
  final ValueNotifier<int?>? betterRouteDurationProfit;
  final VoidCallback? onBetterRouteAccept;
  final VoidCallback? onBetterRouteReject;

  const EtaSheetWrapper({
    required this.child,
    this.onSizeChanged,
    this.betterRouteDurationProfit,
    this.onBetterRouteAccept,
    this.onBetterRouteReject,
    super.key,
  });

  @override
  Widget build(BuildContext context) => MeasureSize(
        onChange: (size) {
          // This method called only if we want to rebuild (expand) our widget
          onSizeChanged?.call(size);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (betterRouteDurationProfit != null)
              ValueListenableBuilder(
                valueListenable: betterRouteDurationProfit!,
                builder: (context, duration, child) => duration != null
                    ? Padding(
                        padding: const EdgeInsets.only(
                          left: Spacing.$4x,
                          right: Spacing.$4x,
                          bottom: Spacing.$3x,
                        ),
                        child: _BetterRouteButton(
                          title: context.l10n.betterRouteFound(max((duration / 60).round(), 1)),
                          onTap: onBetterRouteAccept,
                          onCloseTap: onBetterRouteReject,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            Flexible(
              child: Material(
                color: Colors.transparent,
                child: child,
              ),
            ),
          ],
        ),
      );
}

// TODO(Sergei): legacy designed local component, replace with uikit component (will be created in future)
class _BetterRouteButton extends StatelessWidget {
  const _BetterRouteButton({
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
                    buttonColorScheme: ButtonColorScheme.primary,
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
