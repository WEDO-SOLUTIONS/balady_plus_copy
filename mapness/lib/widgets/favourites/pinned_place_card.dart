import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/popup_card/popup_card.dart';

class PinnedPlaceCard extends StatelessWidget {
  const PinnedPlaceCard({
    required this.address,
    required this.iconData,
    required this.title,
    required super.key,
    required this.onTap,
    required this.isEditing,
    required this.onDelete,
    required this.isAdded,
    required this.onTapRoute,
    required this.onTapShare,
    required this.onTapChange,
  });

  final IconData iconData;
  final String title;
  final String address;
  final bool isAdded;
  final bool isEditing;
  final VoidCallback? onTap;
  final VoidCallback onDelete;
  final VoidCallback onTapRoute;
  final VoidCallback onTapShare;
  final VoidCallback onTapChange;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          vertical: Spacing.$3x,
          horizontal: Spacing.$2x,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusBorder.l),
          color: context.colors.backgroundSurface4,
        ),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Column(
              children: [
                const SizedBox(height: Spacing.$2x),
                InkWell(
                  onTap: onTap,
                  child: Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: isAdded ? context.colors.backgroundSurface1 : context.color.surfaceStatusContrastAccent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                        height: 32,
                        width: 32,
                        child: isAdded
                            ? iconData.icon(color: context.colors.accentDefault)
                            : SystemIcons.zoomPlus.icon(
                                color: context.colors.accentOnContainer,
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.$1x),
                Text(
                  title,
                  textAlign: TextAlign.right,
                  style: context.textStyle.heading2.copyWith(color: context.colors.foregroundDefault),
                ),
                const SizedBox(height: Spacing.$0_5x),
                Text(
                  address,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyle.caption.copyWith(color: context.colors.foregroundSoft),
                ),
              ],
            ),
            if (isAdded)
              Positioned(
                top: 0,
                right: context.isLTR ? 0 : null,
                left: context.isLTR ? null : 0,
                child: PopupCard(
                  items: [
                    PopupModel(
                      title: context.l10n.route,
                      icon: GeneralIcons.routeStroke,
                      onTap: onTapRoute,
                      color: context.colors.foregroundDefault,
                    ),
                    PopupModel(
                      title: context.l10n.share,
                      icon: SystemIcons.share,
                      onTap: onTapShare,
                      color: context.colors.foregroundDefault,
                    ),
                    PopupModel(
                      title: context.l10n.change,
                      icon: SystemIcons.bookmarkAdd,
                      onTap: onTapChange,
                      color: context.colors.foregroundDefault,
                    ),
                    PopupModel(
                      titleStyle: context.textStyle.text.copyWith(
                        color: context.colors.errorDefault,
                      ),
                      color: context.colors.errorDefault,
                      title: context.l10n.delete,
                      icon: GeneralIcons.trash,
                      onTap: onDelete,
                    ),
                  ],
                  child: SystemIcons.ellipsis.icon(
                    color: context.colors.accentDefault,
                  ),
                ),
              ),
          ],
        ),
      );
}
