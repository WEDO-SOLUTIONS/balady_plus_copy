// ignore_for_file: avoid_positional_boolean_parameters
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/popup_card/popup_card.dart';

class FavouriteItemWidget extends StatefulWidget {
  FavouriteItemWidget({
    required this.onTap,
    required this.item,
    required this.isEditing,
    this.isDeletable = true,
    this.onSelect,
    this.isSelected,
    this.onRouteTap,
    this.onDelete,
    this.onShareTap,
  }) : super(key: Key(item.id));
  final VoidCallback onTap;
  final FavouriteItem item;
  final bool isEditing;
  final bool isDeletable;
  final bool? isSelected;
  final Function(bool value)? onSelect;
  final VoidCallback? onDelete;
  final VoidCallback? onRouteTap;
  final VoidCallback? onShareTap;

  @override
  State<FavouriteItemWidget> createState() => _FavouriteItemWidgetState();
}

class _FavouriteItemWidgetState extends State<FavouriteItemWidget> {
  bool isDismissed = false;

  late PointerDownEvent pointerDetails;

  @override
  Widget build(BuildContext context) => Row(
        key: Key(widget.item.id),
        children: [
          if (widget.isEditing) Spacing.horizontalPaddingInsideCell.widthBox,
          if (widget.isEditing)
            BaladyCheckBox(
              key: UniqueKey(),
              state: widget.isSelected == true
                  ? BaladyCheckBoxState.checked
                  : BaladyCheckBoxState.unchecked,
              disable: false,
              onChanged: (value) {
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
              },
            ),
          Expanded(
            child: Listener(
              onPointerDown: (details) {
                setState(() {
                  pointerDetails = details;
                });
              },
              child: InkWell(
                onTap: () {
                  if (widget.isEditing) {
                    setState(
                        () => widget.onSelect?.call(widget.isSelected == true));
                  } else {
                    widget.onTap();
                  }
                },
                onLongPress: () {
                  if (!widget.isEditing) {
                    final color = context.color;
                    showMenu(
                      constraints: const BoxConstraints(
                        minWidth: 140,
                        maxWidth: 140,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      context: context,
                      items: <PopupMenuEntry<bool>>[
                        PopupMenuItem<bool>(
                          padding: EdgeInsets.zero,
                          onTap: () => widget.onRouteTap?.call(),
                          child: PopupMenuWidget(
                            title: context.l10n.route,
                            icon: GeneralIcons.route.icon(
                              color: color.textAndIconsBasePrimary,
                            ),
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
                },
                child: ContentRow(
                  options: ContentRowOptions(
                    leadingIcon: SystemIcons.bookmarkFill.icon(
                      color: context.color.textAndIconsStatusAccent,
                    ),
                    title: widget.item.title,
                    subtitle: widget.item.subtitle,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}
