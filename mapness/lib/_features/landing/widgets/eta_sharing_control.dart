import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:mapness/features/share_eta/providers/websocket_status_provider.dart';
import 'package:mapness/features/share_eta/ui/pulse_indicator.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';

class EtaSharingControl extends ConsumerWidget {
  const EtaSharingControl({super.key});

  static const imgSize = 48;

  Future<img.Image> processImage() async {
    // Load the mask image from assets
    final maskData = await rootBundle.load('packages/mapness/assets/images/marker_eta_mask.png');
    final maskBytes = maskData.buffer.asUint8List();

    final mask = img.decodeImage(maskBytes)!;

    var mask48x48 = img.copyResize(mask, width: imgSize, height: imgSize, interpolation: img.Interpolation.average);

    if (mask48x48.hasAlpha == false) {
      mask48x48 = mask48x48.convert(format: mask48x48.format, numChannels: 4);
    }

    // // Load the image from the network
    final response = await http.get(Uri.parse('https://i.pravatar.cc/48?img=51'));
    var networkImage = img.decodeImage(response.bodyBytes)!;
    if (networkImage.hasAlpha == false) {
      networkImage = networkImage.convert(format: networkImage.format, numChannels: 4);
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webSocketStatus = ref.watch(websocketStatusProvider);

    final estimatedTime = webSocketStatus.estimatedTime;

    // substract estimated time from current time and status diff
    final diffTime = estimatedTime != null ? estimatedTime.difference(DateTime.now()) : null;

    // if diff have hours print hours then check minutes. If hours == 0 print only minutes
    final diffHours = diffTime != null ? diffTime.inHours : 0;
    final diffMinutes = diffTime != null ? diffTime.inMinutes.remainder(60) : 0;

    final estimatedTimeString = diffHours > 0 ? '$diffHours hr $diffMinutes min' : '$diffMinutes min';

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: !webSocketStatus.status
          ? MapButton(
              onTap: () async {
                final closestPoint = GeoPointWithElevationMessage(
                  latitude: 24.715817,
                  longitude: 46.671102,
                  elevation: 0,
                );
                final settings = MapObjectManagerSettings.myLocation();
                final mapObjectManager = ref.watch(
                  mapObjectManagerProvider(
                    named: settings.name,
                    layerId: settings.layerId,
                  ).notifier,
                );
                await mapObjectManager.removeAllMarkers();
                final marker = Marker(
                  id: 'PIN-MARKER',
                  options: MarkerOptionsMessage(
                    position: closestPoint,
                    icon: PngBytesMarkerIcon(
                      pngData: img.encodePng(await processImage()),
                      width: 48,
                    ),
                    anchor: MarkerAnchorMessage(x: 0.5, y: 1),
                    animatedAppearance: true,
                    zIndex: 50,
                  ),
                );

                final read = ref.read(selectedMarkerProvider.notifier);
                await read.removeAllMarkers();

                await mapObjectManager.addMarker(marker);

                await ref.read(cameraPositionProvider.notifier).animateTo(
                      CameraPositionMessage(
                        point: GeoPointMessage(latitude: closestPoint!.latitude, longitude: closestPoint!.longitude),
                        zoom: 16,
                        tilt: 0,
                        bearing: 0,
                      ),
                    );
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
            )
          : const SizedBox.shrink(),
    );
  }
}
