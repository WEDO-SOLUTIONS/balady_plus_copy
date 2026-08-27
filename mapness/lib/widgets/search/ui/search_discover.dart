import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class SearchDiscover extends ConsumerWidget {
  final List<String> discoverItems;
  final ValueChanged<String> onItemTap;

  const SearchDiscover({required this.discoverItems, required this.onItemTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
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
                context.l10n.discover,
                style: context.textStyles.bodyLargeMedium.copyWith(color: context.colors.foregroundDefault),
              ),
              const SizedBox(height: Spacing.$4x),
              Wrap(
                runSpacing: Spacing.$3x,
                spacing: Spacing.$2x,
                children: discoverItems.map(
                  (item) {
                    var isTapped = false;
                    return StatefulBuilder(
                      builder: (context, setState) => GestureDetector(
                        onTap: () => onItemTap(item),
                        onTapUp: (_) => setState(() => isTapped = false),
                        onTapDown: (_) => setState(() => isTapped = true),
                        child: _Chip(text: item, selected: isTapped),
                      ),
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _Chip extends StatelessWidget {
  final String text;
  final bool selected;

  const _Chip({required this.text, required this.selected});

  @override
  Widget build(BuildContext context) {
    final textColor = selected
        ? context.colors.accentSecondaryOnAccentSecondary
        : context.colors.accentSecondaryOnContainer;
    final bgColor = selected ? context.colors.accentSecondaryDefault : context.colors.accentSecondaryContainerDefault;
    final textStyle = context.textStyles.bodySmallRegular.copyWith(color: textColor);

    return Container(
      height: 28,
      padding: const EdgeInsets.only(left: Spacing.$2x, right: Spacing.$1_5x),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(RadiusBorder.s),
      ),
      child: Align(
        widthFactor: 1.0,
        child: Text(text, style: textStyle),
      ),
    );
  }
}
