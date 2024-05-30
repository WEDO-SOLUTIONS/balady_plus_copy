import 'package:balady_uikit/balady_uikit.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class PopupModel {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final TextStyle? titleStyle;

  PopupModel({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.color,
    this.titleStyle,
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
                    titleStyle: item.titleStyle,
                    title: item.title,
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
  final String title;
  final Widget icon;
  final bool showDivider;
  final TextStyle? titleStyle;

  const PopupMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    this.titleStyle,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 48,
            width: 140,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Spacing.verticalPaddingInsideCell,
                horizontal: Spacing.horizontalPaddingInsideWrapper,
              ),
              child: ContentRow(
                options: ContentRowOptions(
                  padding: EdgeInsets.zero,
                  title: title,
                  titleStyle: titleStyle,
                  leadingIcon: icon,
                ),
              ),
            ),
          ),
          if (showDivider) const Divider(),
        ],
      );
}
