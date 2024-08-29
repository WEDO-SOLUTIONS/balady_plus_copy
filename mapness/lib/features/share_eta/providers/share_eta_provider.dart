import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/features/share_eta/models/eta_info_model.dart';
import 'package:mapness/features/share_eta/models/eta_stream_payload.dart';
import 'package:mapness/features/share_eta/models/ws_config.dart';
import 'package:mapness/features/share_eta/providers/eta_service_provider.dart';
import 'package:mapness/features/share_eta/providers/eta_stream_storage.dart';
import 'package:mapness/features/share_eta/providers/eta_timer_indicator.dart';
import 'package:mapness/features/share_eta/providers/eta_websocket_locator.dart';
import 'package:mapness/features/share_eta/providers/websocket_status_provider.dart';
import 'package:mapness/features/share_eta/providers/websocket_type_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/deeplink_functionds.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

part 'share_eta_provider.g.dart';

@riverpod
class ShareEta extends _$ShareEta {
  static const int sendLocationIntervalSeconds = 3;

  ProviderSubscription? _websocketStatusSubscription;
  Timer? _locationSubscription;

  @override
  void build() {
    _websocketStatusSubscription?.close();
    _websocketStatusSubscription = ref.listen<bool>(websocketStatusProvider, (_, status) {
      _locationSubscription?.cancel();

      if (status && ref.read(websocketTypeProvider) == SubscriptionType.share) {
        final durationInMinutes = EtaStreamStorage().state.durationInMinutes;

        if (durationInMinutes != null) {
          ref.read(etaTimerIndicatorProvider.notifier).startTimer(durationInMinutes);
        }

        final state = EtaStreamStorage().state;

        if (state.streamId == null || state.streamToken == null || durationInMinutes == null) {
          return;
        }

        _shareDialog(
          state.streamToken!,
          state.streamId!,
          durationInMinutes,
        );

        _locationSubscription = Timer.periodic(const Duration(seconds: sendLocationIntervalSeconds), (_) {
          final location = ref.read(locationProvider);
          if (location != null) {
            EtaWebsocket().pushEtaInfo(
              EtaInfoModel<EtaInfoPayload>(
                type: EtaType.geolocation,
                payload: EtaInfoPayload(
                  period: sendLocationIntervalSeconds * 1000, // in ms
                  direction: location.heading.toInt(),
                  speed: location.speed,
                  lat: location.latitude,
                  lon: location.longitude,
                ),
              ),
            );
          }
        });
      } else {
        ref.read(websocketTypeProvider.notifier).setType();
      }
    });

    ref.onDispose(() {
      EtaStreamStorage().clear();
      _websocketStatusSubscription?.close();
      _locationSubscription?.cancel();
    });
  }

  Future<void> startSharing(int durationInMinutes) async {
    try {
      final etaService = ref.read(etaServiceProvider.notifier);

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

  Future<void> stopSharing(String tokenId, String xStreamData) async {
    final etaService = ref.read(etaServiceProvider.notifier);

    await etaService.stopEtaStream(tokenId, xStreamData);
    await EtaWebsocket().stop();
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
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      ref.read(websocketTypeProvider.notifier).setType(type: SubscriptionType.share);
    }
  }

  void _shareDialog(String tokenId, String streamId, int durationInMinutes) {
    final query = <String, String>{};
    final context = rootNavigatorKey.currentContext;
    if (context == null) {
      return;
    }

    final baseUri = BaldayDeeplink.basePoiUri;
    query[BaldayDeeplink.tokenId] = tokenId;

    query[BaldayDeeplink.streamId] = streamId;

    final shareUrl = BaldayDeeplink.urlWithQuery(baseUri, query);

    final inHour = durationInMinutes ~/ 60;
    final inMinutes = durationInMinutes % 60;

    final duration = inHour > 0
        ? context.l10n.seeLiveLocationHrMin(inHour.toString(), inMinutes.toString())
        : context.l10n.seeLiveLocationMin(inMinutes.toString());

    Share.share('$duration\n$shareUrl');
  }
}
