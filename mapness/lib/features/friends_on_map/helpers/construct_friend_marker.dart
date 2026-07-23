import 'package:dgis_map/library.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/friends_on_map/model/friend_location.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

Marker constructFriendMarker(FriendLocation friend) {
  final position = GeoPointWithElevationMessage(
    latitude: friend.latitude,
    longitude: friend.longitude,
    elevation: 1,
  );

  return Marker(
    id: friend.userId,
    // Placeholder pin — swap for a dedicated friend/avatar marker asset once designed.
    options: MarkerOptionsMessage(position: position, icon: Assets.icons.svg.layers.icFavPin.keyName.markerIcon()),
    onTap: () => logger.log(
      'Friend tapped: userId=${friend.userId}, lastUpdated=${friend.lastUpdated}, '
      'battery=${friend.batteryLevel}',
      logLevel: MapnessLogLevel.info,
    ),
  );
}
