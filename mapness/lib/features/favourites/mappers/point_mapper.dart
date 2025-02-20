import 'package:mapness/_features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;

extension PointMapper on proto.Point {
  static proto.Point fromDomain(Coordinates coordinates) => proto.Point(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
      );

  Coordinates toDomain() => Coordinates(
        latitude: latitude,
        longitude: longitude,
      );
}
