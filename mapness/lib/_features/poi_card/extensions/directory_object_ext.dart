import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';

import 'package:mapness/_features/happiness_map/domain/happiness_feedback.dart';

extension DirectoryObjectAddr on DirectoryObjectMessage {
  String makeAddress() {
    final region = address?.drilldown
        .firstWhereOrNull((element) => element?.type == 'region');
    final districtArea = address?.drilldown
        .firstWhereOrNull((element) => element?.type == 'district_area');
    final district = address?.drilldown
        .firstWhereOrNull((element) => element?.type == 'district');
    final street = address?.components
        .firstWhereOrNull((element) => element?.streetAddress != null)
        ?.streetAddress
        ?.street;

    return [street, district?.name, districtArea?.name, region?.name]
        .whereNotNull()
        .join(', ');
  }

  FavouriteItem mapToFavourite() => FavouriteItem(
        coordinates: Coordinates(
          latitude: markerPosition?.latitude ?? 0,
          longitude: markerPosition?.longitude ?? 0,
        ),
        id: 'overriden',
        subtitle: subtitle,
        title: title,
        entity: FavouriteItemEntity(
          sourceType: EntitySourceType.urbi,
          id: id?.objectId.toString() ?? 'id',
        ),
      );
}
