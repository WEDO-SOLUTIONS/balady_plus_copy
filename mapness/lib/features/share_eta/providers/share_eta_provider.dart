import 'package:dgis_map/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/share_eta/models/eta_info_model.dart';
import 'package:mapness/features/share_eta/models/eta_status_model.dart';
import 'package:mapness/features/share_eta/models/eta_stream_payload.dart';
import 'package:mapness/features/share_eta/models/ws_config.dart';
import 'package:mapness/features/share_eta/providers/eta_service_provider.dart';
import 'package:mapness/features/share_eta/providers/eta_websocket_provider.dart';
import 'package:mapness/features/share_eta/providers/websocket_status_provider.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'share_eta_provider.g.dart';

@riverpod
class ShareEta extends _$ShareEta {
  ProviderSubscription? _websocketStatusSubscription;
  ProviderSubscription? _locationSubscription;

  @override
  void build() {
    _websocketStatusSubscription = ref.listen<EtaStatusModel>(websocketStatusProvider, (_, status) {
      _locationSubscription?.close();
      if (status.status) {
        _locationSubscription = ref.listen<GeoPointMessage?>(locationProvider, (__, location) {
          if (location != null) {
            ref.read(etaWebsocketProvider.notifier).pushEtaInfo(
                  EtaInfoModel<EtaInfoPayload>(
                    type: EtaType.geolocation,
                    payload: EtaInfoPayload(
                      lat: location.latitude,
                      lon: location.longitude,
                    ),
                  ),
                );
          }
        });
      }
    });

    ref.onDispose(() {
      _websocketStatusSubscription?.close();
      _locationSubscription?.close();
    });
  }

  Future<void> startSharing(int durationInMinutes) async {
    final etaService = ref.read(etaServiceProvider.notifier);

    final payload = EtaStreamPayload(
      type: EtaStreamType.eta.name,
      durationMinutes: durationInMinutes,
    );

    await etaService.startEtaStream(payload);
  }

  Future<void> stopSharing(String streamId) async {
    final etaService = ref.read(etaServiceProvider.notifier);

    await etaService.stopEtaStream(streamId);
  }

  Future<void> startWebsocketStream(String streamId, String token, String xStreamData, String finishAt) async {
    final wsProvider = ref.read(etaWebsocketProvider.notifier);

    await wsProvider.start(
      streamId: streamId,
      token: token,
      estimatedTime: finishAt,
      subscriptionType: SubscriptionType.share,
      xStreamData: xStreamData,
    );
  }
}
