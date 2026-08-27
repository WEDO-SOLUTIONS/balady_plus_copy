import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/trending/trending.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class SearchTrending extends ConsumerWidget {
  final List<TrendingItem> items;
  final ValueChanged<TrendingItem> onItemTap;

  const SearchTrending({required this.items, required this.onItemTap, super.key});

  static const _startColor = Color(0xffE04237);
  static const _endColor = Color(0xffE08B37);

  // ai-generated method
  List<Color> generateColorSteps(Color start, Color end, int steps) {
    if (steps <= 0) {
      return [];
    }

    final colorSteps = <Color>[];
    for (int i = 0; i < steps; i++) {
      // Calculate the normalized position (between 0.0 and 1.0)
      final double t = i / (steps == 1 ? 1 : steps - 1);

      // Interpolate the color
      final Color? lerpedColor = Color.lerp(start, end, t);
      if (lerpedColor != null) {
        colorSteps.add(lerpedColor);
      }
    }
    return colorSteps;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numberColorSteps = generateColorSteps(_startColor, _endColor, items.length);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: SizedBox(
        width: double.infinity,
        child: ContentWrapper.single(
          color: context.colors.backgroundSurface1,
          child: Padding(
            padding: const EdgeInsets.all(Spacing.$4x),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.trending,
                  style: context.textStyles.bodyLargeMedium.copyWith(color: context.colors.foregroundDefault),
                ),
                const SizedBox(height: Spacing.$4x),
                Column(
                  spacing: Spacing.$2x,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: items
                      .mapIndexed(
                        (index, item) => GestureDetector(
                          onTap: () => onItemTap(item),
                          child: _Item(
                            number: index + 1,
                            item: item,
                            numberColor: numberColorSteps[index],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final int number;
  final TrendingItem item;
  final Color numberColor;

  const _Item({required this.number, required this.item, required this.numberColor});

  @override
  Widget build(BuildContext context) => Container(
    height: 30,
    padding: const EdgeInsets.symmetric(horizontal: Spacing.$2_5x, vertical: Spacing.$1x),
    decoration: BoxDecoration(
      color: context.colors.neutralContainerDefault,
      borderRadius: BorderRadius.circular(RadiusBorder.s),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(number.toString(), style: context.textStyles.bodyLargeSemiBold.copyWith(color: numberColor)),
        const SizedBox(width: Spacing.$2x),
        Text(
          item.object.title,
          style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundDefault),
        ),
      ],
    ),
  );
}
