import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

enum CounterType {
  text,
  dot,
}

enum CounterColorScheme {
  accent,
  neutral,
  error,
}

/// https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=1955-2877&mode=design&t=EGaLN7QzylzWu6Nv-0
class Counter extends StatelessWidget {
  final int? count;
  final double? size;
  final Color? color;
  final Color? counterColor;

  final CounterColorScheme colorScheme;
  final CounterType type;

  final bool isDisabled;

  const Counter({
    this.color,
    this.counterColor,
    this.size,
    this.count,
    this.isDisabled = false,
    this.type = CounterType.text,
    this.colorScheme = CounterColorScheme.accent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    if (count == null || count == 0) return const SizedBox.shrink();

    final color = this.color ??
        (isDisabled
            ? context.colors.neutralContainerDefault
            : switch (colorScheme) {
                CounterColorScheme.accent => context.colors.accentDefault,
                CounterColorScheme.neutral => context.colors.neutralDefault,
                CounterColorScheme.error => context.colors.errorDefault,
              });

    final counterColor = this.counterColor ??
        (isDisabled
            ? context.colors.foregroundDisabled
            : switch (colorScheme) {
                CounterColorScheme.accent => context.colors.accentOnAccent,
                CounterColorScheme.neutral => context.colors.neutralOnNeutral,
                CounterColorScheme.error => context.colors.errorOnError,
              });

    final size = this.size ?? (type == CounterType.dot ? Spacing.$1x + Spacing.$0_5x : Spacing.$5x);
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: size, minHeight: size, maxHeight: size),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(RadiusBorder.full),
        ),
        child: type == CounterType.dot
            ? const SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.only(
                  left: Spacing.$1x,
                  right: Spacing.$1x,
                  top: isArabic ? Spacing.px : Spacing.$0_5x,
                  bottom: Spacing.$0_5x,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    count! > 999 ? '999+' : count.toString(),
                    style: context.textStyles.captionSmallMedium.copyWith(
                      color: counterColor,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
