import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/shared/ui/sheets/loading_sheet.dart';
import 'package:sheetify/sheetify.dart';

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
  late final scrollController = ToggleSheetController(
    onClose: (_) => context.router.popForced(),
  );

  void _withPop(Future<void> future) {
    unawaited(future);
    scrollController.close();
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

    const itemPadding = EdgeInsets.symmetric(
      horizontal: Spacing.$4x,
      vertical: Spacing.$3x,
    );
    final itemTitleStyle = context.textStyles.bodyLargeRegular.copyWith(
      color: context.colors.foregroundDefault,
    );

    return ToggleSheet(
      scrollController: scrollController,
      backgroundColor: context.colors.backgroundSurface4,
      safeAreaColor: context.colors.backgroundSurface4,
      dragger: SheetDragger(backgroundColor: context.colors.backgroundSurface4),
      content: [
        ContentRow(
          options: ContentRowOptions(
            padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, bottom: Spacing.$3x),
            title: context.l10n.addToFavorites,
            titleStyle: context.textStyles.h4SemiBold.copyWith(
              color: context.colors.foregroundDefault,
            ),
            customActionWidget: AppButton.close(
              onTap: scrollController.close,
              padding: EdgeInsets.zero,
              textColor: context.colors.neutralOnContainer,
              color: context.colors.neutralContainerDefault,
              innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, bottom: Spacing.$5x),
          child: ContentWrapper(
            color: Colors.white,
            children: [
              if (showWork)
                ContentRow(
                  onTap: () => _withPop(favNotifier.setWork(widget.favItem)),
                  options: ContentRowOptions(
                    padding: itemPadding,
                    dividerEnabled: true,
                    title: context.l10n.setAsWork,
                    titleStyle: itemTitleStyle,
                    leadingIcon: Icon(GeneralIcons.briefcase, color: context.colors.foregroundDefault),
                  ),
                ),
              if (showHome)
                ContentRow(
                  onTap: () => _withPop(favNotifier.setHome(widget.favItem)),
                  options: ContentRowOptions(
                    padding: itemPadding,
                    dividerEnabled: true,
                    title: context.l10n.setAsHome,
                    titleStyle: itemTitleStyle,
                    leadingIcon: Icon(GeneralIcons.home, color: context.colors.foregroundDefault),
                  ),
                ),
              ContentRow(
                onTap: () => _onFavTap(isFavourite),
                options: ContentRowOptions(
                  padding: itemPadding,
                  title: context.l10n.addToFavorite,
                  titleStyle: itemTitleStyle,
                  leadingIcon: Icon(SystemIcons.bookmarkAdd, color: context.colors.foregroundDefault),
                ),
              ),
            ],
          ),
        ),
      ],
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
