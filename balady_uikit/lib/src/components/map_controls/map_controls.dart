import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/core/utils/constants.dart';
import 'package:balady_uikit/gen/assets/assets.gen.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

part 'controlls/compass_control.dart';

part 'controlls/follow_control.dart';

part 'controlls/happines_control.dart';

part 'controlls/indoor_control.dart';

part 'controlls/layers_control.dart';

part 'controlls/map_button/map_button.dart';

part 'controlls/quiblah_control.dart';

part 'controlls/search_in_area.dart';

part 'controlls/traffic_control.dart';

part 'controlls/weather/weather_control.dart';

part 'controlls/weather/weather_legend.dart';
part 'controlls/pin/pin_on_map.dart';

part 'controlls/zoom_control.dart';

enum MapControlsState { idle, weather, hidden }

/// [MapControls] widget provides a set of controls for managing a map display.
/// This widget includes various controls such as weather, happiness, indoor, layers, traffic, zoom, compass, follow, etc.
///See also:
///* [Figma Design](https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?node-id=85%3A1061&mode=dev)
abstract class MapControls extends StatelessWidget {
  /// The current state of the map controls.
  final MapControlsState state;

  /// Weather control widget.
  final WeatherControl? weatherControl;

  /// Happiness control widget.
  final HappinesControl? happinesControl;

  /// Indoor control widget.
  final IndoorControl? indoorControl;

  /// Quiblah control widget.
  final QuiblahControl? quiblahControl;

  /// Search in area control widget.
  final SearchInArea? searchInArea;

  /// Weather state icon widget.
  final WeatherStateIcon? weatherStateIcon;

  /// Layers control widget.
  final LayersControl? layersControl;

  /// Traffic control widget.
  final TrafficControl? trafficControl;

  /// Zoom control widget.
  final ZoomControl? zoomControl;

  /// Compass control widget.
  final CompassControl? compassControl;

  /// Follow control widget.
  final FollowControl? followControl;

  /// Weather legend widget.
  final WeatherLegend? weatherLegend;

  /// Constructor for [MapControls].
  const MapControls({
    required this.weatherControl,
    required this.happinesControl,
    required this.indoorControl,
    required this.quiblahControl,
    required this.searchInArea,
    required this.weatherStateIcon,
    required this.layersControl,
    required this.trafficControl,
    required this.zoomControl,
    required this.compassControl,
    required this.followControl,
    required this.state,
    required this.weatherLegend,
    Key? key,
  }) : super(key: key);

  factory MapControls.weather({
    required WeatherStateIcon weatherStateIcon,
    required WeatherLegend weatherLegend,
    required IndoorControl indoorControl,
    required SearchInArea searchInArea,
    required LayersControl layersControl,
    required TrafficControl trafficControl,
    required ZoomControl zoomControl,
    required CompassControl compassControl,
    required FollowControl followControl,
    MapControlsState? state,
    Key? key,
  }) =>
      _MapControls(
        key: key,
        indoorControl: indoorControl,
        searchInArea: searchInArea,
        layersControl: layersControl,
        trafficControl: trafficControl,
        zoomControl: zoomControl,
        compassControl: compassControl,
        followControl: followControl,
        state: state ?? MapControlsState.weather,
        weatherStateIcon: weatherStateIcon,
        weatherLegend: weatherLegend,
      );

  factory MapControls.idle({
    WeatherControl? weatherControl,
    HappinesControl? happinesControl,
    IndoorControl? indoorControl,
    QuiblahControl? quiblahControl,
    SearchInArea? searchInArea,
    LayersControl? layersControl,
    TrafficControl? trafficControl,
    ZoomControl? zoomControl,
    CompassControl? compassControl,
    FollowControl? followControl,
    MapControlsState? state,
    Key? key,
  }) =>
      _MapControls(
        key: key,
        weatherControl: weatherControl,
        happinesControl: happinesControl,
        indoorControl: indoorControl,
        quiblahControl: quiblahControl,
        searchInArea: searchInArea,
        layersControl: layersControl,
        trafficControl: trafficControl,
        zoomControl: zoomControl,
        compassControl: compassControl,
        followControl: followControl,
        state: state ?? MapControlsState.idle,
      );
}

class _MapControls extends MapControls {
  const _MapControls({
    required super.state,
    super.weatherControl,
    super.happinesControl,
    super.indoorControl,
    super.quiblahControl,
    super.searchInArea,
    super.weatherStateIcon,
    super.layersControl,
    super.trafficControl,
    super.zoomControl,
    super.compassControl,
    super.followControl,
    super.weatherLegend,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => IgnorePointer(
        ignoring: state == MapControlsState.hidden,
        child: SafeArea(
          child: AnimatedOpacity(
            opacity: state == MapControlsState.hidden ? 0 : 1,
            duration: const Duration(milliseconds: 250),
            child: Stack(
              fit: StackFit.expand,
              textDirection: TextDirection.ltr,
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: switch (state) {
                      MapControlsState.weather => SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: weatherLegend,
                        ),
                      MapControlsState.idle => Column(
                          textDirection: TextDirection.ltr,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            weatherControl ?? const SizedBox.shrink(),
                            Spacing.$2x.heightBox,
                            happinesControl ?? const SizedBox.shrink(),
                            const Spacer(),
                            indoorControl ?? const SizedBox.shrink(),
                            const Spacer(),
                            Row(
                              textDirection: TextDirection.ltr,
                              children: [
                                quiblahControl ?? const SizedBox.shrink(),
                                Spacing.$3x.widthBox,
                                searchInArea ?? const SizedBox.shrink(),
                              ],
                            ),
                          ],
                        ),
                      MapControlsState.hidden => const SizedBox.shrink(),
                    }),
                // const Spacer(),
                Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    textDirection: TextDirection.ltr,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (state == MapControlsState.weather)
                        weatherStateIcon ?? const SizedBox.shrink()
                      else
                        layersControl ?? const SizedBox.shrink(),
                      Spacing.$2x.heightBox,
                      trafficControl ?? const SizedBox.shrink(),
                      const Spacer(),
                      zoomControl ?? const SizedBox.shrink(),
                      const Spacer(),
                      compassControl ?? const SizedBox.shrink(),
                      Spacing.$2x.heightBox,
                      followControl ?? const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class TrafficStateEvent {
  const TrafficStateEvent({
    required this.score,
    required this.status,
  });

  final int score;
  final TrafficControlStatus status;
}

enum TrafficControlStatus { hidden, enabled, disabled, loading }

class IndoorLevel {
  IndoorLevel(this.name, this.levelIndex);

  final String name;
  final int levelIndex;
}

class LevelsState {
  LevelsState(this.levels, this.active);

  final List<IndoorLevel> levels;
  final int active;

  LevelsState copyWith({
    List<IndoorLevel>? levels,
    int? active,
  }) =>
      LevelsState(
        levels ?? this.levels,
        active ?? this.active,
      );
}

class _IndoorControl extends StatelessWidget {
  const _IndoorControl({
    required this.state,
    required this.onSelect,
  });

  final LevelsState state;
  final void Function(IndoorLevel) onSelect;

  @override
  Widget build(BuildContext context) {
    final levels = state.levels;
    return Column(
      children: levels.reversed
          .whereNotNull()
          .mapIndexed<Widget>(
            (index, e) => MapButton(
              onTap: () => onSelect(e),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(index == 0 ? RadiusBorder.ml : RadiusBorder.none),
                topRight: Radius.circular(index == 0 ? RadiusBorder.ml : RadiusBorder.none),
                bottomLeft: Radius.circular(index == levels.length - 1 ? RadiusBorder.ml : RadiusBorder.none),
                bottomRight: Radius.circular(index == levels.length - 1 ? RadiusBorder.ml : RadiusBorder.none),
              ),
              child: Text(
                e.name,
                style: context.textStyles.buttonL.copyWith(
                  color: e.levelIndex == state.active ? context.colors.accentDefault : context.colors.foregroundDefault,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
