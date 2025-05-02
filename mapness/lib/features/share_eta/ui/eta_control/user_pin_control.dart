import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/share_eta/models/eta_info_model.dart';
import 'package:mapness/features/share_eta/models/eta_route_info.dart';
import 'package:mapness/features/share_eta/providers/eta_geo_subscriber.dart';
import 'package:mapness/features/share_eta/providers/websocker_error_handler_porvider.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';

class UserPinControl extends ConsumerWidget {
  final User? user;

  static final String _unauthorizedUser = Assets.imagesSvg.etaUnknownUser.keyName;
  static final String _authorizedUser = Assets.imagesSvg.etaNamedUser.keyName;
  static final String _userWithPhoto = Assets.imagesSvg.etaPhotoUser.keyName;

  static final String _userLostConnection = Assets.imagesSvg.etaLostConnectionControl.keyName;

  const UserPinControl({super.key, this.user});

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context, WidgetRef ref) {
    final (code, _) = ref.watch(websocketErrorHandlerProvider);
    final (info, _) = ref.read(etaGeoSubscriberProvider);

    return GestureDetector(
      onTap: () async {
        if (info != null) {
          final payload = info.payload as EtaInfoPayload?;
          if (payload?.lat != null && payload?.lon != null) {
            final lat = payload!.lat!;
            final lon = payload.lon!;
            const zoom = 17.0;
            const tilt = 0.0;
            const bearing = 0.0;

            final cameraPositionController = ref.read(cameraPositionProvider.notifier);
            await cameraPositionController.animateTo(
              CameraPositionMessage(
                point: GeoPointMessage(latitude: lat, longitude: lon),
                zoom: zoom,
                tilt: tilt,
                bearing: bearing,
              ),
            );
          }
        }
      },
      child: ClipOval(
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            // Added black and white filter for unactive connection
            code != null && user?.photoUrl != null ? Colors.grey : Colors.transparent,
            BlendMode.saturation,
          ),
          child: Stack(
            children: [
              SvgPicture.asset(
                _getUserIcon(isConnectionLost: code != null),
                width: 32,
                height: 32,
              ),
              // draw user photo if user has one
              if (user?.photoUrl != null)
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Center(
                    child: SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: ClipOval(
                        child: Image.network(
                          user!.photoUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getUserIcon({bool isConnectionLost = false}) {
    if (isConnectionLost && user?.photoUrl == null) {
      return _userLostConnection;
    }

    if (user == null) {
      return _unauthorizedUser;
    }

    if (user!.firstName != null && user!.lastName != null) {
      return _authorizedUser;
    }

    if (user!.photoUrl != null) {
      return _userWithPhoto;
    }

    return _unauthorizedUser;
  }
}
