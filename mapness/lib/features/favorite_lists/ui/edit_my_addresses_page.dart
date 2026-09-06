import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/favorite_lists/providers/home_work_favorites.dart';
import 'package:mapness/features/favorite_lists/ui/models/sheet_action_button.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class EditMyAddressesPage extends HookConsumerWidget {
  final FavouriteItem? item;
  final bool isHome;

  const EditMyAddressesPage({required this.item, required this.isHome, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useToggleSheetController(onClose: (_) => context.router.pop());

    return ToggleSheet(
      scrollController: scrollController,
      backgroundColor: context.colors.backgroundSurface4,
      safeAreaColor: context.colors.backgroundSurface4,
      dragger: SheetDragger(draggerColor: context.colors.backgroundSurface5),
      outside: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.router.pop(),
        child: const SizedBox.expand(),
      ),
      contentPadding: const EdgeInsets.all(Spacing.$4x),
      content: [
        ContentWrapper(
          color: context.colors.backgroundSurface1,
          children: [
            ContentRow(
              leading: Icon(SystemIcons.edit, color: context.colors.foregroundMuted),
              text: ContentRowTextOptions(
                title: context.l10n.edit,
                titleOptions: ContentRowTextOption(baseColor: context.colors.foregroundDefault),
              ),
              isDividerEnabled: true,
              onTap: () async {
                await context.router.push<FavouriteItem>(
                  FavouritesSearchRoute(
                    markerType: isHome ? FavouriteItemMarkerType.home : FavouriteItemMarkerType.work,
                  ),
                );
                if (context.mounted) {
                  context.router.pop();
                }
              },
            ),
            ContentRow(
              leading: Icon(GeneralIcons.trash, color: context.colors.errorDefault),
              text: ContentRowTextOptions(
                title: context.l10n.delete,
                titleOptions: ContentRowTextOption(baseColor: context.colors.errorDefault),
              ),
              onTap: () async {
                final favItem = item;
                if (favItem == null) {
                  return;
                }
                final shouldClose = await context.router.push(
                  ConfirmationSheetRoute(
                    title: context.l10n.favoriteListAddressDeletionTitle,
                    message: isHome
                        ? context.l10n.favoriteListConfirmDeleteHomeAddressMessage
                        : context.l10n.favoriteListConfirmDeleteWorkAddressMessage,
                    buttons: [
                      SheetActionButton(label: context.l10n.keep, onTap: () async => context.router.pop()),
                      SheetActionButton(
                        label: context.l10n.delete,
                        buttonColorScheme: ButtonColorScheme.error,
                        buttonType: ButtonType.primary,
                        showsLoadingAndHandlesErrors: true,
                        onTap: () => isHome
                            ? ref.read(homeWorkFavoritesActionsProvider.notifier).deleteHome()
                            : ref.read(homeWorkFavoritesActionsProvider.notifier).deleteWork(),
                      ),
                    ],
                  ),
                );
                if (shouldClose == true && context.mounted) {
                  context.router.pop();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
