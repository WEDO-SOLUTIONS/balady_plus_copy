import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/saudi_pass/widgets/favorite_dialog_menu.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

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

  Future<void> showBottomSheet(BuildContext context) async {
    await showDialog(
      context: context,
      useSafeArea: false,
      builder: (_) => FavoriteDialogMenu(
        onDelete: onDelete,
        onTapRoute: onTapRoute,
        onTapShare: onTapShare,
        onTapChange: onTapChange,
        change: context.l10n.change,
        delete: context.l10n.delete,
        route: context.l10n.route,
        share: context.l10n.share,
        title: context.l10n.action,
        close: context.l10n.saudiPassTermAndConditionsClose,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: Spacing.$3x, horizontal: Spacing.$4x),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(RadiusBorder.l),
      color: context.colors.backgroundSurface1,
    ),
    child: Stack(
      fit: StackFit.passthrough,
      children: [
        Column(
          children: [
            const SizedBox(height: Spacing.$2x),
            InkWell(
              onTap: isAdded ? () => showBottomSheet(context) : onTap,
              child: Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: isAdded
                      ? context.colors.accentSecondaryContainerDefault
                      : context.colors.accentSecondaryDefault,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    height: 32,
                    width: 32,
                    child: isAdded
                        ? iconData.icon(color: context.colors.accentSecondaryOnContainer)
                        : SystemIcons.zoomPlus.icon(color: context.colors.staticWhite),
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
      ],
    ),
  );
}
