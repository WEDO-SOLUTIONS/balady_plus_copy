import 'dart:async';

import 'package:balady_plus/app/core/utils/common_functions.dart' as balady_utils;
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mapness/_features/common/providers/network_status.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/entities/path_nav/models/path_nav_message_state.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/features/path_nav/providers/path_nav_message.dart';
import 'package:mapness/features/share_eta/helpers/constants.dart';
import 'package:mapness/features/share_eta/models/eta_info_model.dart';
import 'package:mapness/features/share_eta/models/eta_route_info.dart';
import 'package:mapness/features/share_eta/models/eta_stream_payload.dart';
import 'package:mapness/features/share_eta/models/ws_config.dart';
import 'package:mapness/features/share_eta/providers/eta_route_info_provider.dart';
import 'package:mapness/features/share_eta/providers/eta_service_provider.dart';
import 'package:mapness/features/share_eta/providers/eta_stream_storage.dart';
import 'package:mapness/features/share_eta/providers/eta_timer_indicator.dart';
import 'package:mapness/features/share_eta/providers/eta_websocket_locator.dart';
import 'package:mapness/features/share_eta/providers/eta_websocket_status_provider.dart';
import 'package:mapness/features/share_eta/providers/websocker_error_handler_porvider.dart';
import 'package:mapness/features/share_eta/providers/websocket_type_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/string_ext.dart';
import 'package:mapness/shared/lib/deeplink_functions.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'share_eta_provider.g.dart';

@riverpod
class ShareEta extends _$ShareEta {
  static const int sendLocationIntervalSeconds = 1;

  ProviderSubscription? _websocketStatusSubscription;
  Timer? _locationSubscription;
  bool _reconnectingInProgress = false;
  bool _lastConnectionStatus = true;
  bool _isSharingSession = false;
  bool _shareLinkPresented = false;
  bool _stopSharingInProgress = false;
  DateTime? _sharingStartedAt;

  EtaStreamType _streamType = EtaStreamType.geo;

  @override
  EtaStreamType build() {
    _websocketStatusSubscription?.close();
    _websocketStatusSubscription = ref.listen<bool>(etaWebsocketStatusProvider, (_, status) {
      _locationSubscription?.cancel();

      final isSharingType = ref.read(websocketTypeProvider) == SubscriptionType.share;

      if (status && isSharingType) {
        final durationInMinutes = EtaStreamStorage().state.durationInMinutes;

        if (durationInMinutes != null) {
          _sharingStartedAt ??= DateTime.now();
          ref.read(etaTimerIndicatorProvider.notifier).startTimer(_remainingMinutes(durationInMinutes));
        }

        final state = EtaStreamStorage().state;

        if (state.streamId == null || state.streamToken == null) {
          return;
        }

        if (_streamType == EtaStreamType.geo) {
          if (durationInMinutes == null) {
            return;
          }
          if (!_shareLinkPresented) {
            _shareLinkPresented = true;
            _shareLiveLocationDialog(state.streamToken!, state.streamId!, durationInMinutes);
          }
        } else if (_streamType == EtaStreamType.eta) {
          final eta = ref.read(pathNavEtaProvider);
          if (eta == null) {
            return;
          }

          if (!_shareLinkPresented) {
            _shareLinkPresented = true;
            final DateFormat formatter = DateFormat('HH:mm');
            final arrivalDate = DateTime.now().add(Duration(seconds: eta.durationInSeconds));
            _shareEtaDialog(state.streamToken!, state.streamId!, formatter.format(arrivalDate));
          }
        }

        _locationSubscription = Timer.periodic(const Duration(seconds: sendLocationIntervalSeconds), (_) async {
          final location = ref.read(locationProvider);
          final eta = ref.read(pathNavEtaProvider);

          final arrivalAt = DateTime.now().toUtc().add(Duration(seconds: eta?.durationInSeconds ?? 0));
          final distance = eta?.rawDistance ?? 0;
          final isGranded = await ref.read(locationProvider.notifier).checkLocationStatus();

          if (location != null && isGranded) {
            // If location is back after lost, remove the error status
            if (ref.read(websocketErrorHandlerProvider).$1 == EtaErrorStatusCodes.noLocation) {
              ref.read(websocketErrorHandlerProvider.notifier).setStatus(null, null);
            }

            int heading = location.heading.toInt();

            if (heading < 0) {
              heading = 0;
            } else if (heading > 360) {
              heading = 360;
            }

            try {
              await EtaWebsocket().pushEtaInfo(
                EtaInfoModel<EtaInfoPayload>(
                  type: EtaType.geolocation,
                  payload: EtaInfoPayload(
                    period: sendLocationIntervalSeconds * 1000,
                    // in ms
                    direction: heading,
                    speed: location.speed,
                    lat: location.latitude,
                    lon: location.longitude,
                    eta: _streamType == EtaStreamType.eta
                        ? Eta(arrivalAt: arrivalAt.toIso8601String(), distance: distance.toInt())
                        : null,
                  ),
                ),
              );
            } catch (e) {
              logger.log(e.toString(), logLevel: MapnessLogLevel.critical);
            }
          } else {
            // If location lost, set error status to 4002
            ref.read(websocketErrorHandlerProvider.notifier).setStatus(EtaErrorStatusCodes.noLocation, 'Lost location');
          }
        });
      } else if (!_isSharingSession && ref.read(websocketTypeProvider) == SubscriptionType.share) {
        ref.read(websocketTypeProvider.notifier).setType();
      }
    });

    ref
      ..listen(websocketErrorHandlerProvider, (_, current) async {
        final (code, reason) = current;
        if (code != null) {
          await _onErrorStatus(code, reason ?? '');
        }
      })
      ..listen(etaRouteInfoProvider, (_, current) {
        final etaStatus = ref.read(etaWebsocketStatusProvider);
        final isSharingType = ref.read(websocketTypeProvider) == SubscriptionType.share;
        if (etaStatus && isSharingType && _streamType == EtaStreamType.eta) {
          _updateRoute(current);
        }
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
      })
      ..listen(pathNavMessageProvider, (prev, current) {
        if (prev?.state == PathNavMessageState.reroute && current?.state == null) {
          final route = ref.read(etaRouteInfoProvider);
          final location = ref.read(locationProvider);
          if (route.isEmpty) {
            return;
          }

          if (location != null) {
            ref
                .read(etaRouteInfoProvider.notifier)
                .setRoute(
                  route.copyWith(
                    routeIndex: 0,
                    startPoint: EtaRoutePoint(lat: location.latitude, lon: location.longitude),
                    createdAt: DateTime.now().toUtc().toIso8601String(),
                  ),
                );
          }
        }
      })
      ..listen(etaServiceProvider, (_, next) {
        if (!next.hasValue || next.isLoading || next.hasError || next.value == null) {
          return;
        }
        final streamId = next.value!.streamId;
        final streamToken = next.value!.streamToken;

        final xStreamData = next.value!.xStreamData;

        if (streamId == null || streamToken == null || xStreamData == null) {
          return;
        }

        EtaStreamStorage()
          ..setStreamId(streamId)
          ..setToken(streamToken)
          ..setXStreamData(xStreamData);

        final finishAt = next.value!.finishesAt;
        if (finishAt != null) {
          final estimatedTime = finishAt.dateTime;
          if (estimatedTime != null) {
            EtaStreamStorage().setEstimatedTime(estimatedTime);
          }
        }

        startWebsocketStream(streamId, streamToken, xStreamData);
      })
      ..onDispose(() {
        stopSharingAndClearCurrent();

        _websocketStatusSubscription?.close();
        _locationSubscription?.cancel();
      });

    return _streamType;
  }

  Future<void> _onErrorStatus(int statusCode, String reason) async {
    final reasonData = reason.toWebsocketReason();
    if (statusCode != EtaErrorStatusCodes.endConnection &&
        statusCode != EtaErrorStatusCodes.hightLoad &&
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
        await stopSharing();
      } finally {
        _reconnectingInProgress = false;
      }
    } else if (statusCode == EtaErrorStatusCodes.endConnection) {
      logger.log(
        'ETA stream closed by the server. Reason: ${reasonData?.toName() ?? reason}',
        logLevel: MapnessLogLevel.info,
      );
      if (_isSharingSession || ref.read(websocketTypeProvider) == SubscriptionType.share) {
        await stopSharing();
      }
    }
  }

  int _remainingMinutes(int durationInMinutes) {
    final startedAt = _sharingStartedAt;
    if (startedAt == null) {
      return durationInMinutes;
    }

    final leftInSeconds = durationInMinutes * 60 - DateTime.now().difference(startedAt).inSeconds;
    if (leftInSeconds <= 0) {
      return 0;
    }

    return (leftInSeconds / 60).ceil();
  }

  void shareIfExistingStream([int? durationInMinutes]) {
    final existingToken = EtaStreamStorage().state.streamToken;
    final existingStreamId = EtaStreamStorage().state.streamId;
    if (existingToken != null && existingStreamId != null) {
      if (durationInMinutes == null) {
        shareCurrentStream(EtaStreamType.eta);
      } else {
        _shareLiveLocationDialog(existingToken, existingStreamId, durationInMinutes);
      }
      return;
    }
  }

  Future<void> startSharingLiveLocation(int durationInMinutes) async {
    shareIfExistingStream(durationInMinutes);
    try {
      final etaService = ref.read(etaServiceProvider.notifier);
      state = _streamType = EtaStreamType.geo;

      _startSharingSession();

      final payload = EtaStreamPayload(type: EtaStreamType.geo.name, durationMinutes: durationInMinutes);

      //store the duration in the storage
      EtaStreamStorage().setDurationInMinutes(durationInMinutes);
      await etaService.startEtaStream(payload);
    } catch (e) {
      logger.log(e.toString(), logLevel: MapnessLogLevel.critical);
    } finally {
      ref.read(websocketTypeProvider.notifier).setType(type: SubscriptionType.share);
    }
  }

  Future<void> startSharingEta() async {
    try {
      final etaService = ref.read(etaServiceProvider.notifier);

      state = _streamType = EtaStreamType.eta;
      final etaRoute = ref.read(etaRouteInfoProvider);

      _startSharingSession();

      _lastConnectionStatus = true;
      _reconnectingInProgress = false;

      final payload = EtaStreamPayload(
        type: EtaStreamType.eta.name,
        metadata: etaRoute.isEmpty ? null : EtaRoutePayload(route: etaRoute),
      );

      await etaService.startEtaStream(payload);
    } catch (e) {
      logger.log(e.toString(), logLevel: MapnessLogLevel.critical);
    } finally {
      ref.read(websocketTypeProvider.notifier).setType(type: SubscriptionType.share);
    }
  }

  Future<void> _updateRoute(EtaRoute route) async {
    final tokenId = EtaStreamStorage().state.streamToken;
    final xStreamData = EtaStreamStorage().state.xStreamData;

    if (tokenId != null && xStreamData != null) {
      await ref
          .read(etaServiceProvider.notifier)
          .updateEtaStream(
            EtaRouteMetadataPayload(route: route),
            xStreamData: xStreamData,
            tokenId: tokenId,
          );
    }
  }

  Future<void> stopSharingAndClearCurrent() => stopSharing(clearStateStorage: true);

  void _startSharingSession() {
    _isSharingSession = true;
    _shareLinkPresented = false;
    _sharingStartedAt = null;
  }

  Future<void> stopSharing({bool clearStateStorage = false}) async {
    if (_stopSharingInProgress) {
      if (clearStateStorage) {
        EtaStreamStorage().clear();
      }
      return;
    }

    _stopSharingInProgress = true;
    try {
      await _stopSharing(clearStateStorage: clearStateStorage);
    } finally {
      _stopSharingInProgress = false;
    }
  }

  Future<void> _stopSharing({required bool clearStateStorage}) async {
    _isSharingSession = false;
    _shareLinkPresented = false;
    _sharingStartedAt = null;

    _locationSubscription?.cancel();
    _locationSubscription = null;

    if (ref.mounted) {
      ref.read(etaTimerIndicatorProvider.notifier).stopTimer();
    }

    final tokenId = EtaStreamStorage().state.streamToken;
    final xStreamData = EtaStreamStorage().state.xStreamData;

    if (tokenId == null || xStreamData == null) {
      return;
    }

    final etaService = ref.read(etaServiceProvider.notifier);

    try {
      await EtaWebsocket().stop();
      await etaService.stopEtaStream(tokenId, xStreamData);
    } catch (e) {
      logger.log(e.toString(), logLevel: MapnessLogLevel.critical);
    } finally {
      EtaWebsocket().removeConnectionLostListener(_onErrorStatus);
      if (clearStateStorage) {
        EtaStreamStorage().clear();
      }
    }
  }

  Future<void> startWebsocketStream(String streamId, String token, String xStreamData) async {
    final envProvider = await ref.read(dgisEnvironmentProvider.future);

    try {
      await EtaWebsocket().start(
        streamId: streamId,
        token: token,
        shareEtaApiUrl: envProvider.shareEtaApi,
        xStreamData: xStreamData,
        subscriptionType: SubscriptionType.share,
      );
      ref.read(websocketErrorHandlerProvider.notifier).setStatus(null, null);
    } catch (e) {
      logger.log(e.toString(), logLevel: MapnessLogLevel.critical);
    } finally {
      ref.read(websocketTypeProvider.notifier).setType(type: SubscriptionType.share);
    }
  }

  void _shareLiveLocationDialog(String tokenId, String streamId, int durationInMinutes) {
    final query = <String, String>{};
    final context = rootNavigatorKey.currentContext;
    if (context == null) {
      return;
    }

    final baseUri = BaldayDeeplink.baseGeoSharingUri;
    query[BaldayDeeplink.tokenId] = tokenId;

    query[BaldayDeeplink.streamId] = streamId;
    query[BaldayDeeplink.latitudeKey] = EtaStreamStorage().state.latitude.toString();
    query[BaldayDeeplink.longitudeKey] = EtaStreamStorage().state.longitude.toString();
    query[BaldayDeeplink.typeKey] = 'live';

    final shareUrl = BaldayDeeplink.urlWithQuery(baseUri, query);

    final inHour = durationInMinutes ~/ 60;
    final inMinutes = durationInMinutes % 60;

    final duration = inHour > 0
        ? context.l10n.seeLiveLocationHrMin(inHour.toString(), inMinutes.toString())
        : context.l10n.seeLiveLocationMin(inMinutes.toString());

    balady_utils.safeShareText('$duration\n$shareUrl', context: context);
  }

  void shareCurrentStream(EtaStreamType type) {
    final tokenId = EtaStreamStorage().state.streamToken;
    final streamId = EtaStreamStorage().state.streamId;
    final duration = EtaStreamStorage().state.durationInMinutes;

    if (tokenId == null || streamId == null) {
      return;
    }

    if (type == EtaStreamType.geo) {
      if (duration != null) {
        _shareLiveLocationDialog(tokenId, streamId, duration);
      }
    } else if (type == EtaStreamType.eta) {
      final eta = ref.read(pathNavEtaProvider);
      if (eta != null) {
        final formatter = DateFormat('HH:mm');
        final arrivalDate = DateTime.now().add(Duration(seconds: eta.durationInSeconds));
        _shareEtaDialog(tokenId, streamId, formatter.format(arrivalDate));
      }
    }
  }

  Future<void> _shareEtaDialog(String tokenId, String streamId, String arrivalAt) async {
    final query = <String, String>{};
    final context = rootNavigatorKey.currentContext;
    if (context == null) {
      return;
    }

    final baseUri = BaldayDeeplink.baseGeoSharingUri;
    query[BaldayDeeplink.tokenId] = tokenId;

    query[BaldayDeeplink.streamId] = streamId;
    query[BaldayDeeplink.latitudeKey] = EtaStreamStorage().state.latitude.toString();
    query[BaldayDeeplink.longitudeKey] = EtaStreamStorage().state.longitude.toString();
    query[BaldayDeeplink.typeKey] = 'eta';

    final shareUrl = BaldayDeeplink.urlWithQuery(baseUri, query);

    if (EtaStreamStorage().state.latitude == null || EtaStreamStorage().state.longitude == null) {
      return;
    }

    final address = await _makeAddress(EtaStreamStorage().state.latitude!, EtaStreamStorage().state.longitude!);

    await balady_utils.safeShareText(
      context.l10n
          .iWillArriveAtTimeToDestinationLink(
            address ?? '',
            shareUrl,
            arrivalAt,
          )
          .multilines,
      context: context,
    );
  }

  Future<String?> _makeAddress(double latitude, double longitude) async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    String? address;
    try {
      final data = await dgisController.search('$latitude, $longitude', sortingType: SortingTypeMessage.byDistance);
      if (data.firstPage?.items.isNotEmpty == true) {
        address = data.firstPage?.items.first.makeAddress();
        address ??= '$latitude, $longitude';
      }
    } catch (_) {}
    return address;
  }
}
