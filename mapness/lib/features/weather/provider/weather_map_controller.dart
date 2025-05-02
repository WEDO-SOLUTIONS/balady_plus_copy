import 'package:dgis_map/library.dart';
import 'package:mapness/entities/weather/weather_type_ext.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'weather_map_controller.g.dart';

class WeatherMapState {
  WeatherMapState({required this.type, this.isEnabled});
  final WeatherMapType type;
  final bool? isEnabled;

  WeatherMapState copy({WeatherMapType? type, bool? isEnabled}) => WeatherMapState(
        type: type ?? this.type,
        isEnabled: isEnabled ?? this.isEnabled,
      );
}

@riverpod
class WeatherMapController extends _$WeatherMapController {
  final sub = BehaviorSubject<(WeatherMapType?, bool)>();

  @override
  WeatherMapState build({Function(DgisObjectIdMessage?)? onTap}) {
    final dgisController = ref.read(dgisControllerProvider).value;
    final settings = MapObjectManagerSettings.search();
    final mapObjectManager = ref.read(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
      ).notifier,
    );

    final listener = sub.debounceTime(const Duration(seconds: 1)).listen((value) async {
      final type = value.$1;
      final enable = value.$2;

      final result = await dgisController?.toggleHeatmap(
        message: WeatherMapMessage(
          type: type,
          layerName: type?.layerName(),
          rasterTileUri: type?.tileSourceUri(),
          enabled: enable,
        ),
      );
      state = state.copy(type: type, isEnabled: result);

      if (type case WeatherMapType.precipitation) {
        /// показывает иконки затоплений на карте
        // await searchController.searchByText('critical_point',
        //     icon: MarkerIconMessage(
        //       path: Assets.icons.svg.weather.floodPoint.keyName,
        //       width: 24,
        //     ), onTap: (dgisObject) {
        //   // if(dgisObject!=null){
        //   // // PoiMapRoute(dgisObjectId: dgisObject?.objectId).push(context);
        //   // }
        // });
      } else {
        await mapObjectManager.removeAll();
      }
    });

    ref.onDispose(
      listener.cancel,
    );
    return WeatherMapState(
      type: WeatherMapType.temperature,
    );
  }

  void toggleWeatherMap({
    required bool enable,
    WeatherMapType? type,
  }) {
    sub.add((type ?? WeatherMapType.temperature, enable));
  }

  Future<void> switchOffWeatherLayers() async {
    final dgisController = ref.read(dgisControllerProvider).value;
    await dgisController?.toggleHeatmap(
      message: WeatherMapMessage(enabled: false),
    );
  }
}
