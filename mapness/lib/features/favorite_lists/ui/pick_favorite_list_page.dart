import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_api_exception.dart';
import 'package:mapness/features/favorite_lists/data/favorite_lists_remote_datasource.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_dto.dart';
import 'package:mapness/features/favorite_lists/providers/aggregated_favorite_markers.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_list_detail.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_list_membership_map.dart';
import 'package:mapness/features/favorite_lists/providers/favorite_lists.dart';
import 'package:mapness/features/favorite_lists/ui/widgets/favorite_progress_indicator.dart';
import 'package:mapness/features/favourites/mappers/directory_object_message_mapper.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:sheetify/sheetify.dart';

/// Простой экран «добавить в избранное»: отметить чекбоксами один или несколько
/// списков (новое API, сохраняется по кнопке Save через bulkAssignPlaceToLists)
/// или отметить точку как Дом/Работу (старая реализация, favouriteCacheProvider).
@RoutePage()
class PickFavoriteListPage extends HookConsumerWidget {
  final DirectoryObjectMessage data;

  const PickFavoriteListPage({required this.data, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useToggleSheetController(onClose: (_) => context.router.pop());
    final isSubmitting = useState(false);
    final favoriteListsAsync = ref.watch(favoriteListsProvider);
    final placeId = data.id?.objectId.toString();
    final canSetHomeOrWork = data.markerPosition != null && data.id != null;
    final overrides = useState<Map<String, bool>>(const {});
    final lists = favoriteListsAsync.value ?? const [];

    final membershipAsync = placeId == null
        ? const AsyncValue<Map<String, bool>>.data(<String, bool>{})
        : ref.watch(favoriteListMembershipMapProvider(placeId));
    final membershipMap = membershipAsync.value ?? const <String, bool>{};

    bool actualMembership(FavoriteListDto list) => membershipMap[list.id] ?? false;

    final allListsResolved = membershipAsync.hasValue;

    Future<void> save() async {
      if (isSubmitting.value || placeId == null) {
        return;
      }
      final actual = <String>{
        for (final list in lists)
          if (actualMembership(list)) list.id,
      };
      final desired = <String>{
        for (final list in lists)
          if (overrides.value[list.id] ?? actual.contains(list.id)) list.id,
      };
      final addToListIds = desired.difference(actual).toList();
      final removeFromListIds = actual.difference(desired).toList();

      if (addToListIds.isEmpty && removeFromListIds.isEmpty) {
        context.router.pop(true);
        return;
      }

      isSubmitting.value = true;
      try {
        final dataSource = await ref.read(favoriteListsRemoteDataSourceProvider.future);
        await dataSource.bulkAssignPlaceToLists(
          placeId,
          addToListIds: addToListIds,
          removeFromListIds: removeFromListIds,
        );
        ref
          ..invalidate(favoriteListsProvider)
          ..invalidate(aggregatedFavoriteMarkersProvider);
        for (final list in lists) {
          ref.invalidate(favoriteListDetailProvider(listId: list.id));
        }
        ref.invalidate(favoriteListMembershipMapProvider(placeId));
        if (context.mounted) {
          context.router.pop(true);
        }
      } catch (e) {
        isSubmitting.value = false;
        if (context.mounted) {
          final message = e is FavoriteListsApiException
              ? e.localizedMessage(ref.read(appLanguageProvider))
              : context.l10n.somethingWentWrongPleaseTryAgainLater;
          ToastOverlay.of(context).show(title: message, isDismissible: true);
        }
      }
    }

    Future<void> setAsHomeOrWork({required bool isHome}) async {
      if (isSubmitting.value) {
        return;
      }
      isSubmitting.value = true;
      try {
        final favItem = data.mapToFavourite();
        final notifier = ref.read(favouriteCacheProvider.notifier);
        if (isHome) {
          await notifier.setHome(favItem);
        } else {
          await notifier.setWork(favItem);
        }
        if (context.mounted) {
          context.router.pop(true);
        }
      } catch (e) {
        isSubmitting.value = false;
        if (context.mounted) {
          ToastOverlay.of(
            context,
          ).show(title: context.l10n.somethingWentWrongPleaseTryAgainLater, isDismissible: true);
        }
      }
    }

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
      header: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: Row(
          children: [
            Expanded(
              child: Text(
                // TODO(claude): localize string
                'Add to favorites',
                style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
              ),
            ),
            IconButton(onPressed: () => context.router.pop(), icon: const Icon(Icons.close)),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.all(Spacing.$4x),
      content: [
        ContentWrapper(
          color: context.colors.backgroundSurface1,
          children: [
            if (canSetHomeOrWork) ...[
              ContentRow(
                leading: Icon(GeneralIcons.home, color: context.colors.foregroundSoft),
                // TODO(claude): localize string
                text: const ContentRowTextOptions(title: 'Set as Home'),
                onTap: () {
                  if (isSubmitting.value) {
                    return;
                  }
                  setAsHomeOrWork(isHome: true);
                },
              ),
              ContentRow(
                leading: Icon(GeneralIcons.buildings, color: context.colors.foregroundSoft),
                // TODO(claude): localize string
                text: const ContentRowTextOptions(title: 'Set as Work'),
                isDividerEnabled: true,
                onTap: () {
                  if (isSubmitting.value) {
                    return;
                  }
                  setAsHomeOrWork(isHome: false);
                },
              ),
            ],
            ContentRow(
              leading: Icon(SystemIcons.zoomPlus, color: context.colors.accentDefault),
              text: ContentRowTextOptions(
                // TODO(claude): localize string
                title: 'Create a new list',
                titleOptions: ContentRowTextOption(baseColor: context.colors.accentDefault),
              ),
              isDividerEnabled: true,
              onTap: () {
                if (isSubmitting.value) {
                  return;
                }
                context.router.push(const CreateFavoriteListRoute());
              },
            ),
            ...favoriteListsAsync.when(
              data: (lists) => lists.isEmpty
                  ? [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: Spacing.$4x),
                        child: Text(
                          // TODO(claude): localize string
                          'No lists yet. Create one above.',
                          style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                        ),
                      ),
                    ]
                  : membershipAsync.when(
                      data: (_) => lists.map((list) {
                        final isSelected = overrides.value[list.id] ?? actualMembership(list);

                        return ContentRow(
                          leading: Icon(SystemIcons.bookmarkFill, color: context.colors.accentDefault),
                          text: ContentRowTextOptions(
                            title: list.name,
                            // TODO(claude): localize string and handle Arabic plural forms properly
                            subtitle: '${list.placeCount ?? 0} place${(list.placeCount ?? 0) == 1 ? '' : 's'}',
                          ),
                          trailing: ContentRowCustomTrailingOptions(
                            builder: (context) => IgnorePointer(
                              child: Checkbox(value: isSelected, onChanged: (_) {}),
                            ),
                          ),
                          onTap: () {
                            final updated = Map<String, bool>.from(overrides.value);
                            updated[list.id] = !isSelected;
                            overrides.value = updated;
                          },
                        );
                      }).toList(),
                      loading: () => [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: Spacing.$4x),
                          child: FavoriteProgressIndicator(),
                        ),
                      ],
                      error: (error, stackTrace) => [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: Spacing.$4x),
                          child: Text(
                            error is FavoriteListsApiException
                                ? error.localizedMessage(ref.read(appLanguageProvider))
                                : context.l10n.somethingWentWrongPleaseTryAgainLater,
                            style: context.textStyles.bodySmallRegular.copyWith(
                              color: context.colors.foregroundSoft,
                            ),
                          ),
                        ),
                      ],
                    ),
              loading: () => [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: Spacing.$4x),
                  child: FavoriteProgressIndicator(),
                ),
              ],
              error: (error, stackTrace) => [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Spacing.$4x),
                  child: Text(
                    error is FavoriteListsApiException
                        ? error.localizedMessage(ref.read(appLanguageProvider))
                        : context.l10n.somethingWentWrongPleaseTryAgainLater,
                    style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: Spacing.$4x),
        BaladyAppButton(
          // TODO(claude): localize string
          primaryLabel: 'Save',
          buttonColorScheme: ButtonColorScheme.accent,
          buttonState: isSubmitting.value
              ? ButtonState.loading
              : (allListsResolved ? ButtonState.defaultState : ButtonState.disabled),
          onTap: save,
        ),
      ],
    );
  }
}
