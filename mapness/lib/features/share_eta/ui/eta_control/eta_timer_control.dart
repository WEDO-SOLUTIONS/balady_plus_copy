import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/features/share_eta/entities/share_eta_time_type.dart';
import 'package:mapness/features/share_eta/providers/eta_stream_storage.dart';
import 'package:mapness/features/share_eta/providers/eta_timer_indicator.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_inprogress_sheet.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_sharing_time_sheet.dart';
import 'package:mapness/features/share_eta/ui/pulse_indicator.dart';

class EtaTimerControl extends ConsumerWidget {
  const EtaTimerControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(etaTimerIndicatorProvider);

    final diffInHours = timer ~/ 60;
    final diffInMinutes = timer % 60;

    //TODO(scroollocker): localize this string
    final estimatedTimeString = diffInHours > 0 ? '$diffInHours hr $diffInMinutes min' : '$diffInMinutes min';

    return MapButton(
      onTap: () async {
        // final closestPoint = GeoPointWithElevationMessage(
        //   latitude: 24.715817,
        //   longitude: 46.671102,
        //   elevation: 0,
        // );
        // final settings = MapObjectManagerSettings.myLocation();
        // final mapObjectManager = ref.watch(
        //   mapObjectManagerProvider(
        //     named: settings.name,
        //     layerId: settings.layerId,
        //   ).notifier,
        // );
        // await mapObjectManager.removeAllMarkers();
        // final marker = Marker(
        //   id: 'PIN-MARKER',
        //   options: MarkerOptionsMessage(
        //     position: closestPoint,
        //     icon: PngBytesMarkerIcon(
        //       pngData: img.encodePng(await processImage()),
        //       width: 48,
        //     ),
        //     anchor: MarkerAnchorMessage(x: 0.5, y: 1),
        //     animatedAppearance: true,
        //     zIndex: 50,
        //   ),
        // );

        // final read = ref.read(selectedMarkerProvider.notifier);
        // await read.removeAllMarkers();

        // await mapObjectManager.addMarker(marker);

        // await ref.read(cameraPositionProvider.notifier).animateTo(
        //       CameraPositionMessage(
        //         point: GeoPointMessage(latitude: closestPoint!.latitude, longitude: closestPoint!.longitude),
        //         zoom: 16,
        //         tilt: 0,
        //         bearing: 0,
        //       ),
        //     );
        _continueShared(context, ref);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PulseIndicator(),
            const SizedBox(width: 8),
            Text(
              estimatedTimeString,
              style: context.textStyleV3.captionLargeMedium.copyWith(color: context.colorsV2.foregroundDefault),
            ),
          ],
        ),
      ),
    );
  }

  void _continueShared(BuildContext context, WidgetRef ref) {
    final timerTime = ref.read(etaTimerIndicatorProvider);

    final hourLeft = timerTime ~/ 60;
    final leftMinutes = timerTime % 60;

    final left = hourLeft > 0 ? '$hourLeft hr $leftMinutes min left' : '$leftMinutes min left';

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => EtaInprogressSheet(
        onShareMorePressed: () async {
          context.pop();
          _showEtaTimeSheet(context, ref);
        },
        onStopSharePressed: () {
          context.pop();
          _stopShare(context, ref);
        },
        timeLeft: left,
      ),
    );
  }

  void _showEtaTimeSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => EtaSharingTimeSheet(
        onConfirmTap: (v) async {
          await _stopShare(context, ref);
          await ref.read(shareEtaProvider.notifier).startSharing(v.durationInMinutes);
        },
      ),
    );
  }

  Future<void> _stopShare(BuildContext context, WidgetRef ref) async {
    final etaStore = EtaStreamStorage();
    if (etaStore.state.streamToken == null || etaStore.state.xStreamData == null) {
      return;
    }
    final tokenId = etaStore.state.streamToken!;
    final streamData = etaStore.state.xStreamData!;

    await ref.read(shareEtaProvider.notifier).stopSharing(tokenId, streamData);
    etaStore.clear();
  }
}
