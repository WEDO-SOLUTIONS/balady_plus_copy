import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/shared/ui/popup_card/popup_card.dart';
import 'package:sheetify/sheetify.dart';

class FavoriteDialogMenu extends HookWidget {
  final String? route;
  final String? share;
  final String? change;
  final String? delete;
  final String title;
  final String close;
  final VoidCallback? onDelete;
  final VoidCallback? onTapRoute;
  final VoidCallback? onTapShare;
  final VoidCallback? onTapChange;

  const FavoriteDialogMenu({
    required this.title,

    required this.close,
    this.change,
    this.delete,
    this.route,
    this.share,
    this.onDelete,
    this.onTapRoute,
    this.onTapShare,
    this.onTapChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      if (route != null)
        PopupModel(
          title: route!,
          icon: GeneralIcons.routeStroke,
          onTap: () => onTapRoute?.call(),
          color: context.colors.foregroundSoft,
        ),
      if (share != null)
        PopupModel(
          title: share!,
          icon: SystemIcons.share,
          onTap: () => onTapShare?.call(),
          color: context.colors.foregroundSoft,
        ),
      if (change != null)
        PopupModel(
          title: change!,
          icon: SystemIcons.bookmarkAdd,
          onTap: () => onTapChange?.call(),
          color: context.colors.foregroundSoft,
        ),
      if (delete != null)
        PopupModel(
          titleStyle: context.textStyle.text.copyWith(color: context.colors.errorDefault),
          color: context.colors.errorDefault,
          title: delete!,
          icon: GeneralIcons.trash,
          onTap: () => onDelete?.call(),
        ),
    ];

    return ToggleSheet(
      useSafeArea: false,
      dragger: DraggerContainer(draggerColor: context.colors.backgroundSurface5),
      backgroundColor: context.colors.backgroundSurface4,
      header: Padding(
        padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, bottom: Spacing.$3x),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: context.textStyles.h2SemiBold.copyWith(color: context.colors.foregroundDefault),
              ),
            ),
            Spacing.$3x.widthBox,
            AppButton.close(onTap: () => Navigator.pop(context), padding: EdgeInsets.zero),
          ],
        ),
      ),

      content: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: Spacing.$1x),
          margin: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          decoration: BoxDecoration(
            color: context.colors.backgroundSurface1,
            borderRadius: BorderRadius.circular(RadiusBorder.l),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...items.mapIndexed(
                (index, item) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        item.onTap();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: Spacing.$3x, horizontal: Spacing.$4x),
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            item.icon.icon(color: item.color),
                            Spacing.$3x.widthBox,
                            Expanded(
                              child: Text(
                                item.title,
                                style:
                                    item.titleStyle ??
                                    context.textStyles.bodyLargeRegular.copyWith(
                                      color: context.colors.foregroundDefault,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (index != items.length - 1) Divider(height: 1, indent: 52, color: context.colors.borderSoft),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.$12x),
      ],
      scrollController: ToggleSheetController(),
    );
  }
}
