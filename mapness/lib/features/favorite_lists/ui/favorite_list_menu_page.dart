import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_api_exception.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_remote_datasource.dart';
import 'package:mapness/features/favorite_lists/providers/aggregated_favorite_markers.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_lists.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
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
              text: const ContentRowTextOptions(
                // TODO(claude): localize string
                title: 'Share list',
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
                    final errorMessage = e is FavoriteListsApiException
                        ? e.localizedMessage(ref.read(appLanguageProvider))
                        : context.l10n.somethingWentWrongPleaseTryAgainLater;
                    ToastOverlay.of(context).show(title: errorMessage, isDismissible: true);
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
              // TODO(claude): set valid icon
              leading: Icon(SystemIcons.bookmarkAdd, color: context.colors.foregroundMuted),
              text: const ContentRowTextOptions(
                // TODO(claude): localize string
                title: 'Add a place',
              ),
              onTap: () async {
                // TODO(claude): what should I do here? Ask designer
                context.router.pop();
              },
            ),
            ContentRow(
              leading: Icon(SystemIcons.tuning, color: context.colors.foregroundMuted),
              text: const ContentRowTextOptions(
                // TODO(claude): localize string
                title: 'List settings',
              ),
              onTap: () async {
                final shouldClose = await context.router.push(CreateOrUpdateFavoriteListRoute(listId: listId));
                if (shouldClose == true) {
                  context.router.pop();
                }
              },
            ),
            ContentRow(
              leading: Icon(GeneralIcons.trash, color: context.colors.errorDefault),
              text: const ContentRowTextOptions(
                // TODO(claude): localize string
                title: 'Delete list',
              ),
              onTap: () async {
                final shouldClose = await context.router.push(
                  DeleteFavoriteListSubmitRoute(
                    // TODO(claude): localize string
                    title: 'Delete list',
                    // TODO(claude): localize string
                    message: 'Are you sure you want to delete this list?',
                    onConfirm: () async {
                      final dataSource = await ref.read(favoriteListsRemoteDataSourceProvider.future);
                      await dataSource.deleteFavoriteList(listId);
                      ref
                        ..invalidate(favoriteListsProvider)
                        ..invalidate(aggregatedFavoriteMarkersProvider);
                    },
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
