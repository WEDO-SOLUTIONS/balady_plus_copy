import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mapness/_features/poi_card/extensions/directory_object_ext.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
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
import 'package:mapness/shared/lib/deeplink_functionds.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

part 'share_eta_provider.g.dart';

@riverpod
class ShareEta extends _$ShareEta {
  static const int sendLocationIntervalSeconds = 1;

  ProviderSubscription? _websocketStatusSubscription;
  Timer? _locationSubscription;
  bool _reconnectingInProgress = false;

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
          ref.read(etaTimerIndicatorProvider.notifier).startTimer(durationInMinutes);
        }

        final state = EtaStreamStorage().state;

        if (state.streamId == null || state.streamToken == null) {
          return;
        }

        if (_streamType == EtaStreamType.geo) {
          if (durationInMinutes == null) {
            return;
          }
          _shareLiveLocationDialog(
            state.streamToken!,
            state.streamId!,
            durationInMinutes,
          );
        } else if (_streamType == EtaStreamType.eta) {
          final eta = ref.read(pathNavEtaProvider);
          if (eta == null) {
            return;
          }

          final DateFormat formatter = DateFormat('HH:mm');
          final arrivalDate = DateTime.now().add(Duration(seconds: eta.durationInSeconds));
          _shareEtaDialog(
            state.streamToken!,
            state.streamId!,
            formatter.format(arrivalDate),
          );
        }

        _locationSubscription = Timer.periodic(const Duration(seconds: sendLocationIntervalSeconds), (_) {
          final location = ref.read(locationProvider);
          final eta = ref.read(pathNavEtaProvider);

          final arrivalAt = DateTime.now().toUtc().add(Duration(seconds: eta?.durationInSeconds ?? 0));
          final distance = eta?.rawDistance ?? 0;

          if (location != null) {
            try {
              EtaWebsocket().pushEtaInfo(
                EtaInfoModel<EtaInfoPayload>(
                  type: EtaType.geolocation,
                  payload: EtaInfoPayload(
                    period: sendLocationIntervalSeconds * 1000, // in ms
                    direction: location.heading.toInt(),
                    speed: location.speed,
                    lat: location.latitude,
                    lon: location.longitude,
                    eta: _streamType == EtaStreamType.eta
                        ? Eta(
                            arrivalAt: arrivalAt.toIso8601String(),
                            distance: distance.toInt(),
                          )
                        : null,
                  ),
                ),
              );
            } catch (e) {
              debugPrint(e.toString());
            }
          }
        });
      } else {
        ref.read(websocketTypeProvider.notifier).setType();
      }
    });

    ref
      ..listen(websocketErrorHandlerProvider, (_, current) async {
        final (code, reason) = current;
        if (code != null && reason != null) {
          await _onErrorStatus(code, reason);
        }
      })
      ..listen(etaRouteInfoProvider, (_, current) {
        final etaStatus = ref.read(etaWebsocketStatusProvider);
        final isSharingType = ref.read(websocketTypeProvider) == SubscriptionType.share;
        if (etaStatus && isSharingType && _streamType == EtaStreamType.eta) {
          // TODO: Update route info
        }
      })
      ..onDispose(() {
        _stopSharingCurrent();

        _websocketStatusSubscription?.close();
        _locationSubscription?.cancel();
      });

    return _streamType;
  }

  Future<void> _onErrorStatus(int statusCode, String reason) async {
    final reasonData = reason.toWebsocketReason();
    if (statusCode != 1000 && statusCode != 1013) {
      try {
        if (_reconnectingInProgress) {
          return;
        }
        _reconnectingInProgress = true;
        await EtaWebsocket().reconnect();
        ref.read(websocketErrorHandlerProvider.notifier).setStatus(null, null);
      } catch (e) {
        final tokenId = EtaStreamStorage().state.streamToken;
        final xStreamData = EtaStreamStorage().state.xStreamData;
        if (tokenId != null && xStreamData != null) {
          await stopSharing(tokenId, xStreamData);
        }
      } finally {
        _reconnectingInProgress = false;
      }
    } else if (statusCode == 1000 && [WebsocketReason.expired, WebsocketReason.manual].contains(reasonData)) {
      final tokenId = EtaStreamStorage().state.streamToken;
      final xStreamData = EtaStreamStorage().state.xStreamData;
      final isSharing = ref.read(websocketTypeProvider) == SubscriptionType.share;
      if (tokenId != null && xStreamData != null && isSharing) {
        await stopSharing(tokenId, xStreamData);
      }
    }
  }

  Future<void> startSharingLiveLocation(int durationInMinutes) async {
    try {
      final etaService = ref.read(etaServiceProvider.notifier);
      state = _streamType = EtaStreamType.geo;

      final payload = EtaStreamPayload(
        type: EtaStreamType.geo.name,
        durationMinutes: durationInMinutes,
      );

      //store the duration in the storage
      EtaStreamStorage().setDurationInMinutes(durationInMinutes);
      await etaService.startEtaStream(payload);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      ref.read(websocketTypeProvider.notifier).setType(type: SubscriptionType.share);
    }
  }

  Future<void> startSharingEta() async {
    try {
      final etaService = ref.read(etaServiceProvider.notifier);

      state = _streamType = EtaStreamType.eta;
      final etaRoute = ref.read(etaRouteInfoProvider);

      final payload = EtaStreamPayload(
        type: EtaStreamType.eta.name,
        metadata: etaRoute.isEmpty ? null : EtaRoutePayload(route: etaRoute),
      );

      await etaService.startEtaStream(payload);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      ref.read(websocketTypeProvider.notifier).setType(type: SubscriptionType.share);
    }
  }

  Future<void> _stopSharingCurrent() async {
    final tokenId = EtaStreamStorage().state.streamToken;
    final xStreamData = EtaStreamStorage().state.xStreamData;

    if (tokenId != null && xStreamData != null) {
      await stopSharing(tokenId, xStreamData);
      EtaStreamStorage().clear();
    }
  }

  Future<void> stopSharing(String tokenId, String xStreamData) async {
    final etaService = ref.read(etaServiceProvider.notifier);

    try {
      await EtaWebsocket().stop();
      await etaService.stopEtaStream(tokenId, xStreamData);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      ref.read(etaRouteInfoProvider.notifier).clear();
      EtaWebsocket().removeConnectionLostListener(_onErrorStatus);
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
      debugPrint(e.toString());
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

    final baseUri = BaldayDeeplink.basePoiUri;
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

    Share.share('$duration\n$shareUrl');
  }

  Future<void> _shareEtaDialog(String tokenId, String streamId, String arrivalAt) async {
    final query = <String, String>{};
    final context = rootNavigatorKey.currentContext;
    if (context == null) {
      return;
    }

    final baseUri = BaldayDeeplink.basePoiUri;
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

    await Share.share(context.l10n.iWillArriveAtTimeToDestinationLink(address ?? '', shareUrl, arrivalAt).multilines);
  }

  Future<String?> _makeAddress(double latitude, double longitude) async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    String? address;
    try {
      final data = await dgisController.search(
        '$latitude, $longitude',
        sortingType: SortingTypeMessage.byDistance,
      );
      if (data.firstPage?.items.isNotEmpty == true) {
        address = data.firstPage!.items.first?.makeAddress();
        address ??= '$latitude, $longitude';
      }
    } catch (_) {}
    return address;
  }
}
