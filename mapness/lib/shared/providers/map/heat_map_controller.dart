import 'package:intl/intl.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'heat_map_controller.g.dart';

@riverpod
class HeatMapController extends _$HeatMapController {
  @override
  Future<void> build() async {
    ref.onDispose(
      () {},
    );
  }

  Future<void> toggleHeatMap() async {
    final dgisController = ref.watch(dgisControllerProvider);

    await dgisController?.toggleHeatmap(
      tileSourceUri: _tileSourceUri(),
      layerName: 'heatmap',
    );
  }

  String _tileSourceUri() {
    final format = DateFormat('yyyy-MM-dd\'T\'HH:mm').format(DateTime.now());
    // const apiKey = 'be72f76237db';
    const apiKey = '74daf4716240';
    return "https://maps-api.meteoblue.com/v1/map/raster/ICONAUTO/$format/"
        "11~2 m above gnd~hourly~none~contourSteps~"
        "-10.0~rgba(52,140,237,1.0)~"
        "-8.0~rgba(68,177,246,1.0)~"
        "-6.0~rgba(81,203,250,1.0)~"
        "-4.0~rgba(128,224,247,1.0)~"
        "-2.0~rgba(160,234,247,1.0)~"
        "0.0~rgba(0,239,124,1.0)~"
        "2.0~rgba(0,228,82,1.0)~"
        "4.0~rgba(0,200,72,1.0)~"
        "6.0~rgba(16,184,122,1.0)~"
        "8.0~rgba(41,123,93,1.0)~"
        "10.0~rgba(0,114,41,1.0)~"
        "12.0~rgba(60,161,44,1.0)~"
        "14.0~rgba(121,208,48,1.0)~"
        "16.0~rgba(181,255,51,1.0)~"
        "18.0~rgba(216,247,161,1.0)~"
        "20.0~rgba(255,246,0,1.0)~"
        "22.0~rgba(248,223,11,1.0)~"
        "24.0~rgba(253,202,12,1.0)~"
        "26.0~rgba(252,172,5,1.0)~"
        "28.0~rgba(248,141,0,1.0)~"
        "30.0~rgba(255,102,0,1.0)~/"
        "{z}/{x}/{y}?temperatureUnit=C&apikey=$apiKey";
  }
}
