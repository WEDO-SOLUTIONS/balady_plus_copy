import 'package:dgis_map/library.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/favourites/helpers/favourite_entity_id.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/entities/coordinates.dart';

extension DirectoryObjectMessageExt on DirectoryObjectMessage {
  FavouriteItem mapToFavourite() {
    final objectId = id!.objectId;
    final entranceId = id!.entranceId;
    final entityId = buildFavouriteEntityId(objectId: objectId, entranceId: entranceId);

    return FavouriteItem(
      coordinates: Coordinates(
        latitude: markerPosition?.latitude ?? 0,
        longitude: markerPosition?.longitude ?? 0,
      ),
      id: entityId,
      subtitle: subtitle,
      title: title,
      entity: FavouriteItemEntity(
        id: entityId,
        sourceType: EntitySourceType.urbi,
      ),
    );
  }

  String pinTitle(AppLocalizations l10n) {
    if (isDroppedPin) {
      return l10n.droppedPin;
    }
    return title;
  }

  bool get isDroppedPin {
    // HARDCODE for Makkah - Mosque in the "Place to visit"
    // Need to fix in the future = bad practice
    if (id?.objectId == 70030076255291035) {
      return false;
    }
    final isDrop = title.contains('- $subtitle');
    return (fullAddressName?.streetAddress == title) || isDrop;
  }
}
