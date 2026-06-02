import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/entities/selection.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class SaudiPassChipsSelectionWidget<T> extends StatelessWidget {
  final String title;
  final List<Selection<T>> items;
  final Widget Function(BuildContext, Selection<T>) itemBuilder;

  const SaudiPassChipsSelectionWidget({required this.title, required this.items, required this.itemBuilder, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(Spacing.$4x),
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.profileCardColor,
        borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.xl)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.textStyleV3.bodyLargeSemiBold.copyWith(color: colors.foregroundDefault)),
          Spacing.$3x.heightBox,
          Wrap(
            spacing: Spacing.$2x,
            runSpacing: Spacing.$2x,
            children: [for (final item in items) itemBuilder(context, item)],
          ),
        ],
      ),
    );
  }
}
