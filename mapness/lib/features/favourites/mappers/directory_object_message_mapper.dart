import 'package:dgis_map/library.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/shared/entities/coordinates.dart';

extension DirectoryObjectMessageExt on DirectoryObjectMessage {
  FavouriteItem mapToFavourite() => FavouriteItem(
        coordinates: Coordinates(
          latitude: markerPosition?.latitude ?? 0,
          longitude: markerPosition?.longitude ?? 0,
        ),
        id: '${id!.objectId}',
        // -${item.id!.entranceId}",
        subtitle: subtitle,
        title: title,
        entity: FavouriteItemEntity(
          // id: item.id!.toString(),
          id: '${id!.objectId}', // -${item.id!.entranceId}",
          sourceType: EntitySourceType.urbi,
        ),
      );
}
