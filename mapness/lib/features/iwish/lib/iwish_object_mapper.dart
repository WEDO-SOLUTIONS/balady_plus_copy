import 'package:dgis_map/library.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as pb;
import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/entities/iwish/models/iwish_entity_variant.dart';

extension IwishItemResponseMapper on pb.IWishObject {
  IwishEntity toDomain() {
    final category = switch (this.category) {
      pb.IWishCategory.IWISH_CATEGORY_JOY_PARKS => IwishCategory.joyParks,
      pb.IWishCategory.IWISH_CATEGORY_UNKNOWN => IwishCategory.unknown,
      _ => IwishCategory.unknown,
    };
    final location = GeoPointMessage(
      latitude: this.location.point.latitude,
      longitude: this.location.point.longitude,
    );

    final state = switch (this.state) {
      pb.IWishState.IWISH_STATE_PLANNED => IwishState.planned,
      pb.IWishState.IWISH_STATE_COMPLETED => IwishState.completed,
      _ => IwishState.unknown,
    };

    List<String> photos(List<pb.IWishObject_Photo> photos) => photos.map((e) => e.image.url).toList();

    final iwishEntity = IwishEntity(
      category: category,
      feedbackSent: feedbackSent,
      id: id,
      location: location,
      selectedVariantId: selectedVariantId,
      state: state,
      subtitle: subtitle,
      title: title,
      photos: photos(this.photos),
      variants: variants
          .map(
            (variant) => IwishEntityVariant(
              id: variant.id,
              title: variant.title,
              preview: variant.preview.image.url,
              photos: photos(variant.photos),
            ),
          )
          .toList(),
      metadata: IwishMetadata(
        areaName: metadata.areaName,
        typeName: metadata.typeName,
        areaSize: metadata.areaSize,
        // switch (metadata.areaSize) {
        //   1 => AreaSize.small,
        //   2 => AreaSize.medium,
        //   _ => AreaSize.large,
        // },
        openingDate: DateTime.fromMillisecondsSinceEpoch(
          metadata.openingDate.value.toInt(),
        ),
      ),
      parkSize: switch (size) {
        pb.IWishSize.IWISH_SIZE_SMALL => ParkSize.small,
        pb.IWishSize.IWISH_SIZE_MEDIUM => ParkSize.medium,
        pb.IWishSize.IWISH_SIZE_LARGE => ParkSize.large,
        _ => ParkSize.unknown,
      },
    );

    return iwishEntity;
  }
}
