import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/share_eta/models/eta_info_model.dart';
import 'package:mapness/features/share_eta/models/eta_stream_payload.dart';
import 'package:mapness/features/share_eta/models/ws_config.dart';
import 'package:mapness/features/share_eta/providers/eta_service_provider.dart';
import 'package:mapness/features/share_eta/providers/eta_stream_storage.dart';
import 'package:mapness/features/share_eta/providers/eta_timer_indicator.dart';
import 'package:mapness/features/share_eta/providers/eta_websocket_locator.dart';
import 'package:mapness/features/share_eta/providers/websocket_status_provider.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'share_eta_provider.g.dart';

@riverpod
class ShareEta extends _$ShareEta {
  static const int sendLocationIntervalSeconds = 3;

  ProviderSubscription? _websocketStatusSubscription;
  Timer? _locationSubscription;

  @override
  void build() {
    _websocketStatusSubscription = ref.listen<bool>(websocketStatusProvider, (_, status) {
      _locationSubscription?.cancel();
      if (status) {
        final durationInMinutes = EtaStreamStorage().state.durationInMinutes;

        if (durationInMinutes != null) {
          ref.read(etaTimerIndicatorProvider.notifier).startTimer(durationInMinutes);
        }

        _locationSubscription = Timer.periodic(const Duration(seconds: sendLocationIntervalSeconds), (_) {
          final location = ref.read(locationProvider);
          if (location != null) {
            EtaWebsocket().pushEtaInfo(
              EtaInfoModel<EtaInfoPayload>(
                type: EtaType.geolocation,
                payload: EtaInfoPayload(
                  period: 3000,
                  direction: 90,
                  speed: 59,
                  lat: location.latitude,
                  lon: location.longitude,
                ),
              ),
            );
          }
        });
      } else {
        ref.read(etaTimerIndicatorProvider.notifier).stopTimer();
      }
    });

    ref.onDispose(() {
      EtaStreamStorage().clear();
      _websocketStatusSubscription?.close();
      _locationSubscription?.cancel();
    });
  }

  Future<void> startSharing(int durationInMinutes) async {
    final etaService = ref.read(etaServiceProvider.notifier);

    final payload = EtaStreamPayload(
      type: EtaStreamType.geo.name,
      durationMinutes: durationInMinutes,
    );

    //store the duration in the storage
    EtaStreamStorage().setDurationInMinutes(durationInMinutes);
    await etaService.startEtaStream(payload);
  }

  Future<void> stopSharing(String streamId) async {
    final etaService = ref.read(etaServiceProvider.notifier);

    await etaService.stopEtaStream(streamId);
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
    }
  }
}
