import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:mapness/features/share_eta/models/eta_info_model.dart';
import 'package:mapness/features/share_eta/models/eta_route_info.dart';
import 'package:mapness/features/share_eta/models/ws_config.dart';
import 'package:mapness/features/share_eta/providers/eta_websocket_locator.dart';
import 'package:mapness/features/share_eta/providers/websocker_error_handler_porvider.dart';
import 'package:mapness/features/share_eta/providers/websocket_type_provider.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'eta_geo_subscriber.g.dart';

@riverpod
class EtaGeoSubscriber extends _$EtaGeoSubscriber {
  static const String _unauthorizedUser = 'assets/images_svg/eta_unknown_user_marker.svg';
  static const String _autharizedUser = 'assets/images_svg/eta_auth_blank_user_marker.svg';
  static const String _lostConnection = 'assets/images_svg/eta_lost_connection_marker.svg';

  static const imgSize = 48;

  EtaInfoModel<EtaRoutePayload?>? _metaInfo;

  bool _reconnectingInProgress = false;
  bool _isFirstLocationFetch = true;

  @override
  (EtaInfoModel<dynamic>?, EtaInfoModel<EtaRoutePayload?>?) build() {
    final settings = MapObjectManagerSettings.eta();
    ref
      ..watch(
        mapObjectManagerProvider(
          named: settings.name,
          layerId: settings.layerId,
        ),
      )
      ..listen(websocketErrorHandlerProvider, (_, current) async {
        final (code, reason) = current;
        await _onErrorStatus(code, reason);
      })
      ..onDispose(() {
        EtaWebsocket().clearInfoListeners();
      });

    return (null, null);
  }

  Future<void> _updateEtaInfo(EtaInfoModel etaInfo) async {
    final _etaInfo = etaInfo.type == EtaType.geolocation ? etaInfo : null;
    state = (_etaInfo, _metaInfo);

    if (etaInfo.type == EtaType.geolocation) {
      await _processDrawUserMarker();

      await _processMoveCameraToUser();

      _isFirstLocationFetch = false;
    } else if (etaInfo.type == EtaType.streamMetadata) {
      _metaInfo = etaInfo as EtaInfoModel<EtaRoutePayload?>;

      // TODO(Scroollocker): Implement route drawing on the map
      // Get route from model
      // ref.listen(routesProvider(
      //       startPoint: RouteParamsPoint(latitude: latitude!, longitude: longitude!),
      //       finishPoint: RouteParamsPoint(
      //         latitude: 24.711564057132794,
      //         longitude: 46.67427162103001,
      //       ),
      //       navType: RouteSearchOptionsMessage.car,
      //     ), (_, current) async {
      //   if (current.valueOrNull?.isEmpty == true) {
      //     WidgetsBinding.instance.addPostFrameCallback((_) {
      //       _showEtaExpired(rootNavigatorKey.currentContext!);
      //     });
      //   } else {
      //     await ref.read(dgisControllerProvider).value?.setPublicTransportActiveRoute(0);
      //   }
    }
  }

  Future<void> stopStreaming() async {
    try {
      EtaWebsocket().clearInfoListeners();
      await EtaWebsocket().stop();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      final settings = MapObjectManagerSettings.eta();
      final mapObjectManager = ref.read(
        mapObjectManagerProvider(
          named: settings.name,
          layerId: settings.layerId,
        ).notifier,
      );
      unawaited(mapObjectManager.removeAllMarkers());
    }
  }

  Future<void> startStreaming(String tokenId, String streamId) async {
    // Stop previous stream
    await stopStreaming();

    _isFirstLocationFetch = true;
    final envProvider = await ref.read(dgisEnvironmentProvider.future);

    try {
      await EtaWebsocket().start(
        streamId: streamId,
        token: tokenId,
        shareEtaApiUrl: envProvider.shareEtaApi,
      );
      ref.read(websocketErrorHandlerProvider.notifier).setStatus(null, null);
      // EtaWebsocket().addConnectionLostListener(_onErrorStatus);
      EtaWebsocket().addEtaInfoListener(_updateEtaInfo);
    } catch (e) {
      rethrow;
    } finally {
      ref.read(websocketTypeProvider.notifier).setType(type: SubscriptionType.get);
    }
  }

  Future<void> _processDrawUserMarker({bool isAvailable = true}) async {
    final (etaInfo, _) = state;
    if (etaInfo == null) {
      return;
    }
    final payload = etaInfo.payload as EtaInfoPayload;
    if (payload.lat == null || payload.lon == null) {
      return;
    }
    if (isAvailable) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _processDrawMarker(
          GeoPointWithElevationMessage(
            latitude: payload.lat!,
            longitude: payload.lon!,
            elevation: 0,
          ),
          _metaInfo?.payload?.user,
        );
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _processDrawUnavailableMarker(
          GeoPointWithElevationMessage(
            latitude: payload.lat!,
            longitude: payload.lon!,
            elevation: 0,
          ),
          _metaInfo?.payload?.user,
        );
      });
    }
  }

  Future<void> _processMoveCameraToUser() async {
    if (_isFirstLocationFetch) {
      final (etaInfo, _) = state;
      if (etaInfo == null) {
        return;
      }

      /// Move camera to user position
      final payload = etaInfo.payload as EtaInfoPayload;
      if (payload.lat == null || payload.lon == null) {
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref.read(cameraPositionProvider.notifier).animateTo(
              CameraPositionMessage(
                point: GeoPointMessage(latitude: payload.lat!, longitude: payload.lon!),
                zoom: 17,
                tilt: 0,
                bearing: 0,
              ),
            );
      });
    }
  }

  Future<void> _processDrawMarker(GeoPointWithElevationMessage point, User? user) async {
    final settings = MapObjectManagerSettings.eta();
    final mapObjectManager = ref.read(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
      ).notifier,
    );

    final marker = await _getMarker(point, user);

    await mapObjectManager.removeAllMarkers();
    await mapObjectManager.addMarker(marker);
  }

  Future<void> _processDrawUnavailableMarker(GeoPointWithElevationMessage point, User? user) async {
    final settings = MapObjectManagerSettings.eta();
    final mapObjectManager = ref.read(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
      ).notifier,
    );

    final marker = await _getUnavailableMarker(point, user);

    await mapObjectManager.removeAllMarkers();
    await mapObjectManager.addMarker(marker);
  }

  //TODO(scroollocker): Move code to utils
  Future<img.Image> processImage(String imgUrl, {bool isUnavailable = false}) async {
    // Load the mask image from assets
    final maskData = await rootBundle.load('packages/mapness/assets/images/marker_eta_mask.png');
    final maskBytes = maskData.buffer.asUint8List();

    final mask = img.decodeImage(maskBytes)!;

    var mask48x48 = img.copyResize(mask, width: imgSize, height: imgSize, interpolation: img.Interpolation.average);

    if (mask48x48.hasAlpha == false) {
      mask48x48 = mask48x48.convert(format: mask48x48.format, numChannels: 4);
    }

    // Load the image from the network
    final response = await http.get(Uri.parse(imgUrl));
    var networkImage = img.decodeImage(response.bodyBytes)!;
    if (networkImage.hasAlpha == false) {
      networkImage = networkImage.convert(format: networkImage.format, numChannels: 4);
    }

    if (isUnavailable) {
      networkImage = img.grayscale(networkImage);
    }

    networkImage = img.copyCropCircle(
      networkImage,
      centerX: networkImage.width ~/ 2,
      centerY: networkImage.height ~/ 2,
      radius: networkImage.width ~/ 2,
    );

    final img24x24 = img.copyResize(
      networkImage,
      width: imgSize ~/ 2,
      height: imgSize ~/ 2,
      interpolation: img.Interpolation.average,
    );

    final img48x48 = img.Image(width: imgSize, height: imgSize, numChannels: 4);

    img.compositeImage(img48x48, img24x24, center: true, maskChannel: img.Channel.alpha);
    img.compositeImage(mask48x48, img48x48, dstX: 0, dstY: 0, maskChannel: img.Channel.alpha);

    return mask48x48;
  }

  Future<Marker> _getMarker(GeoPointWithElevationMessage point, User? user) async {
    if (user == null) {
      return Marker(
        id: 'ETA_MARKER_${DateTime.now().microsecondsSinceEpoch}',
        options: MarkerOptionsMessage(
          position: point,
          icon: SvgMarkerIcon(svgPath: 'packages/mapness/$_unauthorizedUser', width: 48),
          animatedAppearance: true,
          zIndex: 50,
        ),
      );
    } else if (user.photoUrl != null) {
      final pic = await processImage(user.photoUrl!);
      return Marker(
        id: 'ETA_MARKER_${DateTime.now().microsecondsSinceEpoch}',
        options: MarkerOptionsMessage(
          position: point,
          icon: PngBytesMarkerIcon(pngData: img.encodePng(pic), width: 48),
          animatedAppearance: true,
          zIndex: 50,
        ),
      );
      // TODO: Here Add marker with text
    } else {
      return Marker(
        id: 'ETA_MARKER_${DateTime.now().microsecondsSinceEpoch}',
        options: MarkerOptionsMessage(
          position: point,
          icon: SvgMarkerIcon(svgPath: 'packages/mapness/$_autharizedUser', width: 48),
          animatedAppearance: true,
          zIndex: 50,
        ),
      );
    }
  }

  Future<Marker> _getUnavailableMarker(GeoPointWithElevationMessage point, User? user) async {
    if (user == null) {
      return Marker(
        id: 'ETA_MARKER_${DateTime.now().microsecondsSinceEpoch}',
        options: MarkerOptionsMessage(
          position: point,
          icon: SvgMarkerIcon(svgPath: 'packages/mapness/$_lostConnection', width: 48),
          animatedAppearance: true,
          zIndex: 50,
        ),
      );
    } else if (user.photoUrl != null) {
      final pic = await processImage(user.photoUrl!, isUnavailable: true);
      return Marker(
        id: 'ETA_MARKER_${DateTime.now().microsecondsSinceEpoch}',
        options: MarkerOptionsMessage(
          position: point,
          icon: PngBytesMarkerIcon(pngData: img.encodePng(pic), width: 48),
          animatedAppearance: true,
          zIndex: 50,
        ),
      );
      // TODO: Here Add marker with text
    } else {
      return Marker(
        id: 'ETA_MARKER_${DateTime.now().microsecondsSinceEpoch}',
        options: MarkerOptionsMessage(
          position: point,
          icon: SvgMarkerIcon(svgPath: 'packages/mapness/$_lostConnection', width: 48),
          animatedAppearance: true,
          zIndex: 50,
        ),
      );
    }
  }

  Future<void> _onErrorStatus(int? statusCode, String? reason) async {
    final reasonData = reason?.toWebsocketReason();
    if (statusCode != null && statusCode != 1000) {
      await _processDrawUserMarker(isAvailable: false);
    } else if (statusCode == null) {
      await _processDrawUserMarker();
    }
    if (statusCode != 1000 && statusCode != 1013 && statusCode != null) {
      try {
        if (_reconnectingInProgress) {
          return;
        }
        _reconnectingInProgress = true;
        await EtaWebsocket().reconnect();
        ref.read(websocketErrorHandlerProvider.notifier).setStatus(null, null);
      } catch (e) {
        await stopStreaming();
      } finally {
        _reconnectingInProgress = false;
      }
    } else if (statusCode == 1000 && [WebsocketReason.expired, WebsocketReason.manual].contains(reasonData)) {
      await stopStreaming();
    }
  }
}
