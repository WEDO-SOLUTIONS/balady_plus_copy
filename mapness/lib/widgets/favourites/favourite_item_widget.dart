// ignore_for_file: avoid_positional_boolean_parameters
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/dismissible/app_dismissible.dart';
import 'package:mapness/shared/ui/popup_card/popup_card.dart';

class FavouriteItemWidget extends StatefulWidget {
  final VoidCallback onTap;
  final FavouriteItem item;
  final bool isEditing;
  final bool isDeletable;
  final bool? isSelected;
  final bool isLongPressEnabled;
  final Function(bool value)? onSelect;
  final VoidCallback? onDelete;
  final VoidCallback? onRouteTap;
  final VoidCallback? onShareTap;
  final bool isFirst;
  final bool isLast;
  final Widget? icon;

  const FavouriteItemWidget({
    required this.onTap,
    required this.item,
    required this.isEditing,
    required this.isFirst,
    required this.isLast,
    required super.key,
    this.isDeletable = true,
    this.isLongPressEnabled = true,
    this.onSelect,
    this.isSelected,
    this.onRouteTap,
    this.onDelete,
    this.onShareTap,
    this.icon,
  });

  @override
  State<FavouriteItemWidget> createState() => _FavouriteItemWidgetState();
}

class _FavouriteItemWidgetState extends State<FavouriteItemWidget> {
  bool isDismissed = false;

  late PointerDownEvent pointerDetails;

  @override
  Widget build(BuildContext context) {
    final stateOfCheckBox = widget.isSelected == true ? BaladyCheckBoxState.checked : BaladyCheckBoxState.unchecked;
    final isDismissibleEnabled = widget.isDeletable && !isDismissed && !widget.isEditing;
    return AppDismissible(
      elementKey: ValueKey(widget.item.id),
      addTopBorderRadius: widget.isFirst,
      addBottomBorderRadius: widget.isLast,
      isDismissibleEnabled: isDismissibleEnabled,
      onDismiss: () => widget.onDelete?.call(),
      child: Row(
        key: Key(widget.item.id),
        children: [
          if (widget.isEditing) ...[
            Spacing.$2x.widthBox,
            BaladyCheckBox(
              key: UniqueKey(),
              state: stateOfCheckBox,
              disable: false,
              onChanged: _onChanged,
            ),
          ],
          Expanded(
            child: Listener(
              onPointerDown: _onPointerDown,
              child: InkWell(
                borderRadius: BorderRadius.circular(RadiusBorder.l),
                onTap: _onTap,
                onLongPress: _onLongPress,
                child: ContentRow(
                  options: ContentRowOptions(
                    leadingIcon: widget.icon ??
                        SystemIcons.bookmarkFill.icon(
                          color: context.color.textAndIconsStatusAccent,
                        ),
                    // TODO: I think this title change from the backend side they append the title and category and add , between them
                    title: widget.item.title.split(', ').firstOrNull ?? '',
                    subtitle: widget.item.subtitle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onChanged(BaladyCheckBoxState value) {
    switch (value) {
      case BaladyCheckBoxState.checked:
        widget.onSelect?.call(true);
        break;
      case BaladyCheckBoxState.unchecked:
        widget.onSelect?.call(false);
        break;
      case BaladyCheckBoxState.indeterminate:
        break;
    }
  }

  void _onPointerDown(PointerDownEvent details) {
    setState(() {
      pointerDetails = details;
    });
  }

  void _onTap() {
    if (widget.isEditing) {
      setState(() => widget.onSelect?.call(widget.isSelected == true));
    } else {
      widget.onTap();
    }
  }

  void _onLongPress() {
    if (!widget.isEditing && widget.isLongPressEnabled) {
      final color = context.color;
      showMenu(
        constraints: const BoxConstraints(
          minWidth: 140,
          maxWidth: 140,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusBorder.l),
        ),
        context: context,
        items: <PopupMenuEntry<bool>>[
          PopupMenuItem<bool>(
            padding: EdgeInsets.zero,
            onTap: () => widget.onRouteTap?.call(),
            child: PopupMenuWidget(
              title: context.l10n.route,
              icon: GeneralIcons.routeStroke.icon(
                color: color.textAndIconsBasePrimary,
              ),
              showDivider: false,
            ),
          ),
          PopupMenuItem<bool>(
            padding: EdgeInsets.zero,
            onTap: () => widget.onShareTap?.call(),
            child: PopupMenuWidget(
              title: context.l10n.share,
              icon: SystemIcons.share.icon(
                color: color.textAndIconsBasePrimary,
              ),
              showDivider: false,
            ),
          ),
          PopupMenuItem<bool>(
            padding: EdgeInsets.zero,
            onTap: () => widget.onDelete?.call(),
            child: PopupMenuWidget(
              titleStyle: context.textStyle.text.copyWith(
                color: color.textAndIconsStatusNegative,
              ),
              title: context.l10n.delete,
              icon: GeneralIcons.trash.icon(
                color: color.textAndIconsStatusNegative,
              ),
              showDivider: false,
            ),
          ),
        ],
        position: RelativeRect.fromLTRB(
          pointerDetails.position.dx,
          pointerDetails.position.dy,
          pointerDetails.position.dx,
          pointerDetails.position.dy,
        ),
      );
    }
  }
}
