import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:mapness/_features/common/providers/network_status.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/features/share_eta/entities/route_params_point_mapper.dart';
import 'package:mapness/features/share_eta/entities/route_type_mapper.dart';
import 'package:mapness/features/share_eta/helpers/constants.dart';
import 'package:mapness/features/share_eta/helpers/utils.dart';
import 'package:mapness/features/share_eta/models/eta_info_model.dart';
import 'package:mapness/features/share_eta/models/eta_route_info.dart';
import 'package:mapness/features/share_eta/models/ws_config.dart';
import 'package:mapness/features/share_eta/providers/eta_websocket_locator.dart';
import 'package:mapness/features/share_eta/providers/websocker_error_handler_porvider.dart';
import 'package:mapness/features/share_eta/providers/websocket_type_provider.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_watching_sheet.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'eta_geo_subscriber.g.dart';

@riverpod
class EtaGeoSubscriber extends _$EtaGeoSubscriber {
  static final String _unauthorizedUser = Assets.imagesSvg.etaUnknownUserMarker.keyName;
  static final String _autharizedUser = Assets.imagesSvg.etaAuthBlankUserMarker.keyName;
  static final String _lostConnection = Assets.imagesSvg.etaLostConnectionMarker.keyName;

  static const imgSize = 48;
  static const streamBreakTimeout = 30;
  static const streamBreakTimerInterval = 5;
  static const routeZoomTimerInterval = 10;

  EtaInfoModel<EtaRoutePayload?>? _metaInfo;

  bool _reconnectingInProgress = false;
  bool _isFirstLocationFetch = true;
  bool _lastConnectionStatus = true;
  bool _isRoutePresent = false;
  bool _isStreamStopped = false;
  Timer? _routeZoomingTimer;
  Timer? _lastActiveMessageReceiverTimer;

  DateTime? _lastActiveMessageTime;
  ProviderSubscription<AsyncValue<List<RouteInfo>>>? _routeSubscription;

  @override
  (EtaInfoModel<dynamic>?, EtaInfoModel<EtaRoutePayload?>?) build() {
    final settings = MapObjectManagerSettings.eta();

    ref
      ..watch(mapObjectManagerProvider(named: settings.name, layerId: settings.layerId))
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
          ref
              .read(websocketErrorHandlerProvider.notifier)
              .setStatus(EtaErrorStatusCodes.connectionLost, 'Network status: $status');
        }
      });

    return (null, null);
  }

  Future<void> _updateEtaInfo(EtaInfoModel etaInfo) async {
    try {
      final _etaInfo = etaInfo.type == EtaType.geolocation ? etaInfo : null;
      state = (_etaInfo, _metaInfo);

      if (etaInfo.type == EtaType.geolocation) {
        await _processDrawUserMarker();

        detach(_processMoveCameraToUser(), tag: 'etaGeoSubscriber.processMoveCameraToUser');

        _lastActiveMessageTime = DateTime.now().toUtc();
      } else if (etaInfo.type == EtaType.streamMetadata) {
        _isRoutePresent = false;
        _metaInfo = etaInfo as EtaInfoModel<EtaRoutePayload?>;

        await _createUserRoute();
      }
    } catch (e) {
      logger.log(e.toString(), logLevel: MapnessLogLevel.critical);
    }
  }

  Future<void> stopStreaming() async {
    _isStreamStopped = true;
    try {
      EtaWebsocket().clearInfoListeners();
      await EtaWebsocket().stop();
    } catch (e) {
      logger.log(e.toString(), logLevel: MapnessLogLevel.critical);
    } finally {
      // Stop active timers
      _routeZoomingTimer?.cancel();
      _routeZoomingTimer = null;

      _lastActiveMessageReceiverTimer?.cancel();
      _lastActiveMessageReceiverTimer = null;
      _lastActiveMessageTime = null;
      _routeSubscription?.close();
      _routeSubscription = null;

      _isRoutePresent = false;

      final settings = MapObjectManagerSettings.eta();
      final mapObjectManager = ref.read(
        mapObjectManagerProvider(named: settings.name, layerId: settings.layerId).notifier,
      );
      detach(mapObjectManager.removeAllMarkers(), tag: 'etaGeoSubscriber.removeAllMarkers');
      // hide routes
      final dgisController = ref.read(dgisControllerProvider);
      detach(dgisController.value?.hideRoutes(), tag: 'etaGeoSubscriber.hideRoutes');

      _removeFinishPin();
    }
  }

  Future<void> startStreaming(String tokenId, String streamId) async {
    // Stop previous stream
    await stopStreaming();

    _isStreamStopped = false;

    _isFirstLocationFetch = true;
    _lastConnectionStatus = true;
    _reconnectingInProgress = false;
    final envProvider = await ref.read(dgisEnvironmentProvider.future);

    try {
      await EtaWebsocket().start(streamId: streamId, token: tokenId, shareEtaApiUrl: envProvider.shareEtaApi);
      ref.read(websocketErrorHandlerProvider.notifier).setStatus(null, null);

      _routeZoomingTimer?.cancel();
      _routeZoomingTimer = Timer.periodic(const Duration(seconds: routeZoomTimerInterval), (_) async {
        final (_, meta) = state;
        if (meta == null) {
          return;
        }
        final payload = meta.payload;

        if (payload?.route?.routeIndex != null && _isRoutePresent) {
          final index = payload!.route!.routeIndex!;
          final dgisController = ref.read(dgisControllerProvider).value;
          if (dgisController != null) {
            // Set the active route index first, then move camera to it
            await dgisController.setActiveRouteIndex(index);
            await dgisController.moveCameraToActiveRoute(index);
          }
        }
      });

      _lastActiveMessageReceiverTimer?.cancel();
      _lastActiveMessageReceiverTimer = Timer.periodic(const Duration(seconds: streamBreakTimerInterval), (_) async {
        final lastActiveMessageTime = _lastActiveMessageTime;
        if (lastActiveMessageTime == null) {
          return;
        }
        final currentTime = DateTime.now().toUtc();
        final diff = currentTime.difference(lastActiveMessageTime).inSeconds;
        // We need to set status only if we have no data in stream
        if (diff > streamBreakTimeout) {
          ref
              .read(websocketErrorHandlerProvider.notifier)
              .setStatus(EtaErrorStatusCodes.noDataInStream, WebsocketReason.noData.toName());

          // Return normal status if we get data after no data status
        } else if (ref.read(websocketErrorHandlerProvider).$1 == EtaErrorStatusCodes.noDataInStream) {
          ref.read(websocketErrorHandlerProvider.notifier).setStatus(null, null);
        }
      });

      EtaWebsocket().addEtaInfoListener(_updateEtaInfo);
    } catch (e) {
      await stopStreaming();
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
          GeoPointWithElevationMessage(latitude: payload.lat!, longitude: payload.lon!, elevation: 0),
          _metaInfo?.payload?.user,
        );
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _processDrawUnavailableMarker(
          GeoPointWithElevationMessage(latitude: payload.lat!, longitude: payload.lon!, elevation: 0),
          _metaInfo?.payload?.user,
        );
      });
    }
  }

  Future<void> _processMoveCameraToUser() async {
    ProviderSubscription? locationProviderSubscription;

    if (!_isFirstLocationFetch) {
      return;
    }

    final Completer _locationCompleter = Completer();

    locationProviderSubscription = ref.listen(locationProvider, (_, __) {
      if (!_locationCompleter.isCompleted) {
        _locationCompleter.complete();
      }

      locationProviderSubscription?.close();
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!_locationCompleter.isCompleted) {
        _locationCompleter.complete();
      }
    });

    await _locationCompleter.future;

    _isFirstLocationFetch = false;

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
      try {
        await ref
            .read(cameraPositionProvider.notifier)
            .animateTo(
              CameraPositionMessage(
                point: GeoPointMessage(latitude: payload.lat!, longitude: payload.lon!),
                zoom: 17,
                tilt: 0,
                bearing: 0,
              ),
            );
      } catch (e) {
        logger.log(e.toString(), logLevel: MapnessLogLevel.critical);
      }
    });
  }

  Future<void> _createUserRoute() async {
    ProviderSubscription? locationProviderSubscription;

    final _locationCompleter = Completer();

    locationProviderSubscription = ref.listen(locationProvider, (_, __) {
      if (!_locationCompleter.isCompleted) {
        _locationCompleter.complete();
      }

      locationProviderSubscription?.close();
    });
    final currentLocation = ref.read(locationProvider);
    if (currentLocation != null) {
      _locationCompleter.complete();
    }

    Future.delayed(const Duration(seconds: 10), () {
      if (!_locationCompleter.isCompleted) {
        _locationCompleter.complete();
      }
    });

    // Wait for location to be available
    await _locationCompleter.future;

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

    _routeSubscription?.close();
    _routeSubscription = ref.listen(
      routesProvider(startPoint: startPoint, finishPoint: finishPoint, navType: type, showOnlyActiveRoute: true),
      (_, current) async {
        if (current.value?.isEmpty ?? false) {
          _isRoutePresent = false;
          return;
        } else {
          _isRoutePresent = true;
          final dgisController = ref.read(dgisControllerProvider).value;
          if (dgisController != null) {
            // Set the active route index first, then move camera to it
            // activeIndex is guaranteed to be non-null due to check above
            await dgisController.setActiveRouteIndex(activeIndex);
            await dgisController.moveCameraToActiveRoute(activeIndex);
          }
        }
      },
    );
  }

  Future<void> _processDrawMarker(GeoPointWithElevationMessage point, User? user) async {
    final settings = MapObjectManagerSettings.eta();
    final mapObjectManager = ref.read(
      mapObjectManagerProvider(named: settings.name, layerId: settings.layerId).notifier,
    );

    final marker = await _getMarker(point, user);

    await mapObjectManager.removeAllMarkers();
    await mapObjectManager.addMarker(marker);
  }

  Future<void> _processDrawUnavailableMarker(GeoPointWithElevationMessage point, User? user) async {
    final settings = MapObjectManagerSettings.eta();
    final mapObjectManager = ref.read(
      mapObjectManagerProvider(named: settings.name, layerId: settings.layerId).notifier,
    );

    final marker = await _getUnavailableMarker(point, user);

    await mapObjectManager.removeAllMarkers();
    await mapObjectManager.addMarker(marker);
  }

  Future<Marker> _getMarker(GeoPointWithElevationMessage point, User? user) async {
    if (user == null) {
      return Marker(
        id: 'ETA_MARKER_${DateTime.now().microsecondsSinceEpoch}',
        onTap: () => _showStopWatchingSheet(rootNavigatorKey.currentContext!),
        options: MarkerOptionsMessage(
          position: point,
          icon: SvgMarkerIcon(svgPath: _unauthorizedUser, width: 48),
          animatedAppearance: true,
          zIndex: 50,
        ),
      );
    } else if (user.photoUrl != null) {
      final pic = await EtaUtils.processImage(user.photoUrl!, imgSize);
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
          icon: SvgMarkerIcon(svgPath: _autharizedUser, width: 48),
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
          icon: SvgMarkerIcon(svgPath: _lostConnection, width: 48),
          animatedAppearance: true,
          zIndex: 50,
        ),
      );
    } else if (user.photoUrl != null) {
      final pic = await EtaUtils.processImage(user.photoUrl!, imgSize, isUnavailable: true);
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
        builder: (_, ref, __) => EtaWatchingSheet(
          onStopWatchingPressed: () async {
            // Extra close call for close the bottom sheet
            Navigator.pop(context);
            await stopStreaming();

            if (_metaInfo?.payload?.type == StreamType.eta) {
              await context.router.navigate(const LandingRoute());
            }
          },
        ),
      ),
    );
  }

  Future<void> _onErrorStatus(int? statusCode, String? reason) async {
    final reasonData = reason?.toWebsocketReason();
    final shareType = ref.read(websocketTypeProvider);
    if (shareType == SubscriptionType.get && !_isStreamStopped) {
      if (statusCode != null && statusCode != EtaErrorStatusCodes.endConnection) {
        await _processDrawUserMarker(isAvailable: false);
      } else if (statusCode == null) {
        await _processDrawUserMarker();
      }
    }
    if (statusCode != EtaErrorStatusCodes.endConnection &&
        statusCode != EtaErrorStatusCodes.hightLoad &&
        statusCode != null &&
        statusCode != EtaErrorStatusCodes.noLocation &&
        statusCode != EtaErrorStatusCodes.noDataInStream) {
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
    } else if (statusCode == EtaErrorStatusCodes.endConnection &&
        [WebsocketReason.expired, WebsocketReason.manual].contains(reasonData)) {
      await stopStreaming();
    } else if (statusCode == EtaErrorStatusCodes.hightLoad) {
      await stopStreaming();
    }
  }

  void _removeFinishPin() {
    final settings = MapObjectManagerSettings.selectedMarker();
    ref.read(mapObjectManagerProvider(named: settings.name, layerId: settings.layerId).notifier).removeAllMarkers();
  }

  void _addFinishPin(RouteParamsPoint finishPoint) {
    final settings = MapObjectManagerSettings.selectedMarker();
    final isDark = ref.read(darkModeProvider).value?.isDark ?? false;

    final marker = Markers.pinMarker(
      GeoPointWithElevationMessage(latitude: finishPoint.latitude, longitude: finishPoint.longitude, elevation: 1),
      activeCityEvent: ref.read(activeCityEventProvider),
      isDark: isDark,
    );
    ref.read(mapObjectManagerProvider(named: settings.name, layerId: settings.layerId).notifier).addMarker(marker);
  }
}
