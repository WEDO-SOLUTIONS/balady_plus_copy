part of 'poi_card_widget_page.dart';

class _PoiCardWrapper extends ConsumerWidget {
  final DgisObjectIdMessage objectId;
  final PoiCameraConfig? cameraConfig;
  final dynamic poiCardDataFromGoogle;
  final LatLng? closestPoint;

  const _PoiCardWrapper({
    required this.objectId,
    this.cameraConfig,
    this.poiCardDataFromGoogle,
    this.closestPoint,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
