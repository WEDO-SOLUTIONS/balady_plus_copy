import 'dart:io';
import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/measure_size.dart';

class EtaSheetWrapper extends StatelessWidget {
  final Widget child;
  final bool isExpanded;
  final OnWidgetSizeChange? onSizeChanged;
  final ValueNotifier<int?>? betterRouteDurationProfit;
  final VoidCallback? onBetterRouteAccept;
  final VoidCallback? onBetterRouteReject;
  static const curve = BaseRoadPanel.animationCurve;
  static const duration = BaseRoadPanel.animationDuration;

  const EtaSheetWrapper({
    required this.child,
    required this.isExpanded,
    this.onSizeChanged,
    this.betterRouteDurationProfit,
    this.onBetterRouteAccept,
    this.onBetterRouteReject,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    double bottomPadding = media.padding.bottom;
    if (Platform.isAndroid) {
      bottomPadding += Spacing.verticalBaseToBottomSafezone;
    }
    return MeasureSize(
      onChange: (size) {
        // This method called only if we want to rebuild (expand) our widget
        onSizeChanged?.call(size);
      },
      child: Column(
        children: [
          if (betterRouteDurationProfit != null)
            ValueListenableBuilder(
              valueListenable: betterRouteDurationProfit!,
              builder: (context, duration, child) => duration != null
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: Spacing.horizontalPaddingInsideWrapper,
                        right: Spacing.horizontalPaddingInsideWrapper,
                        bottom: Spacing.verticalPaddingInsideCell,
                      ),
                      child: _BetterRouteButton(
                        title: context.l10n.betterRouteFound(max((duration / 60).floor(), 1)),
                        onTap: onBetterRouteAccept,
                        onCloseTap: onBetterRouteReject,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          Material(
            color: isExpanded ? Colors.white : Colors.transparent,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: AnimatedPadding(
              padding: EdgeInsets.only(
                left: isExpanded ? 0 : Spacing.horizontalPaddingInsideWrapper,
                right: isExpanded ? 0 : Spacing.horizontalPaddingInsideWrapper,
                bottom: bottomPadding,
              ),
              duration: duration,
              curve: curve,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
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
                    'assets/icons/svg/ic_best_route.svg',
                    width: 40,
                    height: 40,
                    package: PackageConfig.packageName,
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
                      'assets/icons/svg/ic_close.svg',
                      width: 16,
                      height: 16,
                      package: PackageConfig.packageName,
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
