import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/favourites/helpers/favourite_entity_id.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';

// import 'package:mapness/features/saudi_pass/widgets/favorite_delete_menu.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/share_util.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/widgets/favourites/favourite_item_widget.dart';
import 'package:mapness/widgets/favourites/favourites_toggle.dart';
import 'package:mapness/widgets/favourites/pinned_place_card.dart';
import 'package:provider/provider.dart';

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
    // await _onDeleteConfirmation(context, item);
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
  // Future<bool?> _onDeleteConfirmation(BuildContext ctx, FavouriteItem item) async => showDialog(
  //   context: context,
  //   useSafeArea: false,
  //   builder: (_) => DialogDeleteMenu(
  //     title: ctx.l10n.deleteFromFavourites,
  //     description: ctx.l10n.deleteAlertFavourites,
  //     cancel: ctx.l10n.cancel,
  //     remove: ctx.l10n.delete,
  //     onRemove: () => _onDelete(item),
  //   ),
  // );

  @override
  Widget build(BuildContext ctx) {
    final asyncState = ref.watch(favouriteCacheProvider);
    return asyncState.map(
      error: (error) => ErrorSheetWidget(
        buttonLabel: context.l10n.tryAgain,
        onRetry: () {
          ref.invalidate(favouriteCacheProvider);
        },
        onClose: (_) => context.router.pop(),
      ),
      loading: (_) => Material(
        color: ctx.colors.backgroundSurface1,
        child: Center(child: CircularProgressIndicator(color: ctx.colors.accentDefault)),
      ),
      data: (data) {
        final state = data.value;
        return Scaffold(
          appBar: BaladyTopBar(
            systemUiOverlayStyle: context.read<ThemeController>().systemOverlayStyle,
            leading: InkWell(
              onTap: () {
                if (!isEditing) {
                  context.router.pop();
                } else {
                  toggleEditing();
                }
              },
              child: Row(
                children: [
                  Spacing.$4x.widthBox,
                  if (isEditing)
                    Text(ctx.l10n.cancel, style: ctx.textStyle.footNote.copyWith(color: ctx.colors.accentDefault)),
                  if (!isEditing) Icon(SystemIcons.arrowCornerLeftLarge, color: ctx.colors.foregroundDefault),
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
                      color: selectedItems.isEmpty ? ctx.colors.foregroundMuted : ctx.colors.errorDefault,
                    ),
                  )
                else
                  InkWell(
                    onTap: toggleEditing,
                    child: Text(
                      ctx.l10n.select,
                      style: ctx.textStyle.footNoteBold.copyWith(color: ctx.colors.accentDefault),
                    ),
                  ),
                Spacing.$4x.widthBox,
              ],
            ),
            textStyle: ctx.textStyle.footNoteBold.copyWith(color: ctx.colors.foregroundDefault),
            title: ctx.l10n.favourites,
          ),
          backgroundColor: context.colors.backgroundSurface4,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$1x),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: FavouritesToggle(isEditing: isEditing)),
                SliverToBoxAdapter(child: Spacing.$4x.heightBox),
                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Builder(
                        builder: (context) {
                          final home = state.home;
                          final entity = home?.entity;
                          final homeTitle = ctx.l10n.home;
                          final coordinates = home?.coordinates;
                          final objectId = parseObjectIdFromFavouriteEntityId(entity?.id);
                          return Expanded(
                            child: PinnedPlaceCard(
                              key: Key('home${home?.id}'),
                              title: homeTitle,
                              address: home?.title ?? ctx.l10n.addAddress,
                              iconData: GeneralIcons.home,
                              isEditing: isEditing && home != null,
                              isAdded: home != null,
                              onDelete: () => _deleteItem(home, ctx),
                              onTapRoute: () {
                                ctx.router.push(
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
                                                objectId: objectId,
                                              )
                                            : null,
                                        label: homeTitle,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onTapShare: () => ShareUtil.sharePOI(
                                context: context,
                                objectId: objectId?.toString(),
                                markerCoords: home?.coordinates,
                              ),
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
                                  : () => ctx.router.replaceOrPush(
                                      route: PoiCardWidgetRoute(
                                        objectId: DgisObjectIdMessage(objectId: objectId!, entranceId: 0),
                                      ),
                                      toCompareRoutes: [PoiCardWidgetRoute.page],
                                    ),
                            ),
                          );
                        },
                      ),
                      Spacing.$4x.widthBox,
                      Builder(
                        builder: (context) {
                          final work = state.work;
                          final workTitle = ctx.l10n.work;
                          final entity = work?.entity;
                          final coordinates = work?.coordinates;
                          final objectId = parseObjectIdFromFavouriteEntityId(entity?.id);
                          return Expanded(
                            child: PinnedPlaceCard(
                              key: Key('work${work?.id}'),
                              title: workTitle,
                              address: work?.title ?? ctx.l10n.addAddress,
                              iconData: GeneralIcons.briefcase,
                              isEditing: isEditing && work != null,
                              isAdded: work != null,
                              onDelete: () => _deleteItem(work, ctx),
                              onTapRoute: () {
                                context.router.push(
                                  RoutingRoutesRoute(
                                    points: [
                                      RouteParamsPointWithLabel(value: null, label: context.l10n.myLocation),
                                      RouteParamsPointWithLabel(
                                        value: coordinates?.latitude != null && coordinates?.longitude != null
                                            ? RouteParamsPoint(
                                                latitude: coordinates!.latitude,
                                                longitude: coordinates.longitude,
                                                objectId: objectId,
                                              )
                                            : null,
                                        label: workTitle,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onTapShare: () => ShareUtil.sharePOI(
                                context: context,
                                objectId: objectId?.toString(),
                                markerCoords: work?.coordinates,
                              ),
                              onTapChange: () {
                                context.router.push(FavouritesSearchRoute(markerType: FavouriteItemMarkerType.work));
                              },
                              onTap: work == null
                                  ? () => context.router.push(
                                      FavouritesSearchRoute(markerType: FavouriteItemMarkerType.work),
                                    )
                                  : () => ctx.router.replaceOrPush(
                                      route: PoiCardWidgetRoute(
                                        objectId: DgisObjectIdMessage(objectId: objectId!, entranceId: 0),
                                      ),
                                      toCompareRoutes: [PoiCardWidgetRoute.page],
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(child: Spacing.$4x.heightBox),
                if (state.items.isEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: context.colors.accentDefault,
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(Spacing.$4x),
                            child: Text(
                              context.l10n.toSavePlacesAsFavoritesOpenTheCardAndTapTheBookmarkIcon,
                              textAlign: TextAlign.center,
                              style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.staticWhite),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(Spacing.$4x).copyWith(top: 0),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                            child: Image.asset(
                              fit: BoxFit.fitWidth,
                              width: double.infinity,
                              ref.read(appLanguageProvider) == Language.arabic
                                  ? SaudiNationalDay.isNow()
                                        ? Assets.images.favoritesExampleArabicSaudiday.keyName
                                        : Assets.images.favoritesExampleArabic.keyName
                                  : SaudiNationalDay.isNow()
                                  ? Assets.images.favoritesExampleEnglishSaudiday.keyName
                                  : Assets.images.favoritesExampleEnglish.keyName,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                SliverList.separated(
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => Divider(height: 0.5, color: context.colors.borderSoft),
                  itemBuilder: (_, index) {
                    final item = state.items[index];
                    const radius = Radius.circular(RadiusBorder.l);
                    return Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: context.colors.backgroundSurface1,
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
                        onShareTap: () => ShareUtil.sharePOI(
                          context: context,
                          objectId: parseObjectIdFromFavouriteEntityId(item.entity?.id)?.toString(),
                          markerCoords: item.coordinates,
                        ),
                        onDelete: () => _deleteItem(item, ctx),
                        onRouteTap: () {
                          context.router.push(
                            RoutingRoutesRoute(
                              points: [
                                RouteParamsPointWithLabel(value: null, label: context.l10n.myLocation),
                                RouteParamsPointWithLabel(
                                  value: RouteParamsPoint(
                                    latitude: item.coordinates.latitude,
                                    longitude: item.coordinates.longitude,
                                    objectId: parseObjectIdFromFavouriteEntityId(item.entity?.id),
                                  ),
                                  label: item.title,
                                ),
                              ],
                            ),
                          );
                        },
                        onTap: () => ctx.router.replaceOrPush(
                          route: PoiCardWidgetRoute(
                            closestPoint: LatLng(
                              latitude: item.coordinates.latitude,
                              longitude: item.coordinates.longitude,
                            ),
                            objectId: DgisObjectIdMessage(
                              objectId: parseObjectIdFromFavouriteEntityId(item.entity?.id)!,
                              entranceId: 0,
                            ),
                          ),
                          toCompareRoutes: [PoiCardWidgetRoute.page],
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
