import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/favourites/favourites_state.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension PoiContentFavouritesExt on DirectoryObjectMessage {
  PoiContentFavouriteModel? getFavourites(
    AsyncValue<FavouritesState> state,
    AppLocalizations l10n,
    void Function() onPressed,
  ) =>
      state.whenOrNull(
        data: (value) {
          final objectId = id?.objectId;

          // If [objectId] is null in some case we don't want to break the app and return null
          // Generally it should not be null
          if (objectId == null) {
            return null;
          }

          // If current [objectId] is the same as [objectId] of our home we show home card
          final showHome = value.home?.id == objectId.toString();
          if (showHome) {
            return PoiContentFavouriteModel(
              type: PoiContentFavouriteTypes.home,
              title: l10n.home,
              onTap: onPressed,
            );
          }

          // If current [objectId] is the same as [objectId] of our work we show work card
          final showWork = value.work?.id == objectId.toString();
          if (showWork) {
            return PoiContentFavouriteModel(
              type: PoiContentFavouriteTypes.work,
              title: l10n.work,
              onTap: onPressed,
            );
          }

          // If current [objectId] is in the list of [objectId]'s of our favourites we show favourites card
          final isFavourite = value.items.firstWhereOrNull((e) => e.entity?.id == objectId.toString());
          if (isFavourite != null) {
            return PoiContentFavouriteModel(
              type: PoiContentFavouriteTypes.favourites,
              title: l10n.favourites,
              onTap: onPressed,
            );
          }

          // Otherwise return null
          return null;
        },
      );
}
