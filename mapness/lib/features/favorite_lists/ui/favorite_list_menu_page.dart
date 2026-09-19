import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_remote_datasource.dart';
import 'package:mapness/features/favorite_lists/providers/aggregated_favorite_markers.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_list_detail.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_lists.dart';
import 'package:mapness/features/favorite_lists/ui/models/favorite_list_form_params.dart';
import 'package:mapness/features/favorite_lists/ui/models/sheet_action_button.dart';
import 'package:mapness/features/favorite_lists/ui/show_favorite_lists_error_sheet.dart';
import 'package:mapness/features/favourites/helpers/favourite_entity_id.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class FavoriteListMenuPage extends HookConsumerWidget {
  final String listId;

  const FavoriteListMenuPage({required this.listId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useToggleSheetController(onClose: (_) => context.router.pop());
    final isSubmitting = useState(false);

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
              leading: Icon(SystemIcons.share, color: context.colors.foregroundMuted),
              text: ContentRowTextOptions(
                title: context.l10n.favoriteListShareButton,
              ),
              onTap: () async {
                if (isSubmitting.value) {
                  return;
                }
                isSubmitting.value = true;
                try {
                  final dataSource = await ref.read(favoriteListsRemoteDataSourceProvider.future);
                  final shareLink = await dataSource.generateShareLink(listId);
                  if (context.mounted) {
                    await safeShareText(shareLink.shareUrl, context: context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    showFavoriteListsErrorSheet(context, ref, e);
                  }
                } finally {
                  isSubmitting.value = false;
                  if (context.mounted) {
                    context.router.pop();
                  }
                }
              },
            ),
            ContentRow(
              leading: Icon(SystemIcons.bookmarkAdd, color: context.colors.foregroundMuted),
              text: ContentRowTextOptions(
                title: context.l10n.favoriteListAddPlace,
              ),
              onTap: () async {
                if (isSubmitting.value) {
                  return;
                }
                final favItem = await context.router.push<FavouriteItem>(
                  FavouritesSearchRoute(markerType: FavouriteItemMarkerType.place),
                );
                if (favItem == null) {
                  return;
                }
                final placeId = parseObjectIdFromFavouriteEntityId(favItem.entity?.id)?.toString();
                if (placeId == null) {
                  return;
                }
                isSubmitting.value = true;
                try {
                  final dataSource = await ref.read(favoriteListsRemoteDataSourceProvider.future);
                  await dataSource.addPlaceToList(listId, placeId);
                  ref
                    ..invalidate(favoriteListsResponseProvider)
                    ..invalidate(favoriteListDetailProvider(listId: listId))
                    ..invalidate(aggregatedFavoriteMarkersProvider);
                } catch (e) {
                  if (context.mounted) {
                    showFavoriteListsErrorSheet(context, ref, e);
                  }
                } finally {
                  isSubmitting.value = false;
                  if (context.mounted) {
                    context.router.pop();
                  }
                }
              },
            ),
            ContentRow(
              leading: Icon(SystemIcons.tuning, color: context.colors.foregroundMuted),
              text: ContentRowTextOptions(
                title: context.l10n.favoriteListSettingsTitle,
              ),
              onTap: () async {
                final shouldClose = await context.router.push(
                  CreateOrUpdateFavoriteListRoute(params: UpdateFavoriteListParams(listId: listId)),
                );
                if (shouldClose == true) {
                  context.router.pop();
                }
              },
            ),
            ContentRow(
              leading: Icon(GeneralIcons.trash, color: context.colors.errorDefault),
              text: ContentRowTextOptions(
                title: context.l10n.favoriteListDeleteButton,
              ),
              onTap: () async {
                final shouldClose = await context.router.push(
                  ConfirmationSheetRoute(
                    title: context.l10n.favoriteListDeleteButton,
                    message: context.l10n.favoriteListConfirmDeleteMessage,
                    buttons: [
                      SheetActionButton(label: context.l10n.cancel, onTap: () async => context.router.pop()),
                      SheetActionButton(
                        label: context.l10n.delete,
                        buttonColorScheme: ButtonColorScheme.error,
                        buttonType: ButtonType.primary,
                        showsLoadingAndHandlesErrors: true,
                        onTap: () async {
                          final dataSource = await ref.read(favoriteListsRemoteDataSourceProvider.future);
                          await dataSource.deleteFavoriteList(listId);
                          ref
                            ..invalidate(favoriteListsResponseProvider)
                            ..invalidate(aggregatedFavoriteMarkersProvider);
                        },
                      ),
                    ],
                  ),
                );
                if (shouldClose == true) {
                  context.router.pop(true);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
