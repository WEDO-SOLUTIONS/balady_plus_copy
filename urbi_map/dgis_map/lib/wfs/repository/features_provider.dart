//TODO: refactor afterwards
import 'package:dgis_map/library.dart';
import 'package:dgis_map/wfs/data/feature_item.dart';
import 'package:dgis_map/wfs/api/wfs_api.dart';
import 'package:dgis_map/extensions/geo_rect_mesasge_ext.dart';

class FeaturesProvider {
  //TODO: refactor afterwards
  factory FeaturesProvider.get() => _instance;

  FeaturesProvider._();

  static final FeaturesProvider _instance = FeaturesProvider._();

  static const String _testJsonName =
      "packages/dgis_map/assets/json/panoramas_test.json";

  GeoRectMessage? _lastProceedRect;

  Future<List<FeatureItem>> panoramas(
    DgisMapController controller,
    GeoRectMessage visibleRect,
  ) async {
    final isOverlapped = _lastProceedRect != null
        ? await controller.overlappedBy(_lastProceedRect!, visibleRect) == 1
            ? true
            : false
        : false;

    if (isOverlapped) return [];

    _lastProceedRect = visibleRect.expandedBy(1.5);

    final allItems = await WfsApi.get().getPanoramas(
        northEastLat: _lastProceedRect!.northEast.latitude,
        northEastLon: _lastProceedRect!.northEast.longitude,
        southWestLat: _lastProceedRect!.southWest.latitude,
        southWestLon: _lastProceedRect!.southWest.longitude);

    final panoramas =
        allItems.where((element) => element.properties.panoramic).toList();

    return panoramas;
  }

  /// Clear cache and cancel panoramas assosiated requests
  void releasePanoramas() {
    _lastProceedRect = null;
    WfsApi.get().releasePanoramas();
  }
}
