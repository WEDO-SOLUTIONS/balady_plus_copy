import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_repository.dart';
import 'package:mapness/_features/poi_card/widgets/poi_favorite_dialog_button.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/shared/ui/sheets/loading_sheet.dart';

class PoiFavoriteDialog extends ConsumerStatefulWidget {
  final FavouriteItem favItem;

  const PoiFavoriteDialog({
    required this.favItem,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<PoiFavoriteDialog> createState() => _PoiFavoriteDialogState();
}

class _PoiFavoriteDialogState extends ConsumerState<PoiFavoriteDialog> {
  void _awaitPop(Future<void> future) async {
    await future;

    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final favState = ref.watch(favouriteRepositoryProvider);
    final favNotifier = ref.read(favouriteRepositoryProvider.notifier);

    if (favState.isLoading) {
      return const LoadingSheet();
    }
    if (favState.hasError) {
      return ErrorSheet(
        onRetry: () => ref.invalidate(favouriteRepositoryProvider),
      );
    }

    final fav = favState.requireValue;
    final showHome = fav?.home == null;
    final showWork = fav?.work == null;
    final isFavourite = fav?.items.firstWhereOrNull(
          (element) =>
              element.entity?.id == widget.favItem.entity?.id &&
              widget.favItem.entity?.id != null,
        ) !=
        null;

    ///
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Material(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (showWork)
                    PoiFavoriteDialogButton(
                      iconAsset: 'assets/icons/svg/ic_work.svg',
                      title: context.l10n.work,
                      showBorder: true,
                      onTap: () =>
                          _awaitPop(favNotifier.setWork(widget.favItem)),
                    ),
                  if (showHome)
                    PoiFavoriteDialogButton(
                      iconAsset: 'assets/icons/svg/ic_home.svg',
                      title: context.l10n.home,
                      showBorder: true,
                      onTap: () =>
                          _awaitPop(favNotifier.setHome(widget.favItem)),
                    ),
                  PoiFavoriteDialogButton(
                    iconAsset: 'assets/icons/svg/ic_bookmark.svg',
                    title: context.l10n.favourites,
                    showBorder: false,
                    onTap: () => _onFavTap(isFavourite),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            LabeledElevatedButton(
              textColor: context.color.text_and_icons_base_primary,
              backgroundColor: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
              label: context.l10n.cancel,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _onFavTap(bool isFavourite) async {
    await CommonFunctions.authOrOpen(context, callback: () {
      final favNotifier = ref.read(favouriteRepositoryProvider.notifier);
      _awaitPop(isFavourite
          ? favNotifier.delete(widget.favItem)
          : favNotifier.addItem(widget.favItem));
    });
  }
}
