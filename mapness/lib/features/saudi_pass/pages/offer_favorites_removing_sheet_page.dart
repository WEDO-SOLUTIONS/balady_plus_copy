import 'package:auto_route/annotations.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/saudi_pass/widgets/offer_favorites_removing_sheet.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

@RoutePage()
class OfferFavoritesRemovingSheetPage extends StatelessWidget {
  final VoidCallback onRemove;

  const OfferFavoritesRemovingSheetPage({required this.onRemove, super.key});

  @override
  Widget build(BuildContext context) => OfferFavoritesRemovingSheet(
        title: context.l10n.removeFromFavorites,
        description: context.l10n.removeFromFavoritesDescription,
        cancel: context.l10n.cancel,
        remove: context.l10n.remove,
        onRemove: onRemove,
      );
}
