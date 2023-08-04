import 'package:dgis_map/library.dart';
import 'package:dgis_map/esri/api/esri_api.dart';
import 'package:dgis_map/esri/data/layer_data.dart';
import 'package:dgis_map/esri/data/layer_info.dart';
import 'package:dgis_map/esri/data/layer_item.dart';
import 'package:dgis_map/extensions/geo_rect_mesasge_ext.dart';

class LayersProvider {
  factory LayersProvider.get() => _instance;

  LayersProvider._();

  static final LayersProvider _instance = LayersProvider._();

  GeoRectMessage? _lastProceedRect;

  Future<List<LayerItem>> layers() async {
    final layers = await EsriApi.get().getLayers();
    return layers;
  }

  Future<LayerInfo> layerInfo(LayerItem item) async {
    final info = await EsriApi.get().getLayerInfo(item);
    return info;
  }

  Future<LayerData> layerData(LayerInfo info) async {
    final data = await EsriApi.get().getLayerData(info);
    return data;
  }

  Future<LayerData?> getLayerDataForViewport(
    LayerInfo info,
    DgisMapController controller,
    GeoRectMessage visibleRect,
  ) async {
    final isOverlapped = _lastProceedRect != null
        ? await controller.overlappedBy(_lastProceedRect!, visibleRect) == 1
            ? true
            : false
        : false;

    if (isOverlapped) return null;

    _lastProceedRect = visibleRect.expandedBy(1.5);
    return await EsriApi.get().getLayerDataForViewport(
        info,
        _lastProceedRect!.northEast.latitude,
        _lastProceedRect!.northEast.longitude,
        _lastProceedRect!.southWest.latitude,
        _lastProceedRect!.southWest.longitude);
  }

  void resetProvider() {
    EsriApi.get().cancelRequest();
    _lastProceedRect = null;
  }
}
