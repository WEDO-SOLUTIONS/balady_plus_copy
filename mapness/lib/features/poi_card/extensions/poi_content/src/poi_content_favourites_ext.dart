import 'package:dgis_map/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/favorite_lists/providers/home_work_favorites.dart';
import 'package:mapness/features/favourites/helpers/favourite_entity_id.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension PoiContentFavouritesExt on DirectoryObjectMessage {
  PoiContentFavouriteModel? getFavourites(
    AsyncValue<HomeWorkFavorites> homeWork,
    AppLocalizations l10n,
    void Function() onPressed, {
    required bool isFavorited,
  }) {
    final objectId = id?.objectId;

    // If [objectId] is null in some case we don't want to break the app and return null
    // Generally it should not be null
    if (objectId == null) {
      return null;
    }

    final value = homeWork.value;
    if (value != null) {
      // If current [objectId] is the same as [objectId] of our home we show home card
      final showHome = parseObjectIdFromFavouriteEntityId(value.home?.entity?.id) == objectId;
      if (showHome) {
        return PoiContentFavouriteModel(
          type: PoiContentFavouriteTypes.home,
          title: l10n.home,
          onTap: onPressed,
        );
      }

      // If current [objectId] is the same as [objectId] of our work we show work card
      final showWork = parseObjectIdFromFavouriteEntityId(value.work?.entity?.id) == objectId;
      if (showWork) {
        return PoiContentFavouriteModel(
          type: PoiContentFavouriteTypes.work,
          title: l10n.work,
          onTap: onPressed,
        );
      }
    }

    // Otherwise, if it's a member of any (regular) favourite list, show the generic favourites card
    if (isFavorited) {
      return PoiContentFavouriteModel(
        type: PoiContentFavouriteTypes.favourites,
        title: l10n.favourites,
        onTap: onPressed,
      );
    }

    return null;
  }
}
