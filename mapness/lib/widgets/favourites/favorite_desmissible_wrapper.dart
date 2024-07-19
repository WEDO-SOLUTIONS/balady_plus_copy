import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class FavoriteDismissibleWrapper extends StatelessWidget {
  final String id;
  final bool isFirst;
  final bool isLast;
  final Widget child;
  final bool isDismissibleEnabled;
  final VoidCallback onDelete;

  const FavoriteDismissibleWrapper({
    required this.isFirst,
    required this.isLast,
    required this.child,
    required this.isDismissibleEnabled,
    required this.id,
    required this.onDelete,
    super.key,
  });

  static const radius = Radius.circular(12);

  @override
  Widget build(BuildContext context) => isDismissibleEnabled
      ? Dismissible(
          direction: DismissDirection.endToStart,
          movementDuration: const Duration(milliseconds: 300),
          key: Key(id),
          onDismissed: (_) => onDelete(),
          background: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: context.color.textAndIconsStatusNegative,
                borderRadius: BorderRadius.only(
                  topRight: isFirst && context.isLTR ? radius : Radius.zero,
                  topLeft: isFirst && !context.isLTR ? radius : Radius.zero,
                  bottomRight: isLast && context.isLTR ? radius : Radius.zero,
                  bottomLeft: isLast && !context.isLTR ? radius : Radius.zero,
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacing.horizontalPaddingInsideCell.widthBox,
                GeneralIcons.trash.icon(
                  color: context.color.surfaceBasePrimary,
                ),
                Spacing.horizontalPaddingInsideCell.widthBox,
              ],
            ),
          ),
          child: child,
        )
      : child;
}
