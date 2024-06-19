part of '../poi_card_footer.dart';

class _FavoriteItem extends ConsumerWidget {
  static const flex = 2;
  final int? objectId;
  final DirectoryObjectMessage objectMessage;

  const _FavoriteItem({
    required this.objectId,
    required this.objectMessage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// redraw footer if fav repo changes. Do not remove, entail bug with multi fav add!
    ref.watch(favouriteCacheProvider).valueOrNull;
    final provider = ref.watch(favouriteCacheProvider.notifier);
    final isFavourite = objectId != null && provider.isFavourite(objectId!);
    final favouriteItem =
        objectId != null ? provider.getFavouriteOrNull(objectId!) : null;
    final assetName = isFavourite
        ? 'assets/icons/svg/ic_fav_solid.svg'
        : 'assets/icons/svg/ic_fav_poi.svg';
    return FooterIconButton(
      flex: flex,
      assetName: assetName,
      colorIcon: context.color.textAndIconsStatusAccent,
      colorButton: context.staticColor.surfaceStatusContrastAccent,
      onTap: () =>
          _onFavTap(context: context, favouriteItem: favouriteItem, ref: ref),
    );
  }

  Future<void> _onFavTap({
    required BuildContext context,
    required WidgetRef ref,
    FavouriteItem? favouriteItem,
  }) async {
    await CommonFunctions.authOrOpen(
      context,
      callback: () {
        Metrics.logEventAdvanced(
          MetricsConstants.poiKeys.addToFavorite,
          group: MetricsConstants.poiTag,
          action: MetricAction.tap.toString(),
          props: {
            'objectId': objectId,
          },
        );

        final favState = ref.read(favouriteCacheProvider).valueOrNull;
        final favRepo = ref.read(favouriteCacheProvider.notifier);

        /// if already in favourites - remove
        if (favouriteItem != null) {
          favRepo.deleteItem(favouriteItem);
          return;
        }

        FavouriteItem? favItem = favouriteItem;
        if (favItem == null &&
            objectMessage.markerPosition != null &&
            objectMessage.id != null) {
          favItem = FavouriteItem(
            coordinates: Coordinates(
              latitude: objectMessage.markerPosition!.latitude,
              longitude: objectMessage.markerPosition!.longitude,
            ),
            id: 'overriden',
            subtitle: objectMessage.subtitle,
            title: objectMessage.title,
            entity: FavouriteItemEntity(
              sourceType: EntitySourceType.urbi,
              id: objectMessage.id!.objectId.toString(),
            ),
          );
        }

        if (favItem == null) {
          return;
        }

        /// do not show dialog if home and work are set
        if (favState?.home != null && favState?.work != null) {
          favRepo.addItem(objectMessage.mapToFavourite());
        } else {
          /// show dialog to choose home, work or regular
          _showDialog(context, favItem);
        }
      },
    );
  }

  Future<void> _showDialog(
    BuildContext context,
    FavouriteItem newFavourite,
  ) async {
    await showDialog(
      useSafeArea: false,
      context: context,
      builder: (contextDialog) => ProviderScope(
        parent: ProviderScope.containerOf(context),
        child: Theme(
          data: Theme.of(context),
          child: MediaQuery(
            data: MediaQuery.of(context),
            child: Directionality(
              textDirection: Directionality.of(context),
              child: Localizations.override(
                context: context,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: PoiFavoriteDialog(
                    favItem: newFavourite,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
