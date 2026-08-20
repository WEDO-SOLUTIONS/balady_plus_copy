import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_api_exception.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_remote_datasource.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_dto.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_place_dto.dart';
import 'package:mapness/features/favorite_lists/providers/aggregated_favorite_markers.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_list_detail.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_lists.dart';
import 'package:mapness/features/favorite_lists/ui/models/sheet_action_button.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/lib/share_util.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class FavoriteItemMenuPage extends HookConsumerWidget {
  final String listId;
  final FavoriteListPlaceDto place;

  const FavoriteItemMenuPage({required this.listId, required this.place, super.key});

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
              text: const ContentRowTextOptions(
                // TODO(claude): localize string
                title: 'Share a place',
              ),
              onTap: () async {
                await ShareUtil.sharePOI(context: context, objectId: place.placeId);
                context.router.pop();
              },
            ),
            ContentRow(
              leading: Icon(General16Icons.edit, color: context.colors.foregroundMuted),
              text: const ContentRowTextOptions(
                // TODO(claude): localize string
                title: 'Add custom name',
              ),
              onTap: () async {
                final shouldClose = await context.router.push(
                  EditFavoriteListItemNameRoute(listId: listId, place: place),
                );
                if (shouldClose == true) {
                  context.router.pop();
                }
              },
            ),
            ContentRow(
              leading: Icon(GeneralIcons.trash, color: context.colors.errorDefault),
              text: const ContentRowTextOptions(
                // TODO(claude): localize string
                title: 'Remove from the list',
              ),
              onTap: () async {
                final shouldClose = await context.router.push(
                  ConfirmationSheetRoute(
                    // TODO(claude): localize string
                    title: 'Delete from list',
                    // TODO(claude): localize string
                    message: 'Are you sure you want to delete this place from the list?',
                    buttons: [
                      SheetActionButton(label: context.l10n.cancel, onTap: () async => context.router.pop()),
                      SheetActionButton(
                        label: context.l10n.delete,
                        buttonColorScheme: ButtonColorScheme.error,
                        buttonType: ButtonType.primary,
                        showsLoadingAndHandlesErrors: true,
                        onTap: () async {
                          final dataSource = await ref.read(favoriteListsRemoteDataSourceProvider.future);
                          await dataSource.removePlaceFromList(listId, place.placeId);
                          ref
                            ..invalidate(favoriteListsProvider)
                            ..invalidate(favoriteListDetailProvider(listId: listId))
                            ..invalidate(aggregatedFavoriteMarkersProvider);
                        },
                      ),
                    ],
                  ),
                );
                if (shouldClose == true) {
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
