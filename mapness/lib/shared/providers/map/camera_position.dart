import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_position.g.dart';

@Riverpod(keepAlive: true)
class CameraPosition extends _$CameraPosition {
  StreamSubscription? _cameraPositionSubscription;

  @override
  CameraPositionMessage? build() {
    final dgisController = ref.watch(dgisControllerProvider);
    _cameraPositionSubscription ??= dgisController.value?.cameraPositionEvents.listen(_cameraPositionListener);
    ref.onDispose(
      () {
        _cameraPositionSubscription?.cancel();
        _cameraPositionSubscription = null;
      },
    );

    return null;
  }

  Future<void> animateTo(CameraPositionMessage position) async {
    final dgisController = ref.read(dgisControllerProvider);

    await dgisController.value?.moveCamera(
      position,
      0.3,
      CameraAnimationTypeMessage.linear,
    );
  }

  Future<void> animateToRoute({
    CalcPositionOptionsMessage? options,
  }) async {
    final dgisController = ref.read(dgisControllerProvider);

    final position = await dgisController.value!.calcPositionForRoute(
      options ?? CalcPositionOptionsMessage(),
    );

    await dgisController.value!.moveCamera(
      position,
      0.3,
      CameraAnimationTypeMessage.linear,
    );
  }

  Future<void> animateToMarkers(
    List<Marker> markers, {
    CalcPositionOptionsMessage? options,
  }) async {
    final dgisController = ref.read(dgisControllerProvider);

    final position = await dgisController.value!.calcPositionForMarkers(
      markers.map((e) => e.id).toList(),
      options ?? CalcPositionOptionsMessage(),
    );

    await dgisController.value!.moveCamera(
      position,
      0.3,
      CameraAnimationTypeMessage.linear,
    );
  }

  Future<void> animateToPolygons(
    List<Polygon> polygons, {
    CalcPositionOptionsMessage? options,
  }) async {
    final dgisController = ref.watch(dgisControllerProvider).value;

    final position = await dgisController!.calcPositionForPolygons(
      polygons.map((e) => e.id).toList(),
      options ?? CalcPositionOptionsMessage(),
    );

    await dgisController.moveCamera(
      position,
      0.3,
      CameraAnimationTypeMessage.linear,
    );
  }

  Future<void> animateToRepresentativeArea(
    GeometryMessage area, {
    CalcPositionOptionsMessage? options,
  }) async {
    final dgisController = ref.read(dgisControllerProvider);

    await dgisController.value!.animateToRepresentativeArea(
      area,
      options ?? CalcPositionOptionsMessage(),
      0.3,
      CameraAnimationTypeMessage.linear,
    );
  }

  Future<void> animateToGeoPoints(
    List<GeoPointMessage> points, {
    CalcPositionOptionsMessage? options,
  }) async {
    final dgisController = ref.read(dgisControllerProvider);

    final position = await dgisController.value!.calcPositionForGeoPoints(
      points,
      options ?? CalcPositionOptionsMessage(),
    );

    await dgisController.value!.moveCamera(
      position,
      0.3,
      CameraAnimationTypeMessage.linear,
    );
  }

  Future<void> setPadding(CameraSetPaddingMessage padding) async {
    final dgisController = await ref.read(dgisControllerProvider.future);

    await dgisController.setCameraPadding(padding);
  }

  // ignore: use_setters_to_change_properties
  void _cameraPositionListener(CameraPositionMessage event) {
    state = event;
  }
}
