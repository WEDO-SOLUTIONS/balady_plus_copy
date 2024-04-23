import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PopupModel {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  PopupModel({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.color,
  });
}

class PopupCard extends StatelessWidget {
  final List<PopupModel> items;
  final Widget child;

  const PopupCard({
    Key? key,
    required this.items,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => PopupMenuButton<bool>(
        constraints: const BoxConstraints(
          minWidth: 140,
          maxWidth: 140,
        ),
        iconSize: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.zero,
        child: child,
        itemBuilder: (context) => items
            .mapIndexed((index, item) => PopupMenuItem<bool>(
                  padding: EdgeInsets.zero,
                  onTap: item.onTap,
                  child: PopupMenuWidget(
                    title: Text(item.title,
                        style: context.textStyle.footNote.copyWith(color: context.color.textAndIconsBasePrimary)),
                    icon: item.icon.icon(
                      color: item.color,
                    ),
                    showDivider: index != items.length - 1,
                  ),
                ))
            .toList(),
      );
}

class PopupMenuWidget extends StatelessWidget {
  final Widget title;
  final Widget icon;
  final bool showDivider;

  const PopupMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Spacing.verticalPaddingInsideCell,
              horizontal: Spacing.horizontalPaddingInsideWrapper,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                Spacing.horizontalGapBetweenCellContent.widthBox,
                title,
              ],
            ),
          ),
          if (showDivider) const Divider(),
        ],
      );
}
