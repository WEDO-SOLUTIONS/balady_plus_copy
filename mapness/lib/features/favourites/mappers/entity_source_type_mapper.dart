import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/entities/favourites/favourite_item.dart';

extension EntitySourceTypeMapper on EntitySourceType {
  static proto.EntitySourceType fromDomain(EntitySourceType sourceType) => switch (sourceType) {
        EntitySourceType.unknown => proto.EntitySourceType.ENTITY_SOURCE_UNKNOWN,
        EntitySourceType.urbi => proto.EntitySourceType.ENTITY_SOURCE_URBI,
      };
}
