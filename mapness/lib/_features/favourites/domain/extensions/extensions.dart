import 'package:dgis_map/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

extension FavouriteItemMarkerTypeExt on FavouriteItemMarkerType {
  String getHintText(BuildContext context) => switch (this) {
        FavouriteItemMarkerType.unknown => '',
        FavouriteItemMarkerType.home => context.l10n.home_address,
        FavouriteItemMarkerType.work => context.l10n.work_address,
        FavouriteItemMarkerType.place => '',
      };
}

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
