import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/poi_card/widgets/poi_favorite_dialog_button.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/shared/ui/sheets/loading_sheet.dart';

@RoutePage()
class PoiFavoriteDialogPage extends ConsumerStatefulWidget {
  final FavouriteItem favItem;

  const PoiFavoriteDialogPage({
    required this.favItem,
    super.key,
  });

  @override
  ConsumerState<PoiFavoriteDialogPage> createState() => _PoiFavoriteDialogPageState();
}

class _PoiFavoriteDialogPageState extends ConsumerState<PoiFavoriteDialogPage> {
  void _withPop(Future<void> future) {
    unawaited(future);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final favState = ref.watch(favouriteCacheProvider);
    final favNotifier = ref.read(favouriteCacheProvider.notifier);

    if (favState.isLoading) {
      return const LoadingSheet();
    }
    if (favState.hasError) {
      return ErrorSheetWidget(
        onRetry: () => ref.invalidate(favouriteCacheProvider),
      );
    }

    final fav = favState.requireValue;
    final showHome = fav.home == null;
    final showWork = fav.work == null;
    final isFavourite = fav.items.firstWhereOrNull(
          (element) => element.entity?.id == widget.favItem.entity?.id && widget.favItem.entity?.id != null,
        ) !=
        null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
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
                      onTap: () => _withPop(favNotifier.setWork(widget.favItem)),
                    ),
                  if (showHome)
                    PoiFavoriteDialogButton(
                      iconAsset: 'assets/icons/svg/ic_home.svg',
                      title: context.l10n.home,
                      showBorder: true,
                      onTap: () => _withPop(favNotifier.setHome(widget.favItem)),
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
              textColor: context.color.textAndIconsBasePrimary,
              backgroundColor: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
              label: context.l10n.cancel,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _onFavTap(bool isFavourite) async {
    await ref.read(authMethodsProvider.notifier).authOrOpen(
      context,
      callback: () {
        final favNotifier = ref.read(favouriteCacheProvider.notifier);
        _withPop(
          isFavourite ? favNotifier.deleteItem(widget.favItem) : favNotifier.addItem(widget.favItem),
        );
      },
    );
  }
}
