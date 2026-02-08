import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:example/widgetbook_app/use_cases/map_control/pins/pin_on_map_area_demo.dart';
import 'package:example/widgetbook_app/use_cases/map_control/pins/pin_on_map_point_demo.dart';
import 'package:example/widgetbook_app/use_cases/map_control/pins/user_position_marker_demo.dart';
import 'package:example/widgetbook_app/use_cases/map_control/table_styles_demo.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: '17. Map controls',
  type: Widget,
)
Widget mapControls(BuildContext context) {
  final userKnobs = context.knobs.boolean(label: 'User', initialValue: true);
  final like = context.knobs.boolean(label: 'Like', initialValue: true);
  final weatherHide = context.knobs.boolean(label: 'Weather', initialValue: true);
  final quiblah = context.knobs.boolean(label: 'Quiblah', initialValue: true);
  final layers = context.knobs.boolean(label: 'Layers', initialValue: true);
  final traffic = context.knobs.boolean(label: 'Traffic', initialValue: true);
  final zoom = context.knobs.boolean(label: 'Zoom', initialValue: true);
  final compass = context.knobs.boolean(label: 'Compass', initialValue: true);
  final follow = context.knobs.boolean(label: 'Follow', initialValue: true);
  final direction = context.knobs.boolean(label: 'Direction', initialValue: true);
  final area = context.knobs.boolean(label: 'Area');

  final hide = context.knobs.boolean(label: 'Hide controls');

  final weather = context.knobs.boolean(label: 'Default/Weather');
  final temperatureSwitch = context.knobs.boolean(label: 'temperature/precipitation');
  final precipitation = [
    '30',
    '25',
    '20',
    '15',
    '10',
    '7',
    '5',
    '3',
    '2',
    '1.5',
    '1',
    '0.5',
    '0.25',
  ];
  final temperature = [
    '48',
    '44',
    '40',
    '36',
    '32',
    '28',
    '24',
    '20',
    '16',
    '12',
    '8',
    '4',
    '0',
    '-4',
  ];

  final mapControlsWeather = MapControls.weather(
      state: hide == true ? MapControlsState.hidden : null,
      weatherStateIcon: WeatherStateIcon(
        icon: (temperatureSwitch ? WeatherIcons.umbrellaEmpty : WeatherIcons.thermometerEmpty).icon(),
      ),
      weatherLegend: WeatherLegend(
        measures: temperatureSwitch ? temperature : precipitation,
        measureUnit: temperatureSwitch ? '°C' : 'mm',
      ),
      indoorControl: IndoorControl(
        onSelect: (indoorLevel) {},
      ),
      searchInArea: const SearchInArea(
        visible: true,
        title: 'Search in area',
      ),
      layersControl: const LayersControl(),
      trafficControl: const TrafficControl(
        opacity: 1,
        isEnabled: true,
      ),
      zoomControl: const ZoomControl(
        zoomInDisabled: false,
        zoomOutDisabled: false,
      ),
      compassControl: const CompassControl(
        angle: 1,
        opacity: 1,
      ),
      followControl: FollowControl(
        opacity: 1,
        onTap: () {},
      ));

  final mapControls = MapControls.idle(
    state: hide == true ? MapControlsState.hidden : null,
    indoorControl: IndoorControl(
      indoorState: LevelsState([IndoorLevel('G', 0), IndoorLevel('1', 1)], 1),
      onSelect: (indoorLevel) {},
    ),
    searchInArea: SearchInArea(
      visible: true,
      title: 'Search in area',
      onTap: () {},
    ),
    layersControl: layers ? const LayersControl() : null,
    trafficControl: traffic
        ? TrafficControl(
            opacity: 1,
            isEnabled: false,
            onTap: () {},
          )
        : null,
    zoomControl: zoom
        ? ZoomControl(
            zoomInDisabled: false,
            zoomOutDisabled: false,
            onTapDownZoomIn: (val) {},
            onTapDownZoomOut: (val) {},
            onTapUpZoomIn: (val) {},
            onTapUpZoomOut: (val) {},
          )
        : null,
    compassControl: compass
        ? CompassControl(
            angle: 0,
            opacity: 1,
            onTap: () {},
          )
        : null,
    followControl: follow
        ? FollowControl(
            opacity: 1,
            onTap: () {},
          )
        : null,
    weatherControl: weatherHide
        ? WeatherControl(
            onTap: () {},
            value: 53,
          )
        : null,
    happinesControl: like ? HappinesControl(onTap: () {}) : null,
    quiblahControl: quiblah ? QuiblahControl(onTap: () {}) : null,
  );

  final mapControlsState = weather ? mapControlsWeather : mapControls;

  return Scaffold(
    backgroundColor: Colors.grey[50],
    body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, right: 90),
            width: 375,
            height: 812,
            child: Padding(
              padding: const EdgeInsets.only(
                left: Spacing.$3x,
                right: Spacing.$3x,
                top: Spacing.$3x,
                bottom: Spacing.$4x,
              ),
              child: Stack(
                children: [
                  mapControlsState,
                  if (userKnobs) Align(child: UserPositionMarkerDemo(area: area, direction: direction)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          const TableStyles(),
          const SizedBox(height: 40),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const MapPin(iconData: GeneralIcons.placeholder),
                  const SizedBox(width: 20),
                  Text('Pin on Map', style: context.textStyles.bodyLargeRegular)
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const PinOnMapAreaDemo(),
                  const SizedBox(width: 20),
                  Text('Icon Pin', style: context.textStyles.bodyLargeRegular)
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const PinOnMapPointDemo(),
                  const SizedBox(width: 20),
                  Text('Icon Pin', style: context.textStyles.bodyLargeRegular)
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    ),
  );
}
