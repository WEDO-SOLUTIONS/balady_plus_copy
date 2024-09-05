import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:mapness/_features/common/providers/network_status.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/features/share_eta/entities/route_params_point_mapper.dart';
import 'package:mapness/features/share_eta/entities/route_type_mapper.dart';
import 'package:mapness/features/share_eta/models/eta_info_model.dart';
import 'package:mapness/features/share_eta/models/eta_route_info.dart';
import 'package:mapness/features/share_eta/models/ws_config.dart';
import 'package:mapness/features/share_eta/providers/eta_websocket_locator.dart';
import 'package:mapness/features/share_eta/providers/websocker_error_handler_porvider.dart';
import 'package:mapness/features/share_eta/providers/websocket_type_provider.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_watching_sheet.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'eta_geo_subscriber.g.dart';

@riverpod
class EtaGeoSubscriber extends _$EtaGeoSubscriber {
  static const String _unauthorizedUser = 'assets/images_svg/eta_unknown_user_marker.svg';
  static const String _autharizedUser = 'assets/images_svg/eta_auth_blank_user_marker.svg';
  static const String _lostConnection = 'assets/images_svg/eta_lost_connection_marker.svg';

  static const imgSize = 48;
  static const streamBreakTimeout = 60;

  EtaInfoModel<EtaRoutePayload?>? _metaInfo;

  bool _reconnectingInProgress = false;
  bool _isFirstLocationFetch = true;
  bool _lastConnectionStatus = true;
  EtaRoute? _lastActiveRoute;
  Timer? _routeZoomingTimer;
  Timer? _lastActiveMessageReceiverTimer;

  DateTime? _lastActiveMessageTime;

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
      ..listen(networkStatusProvider, (_, current) async {
        if (current == _lastConnectionStatus) {
          return;
        }
        _lastConnectionStatus = current;
        final status = current;
        if (!status) {
          ref.read(websocketErrorHandlerProvider.notifier).setStatus(4001, 'Network status: $status');
        }
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

      _isFirstLocationFetch = false;

      _lastActiveMessageTime = DateTime.now().toUtc();

      // We need to wait some time, because current location need to initialize
      unawaited(
        Future.delayed(const Duration(seconds: 5), () async {
          await _processMoveCameraToUser();
        }),
      );
    } else if (etaInfo.type == EtaType.streamMetadata) {
      _metaInfo = etaInfo as EtaInfoModel<EtaRoutePayload?>;

      final route = _metaInfo?.payload?.route;

      if (route == null || route.isEmpty) {
        return;
      }

      final startPoint = route.startPoint?.routePoint;
      final finishPoint = route.endPoint?.routePoint;
      final type = route.type?.toRouteSearchOptions;
      final activeIndex = route.routeIndex;

      if (startPoint == null || finishPoint == null || type == null || activeIndex == null) {
        return;
      }

      _addFinishPin(finishPoint);

      if (_lastActiveRoute == route) {
        return;
      }

      _lastActiveRoute = route;

      ref.listen(
          routesProvider(
            startPoint: startPoint,
            finishPoint: finishPoint,
            navType: type,
            showOnlyActiveRoute: true,
          ), (_, current) async {
        if (current.valueOrNull?.isEmpty ?? false) {
          return;
        } else {
          await ref.read(dgisControllerProvider).value?.moveCameraToActiveRoute(activeIndex);
        }
      });
    }
  }

  Future<void> stopStreaming() async {
    try {
      EtaWebsocket().clearInfoListeners();
      await EtaWebsocket().stop();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _lastActiveRoute = null;

      // Stop active timers
      _routeZoomingTimer?.cancel();
      _routeZoomingTimer = null;

      _lastActiveMessageReceiverTimer?.cancel();
      _lastActiveMessageReceiverTimer = null;

      final settings = MapObjectManagerSettings.eta();
      final mapObjectManager = ref.read(
        mapObjectManagerProvider(
          named: settings.name,
          layerId: settings.layerId,
        ).notifier,
      );
      unawaited(mapObjectManager.removeAllMarkers());
      // hide routes
      final dgisController = ref.read(dgisControllerProvider);
      unawaited(dgisController.valueOrNull?.hideRoutes());

      _removeFinishPin();
    }
  }

  Future<void> startStreaming(String tokenId, String streamId) async {
    // Stop previous stream
    await stopStreaming();

    _isFirstLocationFetch = true;
    _lastConnectionStatus = true;
    _reconnectingInProgress = false;
    final envProvider = await ref.read(dgisEnvironmentProvider.future);

    try {
      await EtaWebsocket().start(
        streamId: streamId,
        token: tokenId,
        shareEtaApiUrl: envProvider.shareEtaApi,
      );
      ref.read(websocketErrorHandlerProvider.notifier).setStatus(null, null);

      EtaWebsocket().addEtaInfoListener(_updateEtaInfo);
      _routeZoomingTimer?.cancel();
      _routeZoomingTimer = Timer.periodic(const Duration(seconds: 15), (_) async {
        final (_, meta) = state;
        if (meta == null) {
          return;
        }
        final payload = meta.payload;
        if (payload?.route?.routeIndex != null) {
          final index = payload!.route!.routeIndex!;
          await ref.read(dgisControllerProvider).value?.moveCameraToActiveRoute(index);
        }
      });

      _lastActiveMessageReceiverTimer?.cancel();
      _lastActiveMessageReceiverTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
        final lastActiveMessageTime = _lastActiveMessageTime;
        if (lastActiveMessageTime == null) {
          return;
        }
        final currentTime = DateTime.now().toUtc();
        final diff = currentTime.difference(lastActiveMessageTime).inSeconds;
        if (diff > streamBreakTimeout) {
          ref.read(websocketErrorHandlerProvider.notifier).setStatus(1000, WebsocketReason.noData.toName());
          await stopStreaming();
        }
      });
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
        onTap: () => _showStopWatchingSheet(rootNavigatorKey.currentContext!),
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
        onTap: () => _showStopWatchingSheet(rootNavigatorKey.currentContext!),
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
        onTap: () => _showStopWatchingSheet(rootNavigatorKey.currentContext!),
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
        onTap: () => _showStopWatchingSheet(rootNavigatorKey.currentContext!),
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
        onTap: () => _showStopWatchingSheet(rootNavigatorKey.currentContext!),
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
        onTap: () => _showStopWatchingSheet(rootNavigatorKey.currentContext!),
        options: MarkerOptionsMessage(
          position: point,
          icon: SvgMarkerIcon(svgPath: 'packages/mapness/$_lostConnection', width: 48),
          animatedAppearance: true,
          zIndex: 50,
        ),
      );
    }
  }

  void _showStopWatchingSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => Consumer(
        builder: (context, ref, _) => EtaWatchingSheet(
          onStopWatchingPressed: () {
            stopStreaming();
            context.pop();
            // Extra close call for close the bottom sheet
            if (_metaInfo?.payload?.type == StreamType.eta) {
              context.pop();
            }
          },
        ),
      ),
    );
  }

  Future<void> _onErrorStatus(int? statusCode, String? reason) async {
    final reasonData = reason?.toWebsocketReason();
    final shareType = ref.read(websocketTypeProvider);
    if (shareType == SubscriptionType.get) {
      if (statusCode != null && statusCode != 1000) {
        await _processDrawUserMarker(isAvailable: false);
      } else if (statusCode == null) {
        await _processDrawUserMarker();
      }
    }
    if (statusCode != 1000 && statusCode != 1013 && statusCode != null && statusCode != 4002) {
      try {
        if (_reconnectingInProgress) {
          return;
        }
        _reconnectingInProgress = true;
        await EtaWebsocket().reconnect();
        _lastConnectionStatus = true;
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

  void _removeFinishPin() {
    final settings = MapObjectManagerSettings.selectedMarker();
    ref
        .read(
          mapObjectManagerProvider(
            named: settings.name,
            layerId: settings.layerId,
          ).notifier,
        )
        .removeAllMarkers();
  }

  void _addFinishPin(RouteParamsPoint finishPoint) {
    final settings = MapObjectManagerSettings.selectedMarker();
    final marker = Markers.pinMarker(
      GeoPointWithElevationMessage(
        latitude: finishPoint.latitude,
        longitude: finishPoint.longitude,
        elevation: 1,
      ),
    );
    ref
        .read(
          mapObjectManagerProvider(
            named: settings.name,
            layerId: settings.layerId,
          ).notifier,
        )
        .addMarker(marker);
  }
}
