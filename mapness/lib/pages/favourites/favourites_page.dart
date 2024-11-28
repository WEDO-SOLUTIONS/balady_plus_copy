import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_cache.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/share_util.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/widgets/favourites/favourite_item_widget.dart';
import 'package:mapness/widgets/favourites/favourites_toggle.dart';
import 'package:mapness/widgets/favourites/pinned_place_card.dart';

@RoutePage()
class FavouritesPage extends ConsumerStatefulWidget {
  const FavouritesPage({super.key});

  @override
  ConsumerState<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends ConsumerState<FavouritesPage> {
  bool isEditing = false;
  Map<String, FavouriteItem> selectedItems = {};

  void toggleEditing() {
    setState(() {
      if (isEditing) {
        selectedItems.clear();
      }
      isEditing = !isEditing;
    });
  }

  /// Special method to delete the item from the cache for home and work cards.
  /// Combines the logic of the [_onDeleteConfirmation] and [_onDelete] methods.
  Future<void> _deleteItem(FavouriteItem? item, BuildContext context) async {
    if (item == null) {
      return;
    }
    final result = await _onDeleteConfirmation(item, context);

    if (result == true) {
      _onDelete(item);
    }
  }

  /// Pure function to delete the item from the cache
  /// Created specifically to work with dismissible items (Dismissible widget that can be swiped to delete)
  /// For [Dismissible] this method should be called after the [_onDeleteConfirmation] method
  ///
  /// Example:
  /// ```dart
  ///   _onDeleteConfirmation(item, context).then((value) {
  ///    if (value == true) {
  ///      _onDelete(item);
  ///    }
  ///  });
  /// ```
  void _onDelete(FavouriteItem item) {
    ref.read(favouriteCacheProvider.notifier).deleteItem(item);
  }

  /// We have to pass [ctx] value because of text and colors settings, localization. The easiest way to do this
  /// Also here we have to set color for text styles because [CupertinoActionSheet] make it by default in
  /// Apple / iOS style
  /// We can't control [borderRadius] or [padding]s here. But this is the simple and robust solution
  ///
  /// This method should return [bool] value to show if the item should be deleted or not
  Future<bool?> _onDeleteConfirmation(FavouriteItem item, BuildContext ctx) async => showCupertinoModalPopup<bool>(
        context: ctx,
        builder: (context) => CupertinoActionSheet(
          message: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              context.l10n.deleteAlertFavourites,
              style: context.textStyle.footNote.copyWith(
                color: context.color.textAndIconsBaseSecondary,
                letterSpacing: 0,
              ),
            ),
          ),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              isDefaultAction: true,
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                context.l10n.delete,
                style: context.textStyle.callout.copyWith(
                  color: context.color.textAndIconsStatusNegative,
                ),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(
              context.l10n.cancel,
              style: context.textStyle.callout.copyWith(
                color: context.color.textAndIconsBasePrimary,
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(favouriteCacheProvider);
    return asyncState.map(
      error: (error) => ErrorSheet(
        buttonLabel: context.l10n.tryAgain,
        onRetry: () {
          ref.invalidate(favouriteCacheProvider);
        },
      ),
      loading: (_) => Material(
        color: context.color.surfaceBasePrimary,
        child: Center(
          child: CircularProgressIndicator(
            color: context.color.textAndIconsStatusAccent,
          ),
        ),
      ),
      data: (data) {
        final state = data.value;
        return Scaffold(
          appBar: BaladyTopBar(
            systemUiOverlayStyle: SystemUiOverlayStyle.dark,
            leading: InkWell(
              onTap: () {
                if (!isEditing) {
                  context.router.popForced();
                } else {
                  toggleEditing();
                }
              },
              child: Row(
                children: [
                  Spacing.$4x.widthBox,
                  if (isEditing)
                    Text(
                      context.l10n.cancel,
                      style: context.textStyle.footNote.copyWith(
                        color: context.color.textAndIconsStatusAccent,
                      ),
                    ),
                  if (!isEditing)
                    Icon(
                      SystemIcons.arrowCornerLeftLarge,
                      color: context.color.textAndIconsStatusAccent,
                    ),
                  if (!isEditing)
                    Text(
                      context.l10n.back,
                      style: context.textStyle.footNote.copyWith(
                        color: context.color.textAndIconsStatusAccent,
                      ),
                    ),
                ],
              ),
            ),
            trailing: Row(
              children: [
                if (isEditing)
                  InkWell(
                    onTap: selectedItems.isEmpty
                        ? null
                        : () async {
                            await ref.read(favouriteCacheProvider.notifier).deleteItems(selectedItems.values.toList());
                            setState(() {
                              selectedItems.clear();
                            });
                          },
                    child: Icon(
                      GeneralIcons.trash,
                      color: selectedItems.isEmpty
                          ? context.color.textAndIconsBaseTertiary
                          : context.color.textAndIconsStatusNegative,
                    ),
                  )
                else
                  InkWell(
                    onTap: toggleEditing,
                    child: Text(
                      context.l10n.select,
                      style: context.textStyle.footNoteBold.copyWith(
                        color: context.color.textAndIconsStatusAccent,
                      ),
                    ),
                  ),
                Spacing.$4x.widthBox,
              ],
            ),
            textStyle: context.textStyle.footNoteBold.copyWith(
              color: context.color.textAndIconsBasePrimary,
            ),
            title: context.l10n.favourites,
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.$4x,
              vertical: Spacing.$4x,
            ),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: FavouritesToggle(isEditing: isEditing)),
                SliverToBoxAdapter(child: Spacing.$4x.heightBox),
                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Builder(
                        builder: (_) {
                          final home = state.home;
                        final entity = home?.entity;
                          final homeTitle = context.l10n.home;
                          final coordinates = home?.coordinates;
                        final id = entity?.id ?? '';
                        return Expanded(
                          child: PinnedPlaceCard(
                            key: Key('home${home?.id}'),
                            title: homeTitle,
                              address: home?.subtitle ?? context.l10n.addAddress,
                              iconData: GeneralIcons.home,
                            isEditing: isEditing && home != null,
                            isAdded: home != null,
                              onDelete: () => _deleteItem(home, context),
                              onTapRoute: () {
                                context.router.push(
                                  RoutingRoutesRoute(
                                  points: [
                                    RouteParamsPointWithLabel(
                                      value: null,
                                      label: context.l10n.myLocation,
                                    ),
                                    RouteParamsPointWithLabel(
                                      value: coordinates?.latitude != null && coordinates?.longitude != null
                                          ? RouteParamsPoint(
                                              latitude: coordinates!.latitude,
                                        longitude: coordinates.longitude,
                                        objectId: int.tryParse(id),
                                            )
                                          : null,
                                      label: homeTitle,
                                    ),
                                  ],
                                ),
                              );
                            },
                            onTapShare: () => ShareUtil.share(entity?.id),
                            onTapChange: () {
                              context.router.push(
                                FavouritesSearchRoute(
                                  markerType: FavouriteItemMarkerType.home,
                                ),
                              );
                            },
                            onTap: home == null
                                ? () => context.router.push(
                                      FavouritesSearchRoute(
                                        markerType: FavouriteItemMarkerType.home,
                                      ),
                                    )
                                  : () => context.router.push(
                                        PoiCardWidgetRoute(
                                        objectId: DgisObjectIdMessage(
                                          objectId: int.parse(id),
                                          entranceId: 0,
                                        ),
                                      ),
                                    ),
                          ),
                        );
                        },
                      ),
                      Spacing.$4x.widthBox,
                      Builder(
                        builder: (_) {
                          final work = state.work;
                          final workTitle = context.l10n.work;
                          final entity = work?.entity;
                          final coordinates = work?.coordinates;
                          final id = entity?.id ?? '';
                          return Expanded(
                            child: PinnedPlaceCard(
                              key: Key('work${work?.id}'),
                              title: workTitle,
                              address: work?.subtitle ?? context.l10n.addAddress,
                              iconData: GeneralIcons.briefcase,
                              isEditing: isEditing && work != null,
                              isAdded: work != null,
                              onDelete: () => _deleteItem(work, context),
                              onTapRoute: () {
                                context.router.push(
                                  RoutingRoutesRoute(
                                    points: [
                                      RouteParamsPointWithLabel(
                                        value: null,
                                        label: context.l10n.myLocation,
                                      ),
                                      RouteParamsPointWithLabel(
                                        value: coordinates?.latitude != null && coordinates?.longitude != null ? RouteParamsPoint(
                                          latitude: coordinates!.latitude,
                                          longitude: coordinates.longitude,
                                          objectId: int.tryParse(entity!.id),
                                        ) : null,
                                        label: workTitle,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onTapShare: () => ShareUtil.share(entity?.id),
                              onTapChange: () {
                                context.router.push(
                                  FavouritesSearchRoute(
                                    markerType: FavouriteItemMarkerType.work,
                                  ),
                                );
                              },
                              onTap: work == null
                                  ? () => context.router.push(
                                        FavouritesSearchRoute(
                                          markerType: FavouriteItemMarkerType.work,
                                        ),
                                      )
                                  : () => context.router.push(
                                        PoiCardWidgetRoute(
                                          objectId: DgisObjectIdMessage(
                                            objectId: int.parse(id),
                                            entranceId: 0,
                                          ),
                                        ),
                                      ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Spacing.$4x.heightBox,
                ),
                if (state.items.isEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: context.staticColor.surfaceStatusAccent,
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(Spacing.$4x),
                              child: Text(
                                context.l10n.toSavePlacesAsFavoritesOpenTheCardAndTapTheBookmarkIcon,
                                textAlign: TextAlign.center,
                                style: context.textStyle.text.copyWith(
                                  color: context.staticColor.textAndIconsBaseInversePrimary,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: Spacing.$4x,
                                right: Spacing.$4x,
                                bottom: Spacing.$4x,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  fit: BoxFit.fitWidth,
                                  ref.read(appLanguageProvider) == Language.arabic
                                      ? 'assets/images/favorites_example_arabic.png'
                                      : 'assets/images/favorites_example_english.png',
                                  package: PackageConfig.packageName,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                SliverList.separated(
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, index) {
                    final item = state.items[index];
                    const radius = Radius.circular(RadiusBorder.l);
                    return Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: context.color.surfaceBaseSecondary,
                        borderRadius: BorderRadius.vertical(
                          top: index == 0 ? radius : Radius.zero,
                          bottom: index == state.items.length - 1 ? radius : Radius.zero,
                        ),
                      ),
                      child: FavouriteItemWidget(
                        key: ValueKey(item.id),
                        isFirst: index == 0,
                        isLast: index == state.items.length - 1,
                        isSelected: selectedItems.containsKey(item.id),
                        onSelect: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              selectedItems[item.id] = item;
                            } else {
                              selectedItems.remove(item.id);
                            }
                          });
                        },
                        onShareTap: () => ShareUtil.share(item.entity?.id),
                        onDelete: () => _deleteItem(item, context),
                        onRouteTap: () {
                          context.router.push(
                            RoutingRoutesRoute(
                              points: [
                                RouteParamsPointWithLabel(
                                  value: null,
                                  label: context.l10n.myLocation,
                                ),
                                RouteParamsPointWithLabel(
                                  value: RouteParamsPoint(
                                    latitude: item.coordinates.latitude,
                                    longitude: item.coordinates.longitude,
                                    objectId: int.tryParse(item.entity!.id),
                                  ),
                                  label: item.title,
                                ),
                              ],
                            ),
                          );
                        },
                        onTap: () => context.router.push(
                          PoiCardWidgetRoute(
                            objectId: DgisObjectIdMessage(
                              objectId: int.parse(item.entity!.id),
                              entranceId: 0,
                            ),
                          ),
                        ),
                        isEditing: isEditing,
                        item: item,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
