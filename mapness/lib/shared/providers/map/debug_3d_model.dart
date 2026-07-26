import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/tifo/launch_screen.dart';
import 'package:mapness/features/tifo/onboarding_screen.dart';
import 'package:mapness/features/tifo/penalty/penalty_entry_screen.dart';
import 'package:mapness/features/tifo/tifo_flow_provider.dart';
import 'package:mapness/features/tifo/tifo_team.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

const debug3dModelId = 'debug-3d-model';
const debug3dModelLatitude = 24.71495891002165;
const debug3dModelLongitude = 46.67876719900673;
const debug3dModelPath = 'packages/mapness/assets/models/LIGHT_THEME_CAR_MODEL.glb';
const debugYellowStadiumModelPath = 'packages/mapness/assets/models/yellowe_stadium_fix.glb';
const debugBlueStadiumModelPath = 'packages/mapness/assets/models/blue_stadium_fix.glb';
const debugDistrictModelPaths = <String>[
  debugYellowStadiumModelPath,
  debugBlueStadiumModelPath,
];
const debugDistrictModelPathsLabel = 'yellowe_stadium_fix.glb, blue_stadium_fix.glb';
const debugDistrictPolygonFillArgbs = <int>[
  0x3314B8A6,
  0x33F5A623,
  0x337B61FF,
  0x33E5484D,
  0x332F80ED,
  0x3327AE60,
];
const debugDistrictPolygonStrokeArgbs = <int>[
  0xFF0AB0A4,
  0xFFF5A623,
  0xFF7B61FF,
  0xFFE5484D,
  0xFF2F80ED,
  0xFF27AE60,
];
const debugDistrictSolidPolygonFillArgbs = <DebugDistrictPolygonColorMode, int>{
  DebugDistrictPolygonColorMode.teal: 0x3314B8A6,
  DebugDistrictPolygonColorMode.amber: 0x33F5A623,
  DebugDistrictPolygonColorMode.purple: 0x337B61FF,
  DebugDistrictPolygonColorMode.red: 0x33E5484D,
  DebugDistrictPolygonColorMode.blue: 0x332F80ED,
  DebugDistrictPolygonColorMode.green: 0x3327AE60,
  DebugDistrictPolygonColorMode.gray: 0x336B7280,
};
const debugDistrictSolidPolygonStrokeArgbs = <DebugDistrictPolygonColorMode, int>{
  DebugDistrictPolygonColorMode.teal: 0xFF0AB0A4,
  DebugDistrictPolygonColorMode.amber: 0xFFF5A623,
  DebugDistrictPolygonColorMode.purple: 0xFF7B61FF,
  DebugDistrictPolygonColorMode.red: 0xFFE5484D,
  DebugDistrictPolygonColorMode.blue: 0xFF2F80ED,
  DebugDistrictPolygonColorMode.green: 0xFF27AE60,
  DebugDistrictPolygonColorMode.gray: 0xFF6B7280,
};
const debugDistrictCameraLatitude = 24.755353712174955;
const debugDistrictCameraLongitude = 46.78380853883565;

int _debugDistrictPolygonFillArgb(int index, DebugDistrictPolygonColorMode mode) {
  if (mode == DebugDistrictPolygonColorMode.palette) {
    return debugDistrictPolygonFillArgbs[index % debugDistrictPolygonFillArgbs.length];
  }

  return debugDistrictSolidPolygonFillArgbs[mode]!;
}

int _debugDistrictPolygonStrokeArgb(int index, DebugDistrictPolygonColorMode mode) {
  if (mode == DebugDistrictPolygonColorMode.palette) {
    return debugDistrictPolygonStrokeArgbs[index % debugDistrictPolygonStrokeArgbs.length];
  }

  return debugDistrictSolidPolygonStrokeArgbs[mode]!;
}

String _debugDistrictModelPath(int index) => debugDistrictModelPaths[index % debugDistrictModelPaths.length];

enum DebugDistrictPolygonColorMode {
  palette,
  teal,
  amber,
  purple,
  red,
  blue,
  green,
  gray;

  String get label => switch (this) {
    DebugDistrictPolygonColorMode.palette => 'Palette',
    DebugDistrictPolygonColorMode.teal => 'Teal',
    DebugDistrictPolygonColorMode.amber => 'Amber',
    DebugDistrictPolygonColorMode.purple => 'Purple',
    DebugDistrictPolygonColorMode.red => 'Red',
    DebugDistrictPolygonColorMode.blue => 'Blue',
    DebugDistrictPolygonColorMode.green => 'Green',
    DebugDistrictPolygonColorMode.gray => 'Gray',
  };

  int get previewStrokeArgb => this == DebugDistrictPolygonColorMode.palette
      ? debugDistrictPolygonStrokeArgbs.first
      : debugDistrictSolidPolygonStrokeArgbs[this]!;

  DebugDistrictPolygonColorMode get next {
    const modes = DebugDistrictPolygonColorMode.values;
    return modes[(index + 1) % modes.length];
  }
}

const debugDistrictPolygons = <DebugDistrictPolygon>[
  DebugDistrictPolygon(
    id: 'debug-district-polygon-0',
    centroid: DebugGeoPoint(latitude: 24.754832832399284, longitude: 46.754103816399216),
    ring: [
      DebugGeoPoint(latitude: 24.740726, longitude: 46.749192),
      DebugGeoPoint(latitude: 24.741118, longitude: 46.748864),
      DebugGeoPoint(latitude: 24.741586, longitude: 46.748628),
      DebugGeoPoint(latitude: 24.759344, longitude: 46.739684),
      DebugGeoPoint(latitude: 24.759557, longitude: 46.739577),
      DebugGeoPoint(latitude: 24.759699, longitude: 46.739619),
      DebugGeoPoint(latitude: 24.759782, longitude: 46.739659),
      DebugGeoPoint(latitude: 24.76033, longitude: 46.740886),
      DebugGeoPoint(latitude: 24.760379, longitude: 46.741003),
      DebugGeoPoint(latitude: 24.761975, longitude: 46.744923),
      DebugGeoPoint(latitude: 24.762153, longitude: 46.745363),
      DebugGeoPoint(latitude: 24.76579, longitude: 46.754955),
      DebugGeoPoint(latitude: 24.765887, longitude: 46.755211),
      DebugGeoPoint(latitude: 24.767037, longitude: 46.758341),
      DebugGeoPoint(latitude: 24.767229, longitude: 46.759171),
      DebugGeoPoint(latitude: 24.766699, longitude: 46.759599),
      DebugGeoPoint(latitude: 24.766294, longitude: 46.7599),
      DebugGeoPoint(latitude: 24.754164, longitude: 46.768901),
      DebugGeoPoint(latitude: 24.753396, longitude: 46.769465),
      DebugGeoPoint(latitude: 24.753165, longitude: 46.769556),
      DebugGeoPoint(latitude: 24.752812, longitude: 46.769034),
      DebugGeoPoint(latitude: 24.744855, longitude: 46.756236),
      DebugGeoPoint(latitude: 24.742529, longitude: 46.752437),
      DebugGeoPoint(latitude: 24.740912, longitude: 46.749748),
      DebugGeoPoint(latitude: 24.740732, longitude: 46.749276),
      DebugGeoPoint(latitude: 24.740726, longitude: 46.749192),
    ],
  ),
  DebugDistrictPolygon(
    id: 'debug-district-polygon-1',
    centroid: DebugGeoPoint(latitude: 24.761999859337468, longitude: 46.775036626720926),
    ring: [
      DebugGeoPoint(latitude: 24.747448, longitude: 46.774543),
      DebugGeoPoint(latitude: 24.747611, longitude: 46.774385),
      DebugGeoPoint(latitude: 24.749364, longitude: 46.773046),
      DebugGeoPoint(latitude: 24.757812, longitude: 46.76675),
      DebugGeoPoint(latitude: 24.758421, longitude: 46.766299),
      DebugGeoPoint(latitude: 24.766758, longitude: 46.760128),
      DebugGeoPoint(latitude: 24.766831, longitude: 46.760079),
      DebugGeoPoint(latitude: 24.767252, longitude: 46.759838),
      DebugGeoPoint(latitude: 24.767465, longitude: 46.759732),
      DebugGeoPoint(latitude: 24.767686, longitude: 46.759911),
      DebugGeoPoint(latitude: 24.775971, longitude: 46.775747),
      DebugGeoPoint(latitude: 24.775396, longitude: 46.776362),
      DebugGeoPoint(latitude: 24.772717, longitude: 46.778922),
      DebugGeoPoint(latitude: 24.772553, longitude: 46.779044),
      DebugGeoPoint(latitude: 24.764425, longitude: 46.785019),
      DebugGeoPoint(latitude: 24.757393, longitude: 46.789499),
      DebugGeoPoint(latitude: 24.756927, longitude: 46.789687),
      DebugGeoPoint(latitude: 24.75669, longitude: 46.789683),
      DebugGeoPoint(latitude: 24.751939, longitude: 46.782033),
      DebugGeoPoint(latitude: 24.748365, longitude: 46.776249),
      DebugGeoPoint(latitude: 24.748269, longitude: 46.776093),
      DebugGeoPoint(latitude: 24.747546, longitude: 46.774877),
      DebugGeoPoint(latitude: 24.747448, longitude: 46.774543),
    ],
  ),
  DebugDistrictPolygon(
    id: 'debug-district-polygon-2',
    centroid: DebugGeoPoint(latitude: 24.776986513653043, longitude: 46.80251944296221),
    ring: [
      DebugGeoPoint(latitude: 24.757164, longitude: 46.790408),
      DebugGeoPoint(latitude: 24.75719, longitude: 46.790253),
      DebugGeoPoint(latitude: 24.757306, longitude: 46.790053),
      DebugGeoPoint(latitude: 24.757724, longitude: 46.789714),
      DebugGeoPoint(latitude: 24.757754, longitude: 46.789691),
      DebugGeoPoint(latitude: 24.761483, longitude: 46.786931),
      DebugGeoPoint(latitude: 24.762218, longitude: 46.786387),
      DebugGeoPoint(latitude: 24.762771, longitude: 46.785978),
      DebugGeoPoint(latitude: 24.76292, longitude: 46.785868),
      DebugGeoPoint(latitude: 24.775655, longitude: 46.777322),
      DebugGeoPoint(latitude: 24.775818, longitude: 46.777272),
      DebugGeoPoint(latitude: 24.776287, longitude: 46.777257),
      DebugGeoPoint(latitude: 24.776457, longitude: 46.77746),
      DebugGeoPoint(latitude: 24.79526, longitude: 46.816278),
      DebugGeoPoint(latitude: 24.795499, longitude: 46.817374),
      DebugGeoPoint(latitude: 24.795247, longitude: 46.817702),
      DebugGeoPoint(latitude: 24.794734, longitude: 46.818237),
      DebugGeoPoint(latitude: 24.791985, longitude: 46.820306),
      DebugGeoPoint(latitude: 24.791806, longitude: 46.820439),
      DebugGeoPoint(latitude: 24.781978, longitude: 46.827633),
      DebugGeoPoint(latitude: 24.781527, longitude: 46.827962),
      DebugGeoPoint(latitude: 24.780852, longitude: 46.828351),
      DebugGeoPoint(latitude: 24.779939, longitude: 46.827223),
      DebugGeoPoint(latitude: 24.779908, longitude: 46.827174),
      DebugGeoPoint(latitude: 24.760324, longitude: 46.795625),
      DebugGeoPoint(latitude: 24.760304, longitude: 46.795592),
      DebugGeoPoint(latitude: 24.757164, longitude: 46.790408),
    ],
  ),
  DebugDistrictPolygon(
    id: 'debug-district-polygon-3',
    centroid: DebugGeoPoint(latitude: 24.734339497190597, longitude: 46.767194713099585),
    ring: [
      DebugGeoPoint(latitude: 24.716818, longitude: 46.764023),
      DebugGeoPoint(latitude: 24.716934, longitude: 46.762805),
      DebugGeoPoint(latitude: 24.716958, longitude: 46.762655),
      DebugGeoPoint(latitude: 24.71739, longitude: 46.761278),
      DebugGeoPoint(latitude: 24.717462, longitude: 46.76107),
      DebugGeoPoint(latitude: 24.717942, longitude: 46.760617),
      DebugGeoPoint(latitude: 24.718264, longitude: 46.760343),
      DebugGeoPoint(latitude: 24.718391, longitude: 46.760249),
      DebugGeoPoint(latitude: 24.718764, longitude: 46.76006),
      DebugGeoPoint(latitude: 24.719, longitude: 46.759941),
      DebugGeoPoint(latitude: 24.720794, longitude: 46.759038),
      DebugGeoPoint(latitude: 24.735713, longitude: 46.751562),
      DebugGeoPoint(latitude: 24.73995, longitude: 46.749444),
      DebugGeoPoint(latitude: 24.740071, longitude: 46.749455),
      DebugGeoPoint(latitude: 24.740099, longitude: 46.749458),
      DebugGeoPoint(latitude: 24.740126, longitude: 46.749466),
      DebugGeoPoint(latitude: 24.740152, longitude: 46.749479),
      DebugGeoPoint(latitude: 24.740175, longitude: 46.749497),
      DebugGeoPoint(latitude: 24.740195, longitude: 46.749519),
      DebugGeoPoint(latitude: 24.740212, longitude: 46.749544),
      DebugGeoPoint(latitude: 24.743646, longitude: 46.755055),
      DebugGeoPoint(latitude: 24.744495, longitude: 46.756421),
      DebugGeoPoint(latitude: 24.751654, longitude: 46.767944),
      DebugGeoPoint(latitude: 24.752587, longitude: 46.76945),
      DebugGeoPoint(latitude: 24.752849, longitude: 46.769873),
      DebugGeoPoint(latitude: 24.735177, longitude: 46.783064),
      DebugGeoPoint(latitude: 24.730899, longitude: 46.786238),
      DebugGeoPoint(latitude: 24.730854, longitude: 46.786271),
      DebugGeoPoint(latitude: 24.730615, longitude: 46.786221),
      DebugGeoPoint(latitude: 24.729494, longitude: 46.78505),
      DebugGeoPoint(latitude: 24.72919, longitude: 46.784665),
      DebugGeoPoint(latitude: 24.729154, longitude: 46.784608),
      DebugGeoPoint(latitude: 24.723733, longitude: 46.776009),
      DebugGeoPoint(latitude: 24.723647, longitude: 46.77587),
      DebugGeoPoint(latitude: 24.719731, longitude: 46.769512),
      DebugGeoPoint(latitude: 24.71759, longitude: 46.765834),
      DebugGeoPoint(latitude: 24.716836, longitude: 46.764383),
      DebugGeoPoint(latitude: 24.716818, longitude: 46.764253),
      DebugGeoPoint(latitude: 24.716818, longitude: 46.764023),
    ],
  ),
  DebugDistrictPolygon(
    id: 'debug-district-polygon-4',
    centroid: DebugGeoPoint(latitude: 24.743634742007515, longitude: 46.78854911742632),
    ring: [
      DebugGeoPoint(latitude: 24.730788, longitude: 46.787078),
      DebugGeoPoint(latitude: 24.731075, longitude: 46.786776),
      DebugGeoPoint(latitude: 24.73469, longitude: 46.784),
      DebugGeoPoint(latitude: 24.736346, longitude: 46.782754),
      DebugGeoPoint(latitude: 24.743274, longitude: 46.777583),
      DebugGeoPoint(latitude: 24.743989, longitude: 46.77705),
      DebugGeoPoint(latitude: 24.744326, longitude: 46.776801),
      DebugGeoPoint(latitude: 24.745183, longitude: 46.776169),
      DebugGeoPoint(latitude: 24.746962, longitude: 46.774876),
      DebugGeoPoint(latitude: 24.746985, longitude: 46.774868),
      DebugGeoPoint(latitude: 24.747006, longitude: 46.774872),
      DebugGeoPoint(latitude: 24.747026, longitude: 46.774884),
      DebugGeoPoint(latitude: 24.755117, longitude: 46.787976),
      DebugGeoPoint(latitude: 24.756478, longitude: 46.790194),
      DebugGeoPoint(latitude: 24.750696, longitude: 46.794552),
      DebugGeoPoint(latitude: 24.745082, longitude: 46.798732),
      DebugGeoPoint(latitude: 24.741338, longitude: 46.801472),
      DebugGeoPoint(latitude: 24.740282, longitude: 46.802152),
      DebugGeoPoint(latitude: 24.731126, longitude: 46.787627),
      DebugGeoPoint(latitude: 24.730788, longitude: 46.787078),
    ],
  ),
  DebugDistrictPolygon(
    id: 'debug-district-polygon-5',
    centroid: DebugGeoPoint(latitude: 24.76032882846184, longitude: 46.81544751640567),
    ring: [
      DebugGeoPoint(latitude: 24.740578, longitude: 46.802483),
      DebugGeoPoint(latitude: 24.745137, longitude: 46.799057),
      DebugGeoPoint(latitude: 24.753156, longitude: 46.793081),
      DebugGeoPoint(latitude: 24.753194, longitude: 46.793053),
      DebugGeoPoint(latitude: 24.756691, longitude: 46.790538),
      DebugGeoPoint(latitude: 24.758437, longitude: 46.793314),
      DebugGeoPoint(latitude: 24.769631, longitude: 46.811297),
      DebugGeoPoint(latitude: 24.778829, longitude: 46.826079),
      DebugGeoPoint(latitude: 24.780311, longitude: 46.828668),
      DebugGeoPoint(latitude: 24.779643, longitude: 46.829233),
      DebugGeoPoint(latitude: 24.770006, longitude: 46.836637),
      DebugGeoPoint(latitude: 24.769974, longitude: 46.836656),
      DebugGeoPoint(latitude: 24.768499, longitude: 46.837363),
      DebugGeoPoint(latitude: 24.762899, longitude: 46.837313),
      DebugGeoPoint(latitude: 24.762589, longitude: 46.837293),
      DebugGeoPoint(latitude: 24.762422, longitude: 46.837269),
      DebugGeoPoint(latitude: 24.760659, longitude: 46.835993),
      DebugGeoPoint(latitude: 24.741776, longitude: 46.804742),
      DebugGeoPoint(latitude: 24.740693, longitude: 46.802774),
      DebugGeoPoint(latitude: 24.740679, longitude: 46.802747),
      DebugGeoPoint(latitude: 24.740578, longitude: 46.802483),
    ],
  ),
];

final debug3dModelProvider = NotifierProvider<Debug3DModelController, Debug3DModelState>(
  Debug3DModelController.new,
);

class Debug3DModelState {
  const Debug3DModelState({
    required this.isAdded,
    required this.arePolygonsVisible,
    required this.areCentroidModelsVisible,
    required this.polygonColorMode,
    required this.polygonColorModeOverrides,
    required this.isBusy,
    required this.isGameModeActive,
    required this.capturedPolygonIds,
    this.error,
  });

  final bool isAdded;
  final bool arePolygonsVisible;
  final bool areCentroidModelsVisible;
  final DebugDistrictPolygonColorMode polygonColorMode;
  final Map<String, DebugDistrictPolygonColorMode> polygonColorModeOverrides;
  final bool isBusy;
  final bool isGameModeActive;

  /// Polygon ids the player captured by scoring a goal in [PenaltyApp].
  /// Captured polygons render in the selected team's color and stay on the
  /// map until game mode is turned off.
  final Set<String> capturedPolygonIds;
  final String? error;

  bool get hasDistrictLayerObjects =>
      arePolygonsVisible || areCentroidModelsVisible || capturedPolygonIds.isNotEmpty;

  Debug3DModelState copyWith({
    bool? isAdded,
    bool? arePolygonsVisible,
    bool? areCentroidModelsVisible,
    DebugDistrictPolygonColorMode? polygonColorMode,
    Map<String, DebugDistrictPolygonColorMode>? polygonColorModeOverrides,
    bool? isBusy,
    bool? isGameModeActive,
    Set<String>? capturedPolygonIds,
    String? error,
  }) => Debug3DModelState(
    isAdded: isAdded ?? this.isAdded,
    arePolygonsVisible: arePolygonsVisible ?? this.arePolygonsVisible,
    areCentroidModelsVisible: areCentroidModelsVisible ?? this.areCentroidModelsVisible,
    polygonColorMode: polygonColorMode ?? this.polygonColorMode,
    polygonColorModeOverrides: polygonColorModeOverrides ?? this.polygonColorModeOverrides,
    isBusy: isBusy ?? this.isBusy,
    isGameModeActive: isGameModeActive ?? this.isGameModeActive,
    capturedPolygonIds: capturedPolygonIds ?? this.capturedPolygonIds,
    error: error,
  );
}

class Debug3DModelController extends Notifier<Debug3DModelState> {
  MapObjectManagerMessage? _manager;
  MapObjectManagerMessage? _districtLayerManager;
  bool _isDisposed = false;

  @override
  Debug3DModelState build() {
    _isDisposed = false;
    ref.onDispose(() {
      _isDisposed = true;
      unawaited(_disposeManager());
    });

    return const Debug3DModelState(
      isAdded: false,
      arePolygonsVisible: false,
      areCentroidModelsVisible: false,
      polygonColorMode: DebugDistrictPolygonColorMode.palette,
      polygonColorModeOverrides: {},
      isBusy: false,
      isGameModeActive: false,
      capturedPolygonIds: {},
    );
  }

  Future<void> addModel() => _run((controller) async {
    final manager = await _ensureManager(controller);
    await controller.removeAllModels(fromManager: manager);
    await controller.addModel(_buildModel(), toManager: manager);
    await _focus(controller);
    _setState(state.copyWith(isAdded: true, isBusy: false));
  });

  Future<void> removeModel() => _run((controller) async {
    final manager = _manager;
    if (manager != null) {
      await controller.removeAllModels(fromManager: manager);
    }
    _setState(state.copyWith(isAdded: false, isBusy: false));
  });

  Future<void> focusModel() => _run((controller) async {
    await _focus(controller);
    _setState(state.copyWith(isBusy: false));
  });

  Future<void> setPolygonsVisible({required bool value}) => _run((controller) async {
    _setState(state.copyWith(arePolygonsVisible: value));
    await _renderDistrictPolygons(controller);
    _setState(state.copyWith(isBusy: false));
  });

  Future<void> setPolygonColorMode({required DebugDistrictPolygonColorMode mode}) => _run((controller) async {
    if (state.polygonColorMode == mode) {
      _setState(state.copyWith(isBusy: false));
      return;
    }
    _setState(state.copyWith(
      polygonColorMode: mode,
      polygonColorModeOverrides: const {},
    ));
    await _renderDistrictPolygons(controller);
    _setState(state.copyWith(isBusy: false));
  });

  Future<void> cyclePolygonColorMode({required String polygonId}) => _run((controller) async {
    final currentMode = state.polygonColorModeOverrides[polygonId] ?? state.polygonColorMode;
    final nextMode = currentMode.next;
    final overrides = Map<String, DebugDistrictPolygonColorMode>.of(state.polygonColorModeOverrides);
    if (nextMode == state.polygonColorMode) {
      overrides.remove(polygonId);
    } else {
      overrides[polygonId] = nextMode;
    }
    _setState(state.copyWith(polygonColorModeOverrides: overrides));
    await _renderDistrictPolygons(controller);
    _setState(state.copyWith(isBusy: false));
  });

  /// Marks a polygon as captured (i.e. the player scored a goal at this
  /// district's arena) and renders it on the map in the selected team's color.
  Future<void> capturePolygon({required String polygonId}) => _run((controller) async {
    if (state.capturedPolygonIds.contains(polygonId)) {
      _setState(state.copyWith(isBusy: false));
      return;
    }
    final captured = {...state.capturedPolygonIds, polygonId};
    _setState(state.copyWith(capturedPolygonIds: captured));
    await _renderDistrictPolygons(controller);
    _setState(state.copyWith(isBusy: false));
  });

  Future<void> setCentroidModelsVisible({required bool value}) => _run((controller) async {
    final manager = await _ensureDistrictLayerManager(controller);
    if (value) {
      await controller.removeAllModels(fromManager: manager);
      await controller.addModels(_buildDistrictCentroidModels(), toManager: manager);
    } else {
      await controller.removeAllModels(fromManager: manager);
    }

    _setState(state.copyWith(areCentroidModelsVisible: value, isBusy: false));
  });

  Future<void> focusDistrictPolygons() => _run((controller) async {
    await _focusDistrictPolygons(controller);
    _setState(state.copyWith(isBusy: false));
  });

  Future<void> removeDistrictLayerObjects() => _run((controller) async {
    final manager = _districtLayerManager;
    if (manager != null) {
      await controller.removeAllPolygons(fromManager: manager);
      await controller.removeAllModels(fromManager: manager);
    }

    _setState(
      state.copyWith(
        arePolygonsVisible: false,
        areCentroidModelsVisible: false,
        capturedPolygonIds: const {},
        isBusy: false,
      ),
    );
  });

  Future<void> _run(Future<void> Function(DgisMapController controller) action) async {
    if (state.isBusy) {
      return;
    }

    _setState(state.copyWith(isBusy: true));

    try {
      final controller = await ref.read(dgisControllerProvider.future);
      await action(controller);
    } catch (error, stackTrace) {
      logger.log('Debug 3D model error: $error\n$stackTrace');
      _setState(state.copyWith(isBusy: false, error: error.toString()));
    }
  }

  Future<MapObjectManagerMessage> _ensureManager(DgisMapController controller) async {
    final existing = _manager;
    if (existing != null) {
      return existing;
    }

    final manager = await controller.createMapObjectManager(layerId: MapObjectLayers.defaultLayerId);
    _manager = manager;
    return manager;
  }

  Future<MapObjectManagerMessage> _ensureDistrictLayerManager(DgisMapController controller) async {
    final existing = _districtLayerManager;
    if (existing != null) {
      return existing;
    }

    final manager = await controller.createMapObjectManager(layerId: MapObjectLayers.defaultLayerId);
    _districtLayerManager = manager;
    return manager;
  }

  ModelMapObject _buildModel() => ModelMapObject(
    id: debug3dModelId,
    options: ModelMapObjectOptionsMessage(
      position: GeoPointWithElevationMessage(
        latitude: debug3dModelLatitude,
        longitude: debug3dModelLongitude,
        elevation: 1,
      ),
      modelPath: debug3dModelPath,
      size: LogicalPixelModelSize(140),
      mapDirection: MapDirectionMessage(degree: 0),
      opacity: 1,
      zIndex: 100,
    ),
  );

  Future<void> _focus(DgisMapController controller) => controller.moveCamera(
    CameraPositionMessage(
      point: GeoPointMessage(latitude: debug3dModelLatitude, longitude: debug3dModelLongitude),
      zoom: 18,
      tilt: 65,
      bearing: 0,
    ),
    0.3,
    CameraAnimationTypeMessage.linear,
  );

  Future<void> _focusDistrictPolygons(DgisMapController controller) => controller.moveCamera(
    CameraPositionMessage(
      point: GeoPointMessage(latitude: debugDistrictCameraLatitude, longitude: debugDistrictCameraLongitude),
      zoom: 12,
      tilt: 45,
      bearing: 0,
    ),
    0.3,
    CameraAnimationTypeMessage.linear,
  );

  List<Polygon> _buildDistrictPolygons(
    DebugDistrictPolygonColorMode colorMode,
    Map<String, DebugDistrictPolygonColorMode> colorModeOverrides, {
    Set<String>? onlyIds,
  }) => [
    for (var index = 0; index < debugDistrictPolygons.length; index++)
      if (onlyIds == null ||
          onlyIds.contains(debugDistrictPolygons[index].id))
        _buildDistrictPolygon(index, colorMode, colorModeOverrides),
  ];

  /// Maps a [TifoTeam] to its closest polygon color mode. Used to paint
  /// captured polygons in the player's team color.
  DebugDistrictPolygonColorMode _teamColorMode(TifoTeam? team) {
    switch (team) {
      case TifoTeam.alHilal:
        return DebugDistrictPolygonColorMode.blue;
      case TifoTeam.alNassr:
        return DebugDistrictPolygonColorMode.amber;
      case TifoTeam.riyadhFc:
        return DebugDistrictPolygonColorMode.red;
      case TifoTeam.alShabab:
        return DebugDistrictPolygonColorMode.gray;
      case null:
        return state.polygonColorMode;
    }
  }

  /// Single source of truth for what polygons to render. Three cases:
  ///   * [arePolygonsVisible] = true  → all polygons (manual debug view);
  ///     captured ones still get the team color override.
  ///   * captures non-empty → only captured polygons, team-colored.
  ///   * otherwise → nothing.
  Future<void> _renderDistrictPolygons(DgisMapController controller) async {
    final manager = await _ensureDistrictLayerManager(controller);
    await controller.removeAllPolygons(fromManager: manager);

    final captured = state.capturedPolygonIds;
    if (!state.arePolygonsVisible && captured.isEmpty) {
      return;
    }

    final teamMode = _teamColorMode(ref.read(tifoFlowProvider).selectedTeam);
    final overrides = <String, DebugDistrictPolygonColorMode>{
      ...state.polygonColorModeOverrides,
      // Captures win over manual color overrides for that polygon.
      for (final id in captured) id: teamMode,
    };

    final polygons = _buildDistrictPolygons(
      state.polygonColorMode,
      overrides,
      onlyIds: state.arePolygonsVisible ? null : captured,
    );
    if (polygons.isNotEmpty) {
      await controller.addPolygons(polygons, toManager: manager);
    }
  }

  Polygon _buildDistrictPolygon(
    int index,
    DebugDistrictPolygonColorMode baseColorMode,
    Map<String, DebugDistrictPolygonColorMode> colorModeOverrides,
  ) {
    final polygon = debugDistrictPolygons[index];
    final colorMode = colorModeOverrides[polygon.id] ?? baseColorMode;

    return Polygon(
      id: polygon.id,
      options: PolygonOptionsMessage(
        contours: [
          PolylineGeometryMessage(
            points: [
              for (final point in polygon.ring)
                GeoPointMessage(
                  latitude: point.latitude,
                  longitude: point.longitude,
                ),
            ],
          ),
        ],
        color: _debugDistrictPolygonFillArgb(index, colorMode),
        strokeColor: _debugDistrictPolygonStrokeArgb(index, colorMode),
        strokeWidth: 2,
      ),
    );
  }

  List<ModelMapObject> _buildDistrictCentroidModels() => [
    for (var index = 0; index < debugDistrictPolygons.length; index++)
      ModelMapObject(
        id: '${debugDistrictPolygons[index].id}-centroid-model',
        options: ModelMapObjectOptionsMessage(
          position: GeoPointWithElevationMessage(
            latitude: debugDistrictPolygons[index].centroid.latitude,
            longitude: debugDistrictPolygons[index].centroid.longitude,
            elevation: 1,
          ),
          modelPath: _debugDistrictModelPath(index),
          size: LogicalPixelModelSize(100),
          mapDirection: MapDirectionMessage(degree: 0),
          opacity: 1,
          zIndex: 101,
        ),
        onTap: () => _launchPenaltyForPolygon(debugDistrictPolygons[index].id),
      ),
  ];

  void _launchPenaltyForPolygon(String polygonId) {
    final navigator = rootNavigatorKey.currentState;
    if (navigator == null) {
      return;
    }
    unawaited(
      navigator.push<void>(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (_) => PenaltyEntryScreen(polygonId: polygonId),
        ),
      ),
    );
  }

  /// Flips the debug "game mode" flag.
  ///
  /// On activation:
  ///  - sets [Debug3DModelState.isGameModeActive] (drives [TifoBallButton]
  ///    visibility on the dashboard),
  ///  - pushes the [TifoLaunchScreen] then [TifoOnboardingScreen] as a
  ///    one-shot intro (fire-and-forget),
  ///  - drops 3D "arena" models at every district centroid. Polygons are
  ///    NOT shown — they only appear per-district once the player scores
  ///    a goal at that arena (see [capturePolygon]).
  ///
  /// On deactivation: hides the arenas, clears all captures (so the next
  /// activation starts fresh), and re-renders the polygon layer.
  Future<void> setGameModeActive({required bool value}) async {
    if (value == state.isGameModeActive) {
      return;
    }
    _setState(state.copyWith(isGameModeActive: value));

    if (value) {
      final navigator = rootNavigatorKey.currentState;
      if (navigator != null) {
        unawaited(
          navigator
              .push<void>(
                MaterialPageRoute<void>(
                  fullscreenDialog: true,
                  builder: (_) => const TifoLaunchScreen(),
                ),
              )
              .then((_) {
            // Chain onboarding only if game mode is still active —
            // otherwise the user already turned it off via debug.
            if (!state.isGameModeActive) {
              return;
            }
            final nav = rootNavigatorKey.currentState;
            if (nav == null) {
              return;
            }
            unawaited(
              nav.push<void>(
                MaterialPageRoute<void>(
                  fullscreenDialog: true,
                  builder: (_) => const TifoOnboardingScreen(),
                ),
              ),
            );
          }),
        );
      }
      await setCentroidModelsVisible(value: true);
    } else {
      // Drop arena models and wipe any captures from the previous session.
      await setCentroidModelsVisible(value: false);
      _setState(state.copyWith(capturedPolygonIds: const {}));
      await _run((controller) async {
        await _renderDistrictPolygons(controller);
        _setState(state.copyWith(isBusy: false));
      });
    }
  }

  Future<void> _disposeManager() async {
    final controller = activeDgisController;
    if (controller == null) {
      return;
    }

    try {
      final manager = _manager;
      if (manager != null) {
        await controller.removeAllModels(fromManager: manager);
        await controller.removeMapObjectManager(manager);
      }

      final districtLayerManager = _districtLayerManager;
      if (districtLayerManager != null) {
        await controller.removeAllPolygons(fromManager: districtLayerManager);
        await controller.removeAllModels(fromManager: districtLayerManager);
        await controller.removeMapObjectManager(districtLayerManager);
      }
    } catch (error, stackTrace) {
      logger.log('Debug 3D model dispose error: $error\n$stackTrace');
    }
  }

  void _setState(Debug3DModelState value) {
    if (!_isDisposed) {
      state = value;
    }
  }
}

class DebugDistrictPolygon {
  const DebugDistrictPolygon({
    required this.id,
    required this.centroid,
    required this.ring,
  });

  final String id;
  final DebugGeoPoint centroid;
  final List<DebugGeoPoint> ring;
}

class DebugGeoPoint {
  const DebugGeoPoint({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
}
