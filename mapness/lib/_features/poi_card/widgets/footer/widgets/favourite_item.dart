part of '../footer.dart';

class _FavouriveItem extends ConsumerWidget {
  static const flex = 2;
  final int? objectId;
  final DirectoryObjectMessage objectMessage;

  const _FavouriveItem({
    required this.objectId,
    required this.objectMessage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// redraw footer if fav repo changes. Do not remove, entail bug with multi fav add!
    ref.watch(favouriteRepositoryProvider).valueOrNull;
    final provider = ref.watch(favouriteRepositoryProvider.notifier);
    final isFavourite = provider.isFavourite(objectId);
    final favouriteItem = provider.getFavouriteOrNull(objectId);
    final assetName = isFavourite
        ? 'assets/icons/svg/ic_fav_solid.svg'
        : 'assets/icons/svg/ic_fav_poi.svg';
    return FooterIconButton(
      flex: flex,
      assetName: assetName,
      colorIcon: context.color.text_and_icons_status_accent,
      onTap: () => _onFavTap(context: context, item: favouriteItem, ref: ref),
    );
  }

  Future<void> _onFavTap({
    required BuildContext context,
    required WidgetRef ref,
    FavouriteItem? item,
  }) async {
    await CommonFunctions.authOrOpen(
      context,
      callback: () {
        final favState = ref.read(favouriteRepositoryProvider).valueOrNull;
        final favRepo = ref.read(favouriteRepositoryProvider.notifier);

        /// if already in favourites - remove
        if (item != null) {
          favRepo.delete(item);
        } else {
          /// do not show dialog if home and work are set
          if (favState?.home != null && favState?.work != null) {
            favRepo.addItem(objectMessage.mapToFavourite());
          } else {
            /// show dialog to choose home, work or regular
            _showDialog(context, getNewFavourive());
          }
        }
      },
    );
  }

  FavouriteItem getNewFavourive() => FavouriteItem(
        coordinates: Coordinates(
          latitude: objectMessage.markerPosition?.latitude ?? 0,
          longitude: objectMessage.markerPosition?.longitude ?? 0,
        ),
        id: 'overriden',
        subtitle: objectMessage.subtitle,
        title: objectMessage.title,
        entity: FavouriteItemEntity(
          sourceType: EntitySourceType.urbi,
          id: objectMessage.id?.objectId.toString() ?? 'id',
        ),
      );

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
