import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';

import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/widgets/screen/delete_icon.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class FavouriteItemWidget extends StatefulWidget {
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final FavouriteItem item;
  final bool isEditing;

  FavouriteItemWidget({
    required this.onDelete,
    required this.onTap,
    required this.item,
    required this.isEditing,
  }) : super(key: Key(item.id));

  @override
  State<FavouriteItemWidget> createState() => _FavouriteItemWidgetState();
}

class _FavouriteItemWidgetState extends State<FavouriteItemWidget> {
  var isDismissed = false;

  void onDelete() {
    setState(() {
      isDismissed = true;
      widget.onDelete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (_) => onDelete(),
      background: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xfff4383c),
        ),
        child: isDismissed
            ? null
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.filled(
                  2,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    child: Text(
                      context.l10n.delete,
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .textS
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
      ),
      key: widget.key!,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              if (widget.isEditing) ...[
                DeleteIcon(
                  onPressed: onDelete,
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.item.title,
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .textM
                          .copyWith(color: const Color(0xff1e2936)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.item.subtitle,
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .textS
                          .copyWith(color: const Color(0xff346263)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
