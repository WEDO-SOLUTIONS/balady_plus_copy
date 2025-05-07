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
          vertical: Spacing.verticalPaddingInsideCell,
          horizontal: Spacing.horizontalPaddingInsideCell,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(CornerRadius.smallContainer),
          color: context.color.surfaceBaseSecondary,
        ),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: NumericBase.$2x,
                ),
                InkWell(
                  onTap: onTap,
                  child: Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: isAdded ? context.color.surfaceBasePrimary : context.color.surfaceStatusContrastAccent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                        height: 32,
                        width: 32,
                        child: isAdded
                            ? iconData.icon(color: context.color.textAndIconsStatusAccent)
                            : SystemIcons.zoomPlus.icon(
                                color: context.color.strokeAccent,
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: NumericBase.$1x),
                Text(
                  title,
                  textAlign: TextAlign.right,
                  style: context.textStyle.heading2.copyWith(color: context.color.textAndIconsBasePrimary),
                ),
                const SizedBox(
                  height: NumericBase.$0_5x,
                ),
                Text(
                  address,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyle.caption.copyWith(color: context.color.textAndIconsBaseSecondary),
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
                      color: context.color.textAndIconsBasePrimary,
                    ),
                    PopupModel(
                      title: context.l10n.share,
                      icon: SystemIcons.share,
                      onTap: onTapShare,
                      color: context.color.textAndIconsBasePrimary,
                    ),
                    PopupModel(
                      title: context.l10n.change,
                      icon: SystemIcons.bookmarkAdd,
                      onTap: onTapChange,
                      color: context.color.textAndIconsBasePrimary,
                    ),
                    PopupModel(
                      titleStyle: context.textStyle.text.copyWith(
                        color: context.color.textAndIconsStatusNegative,
                      ),
                      color: context.color.textAndIconsStatusNegative,
                      title: context.l10n.delete,
                      icon: GeneralIcons.trash,
                      onTap: onDelete,
                    ),
                  ],
                  child: SystemIcons.ellipsis.icon(
                    color: context.color.textAndIconsStatusAccent,
                  ),
                ),
              ),
          ],
        ),
      );
}
