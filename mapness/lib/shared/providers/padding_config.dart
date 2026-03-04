import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/poi_card/domain/model/poi_padding_config.dart';
import 'package:mapness/features/poi_card/domain/model/poi_sheet_sizes.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_map_controls.dart';
import 'package:mapness/shared/extensions/polygon_contiurs_ext.dart';
import 'package:mapness/shared/lib/custom_rect.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/media_query.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vector_math/vector_math.dart' as algebra;

part 'padding_config.g.dart';

@riverpod
class _PoiPaddingConfig extends _$PoiPaddingConfig {
  @override
  Future<void>? build(
    GeoPointWithElevationMessage? markerPosition,
    LatLng? closestPoint,
    PoiCameraConfig? cameraConfig,
  ) async {
    final dgisController = ref.watch(dgisControllerProvider);

    final mediaQuery = ref.read(mediaQueryInfoProvider);

    final sizeOfScreen = mediaQuery?.size;
    final safeArea = mediaQuery?.padding;
    const horizontalPadding = PoiCardMapControls.horizontalPadding + Markers.defaultWidth + MapButton.defaultSize;

    PoiSheetSizes? sheetSizes;
    EdgeInsets? paddingOfCamera;
    if (sizeOfScreen != null) {
      sheetSizes = PoiSheetSizes.poiCard(sizeOfScreen: sizeOfScreen);
      paddingOfCamera = EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: Markers.defaultHeight + (safeArea?.top ?? 0),
        // Calculate the bottom padding for the camera, use multiplier to calculate the padding
        bottom: (PoiCardMapControls.bottomPadding + sheetSizes.collapsedHeight * 1.5) + 10,
      );
    }

    final paddingConfig = PoiPaddingConfig(paddingOfCamera: paddingOfCamera, sizeOfScreen: sizeOfScreen);

    final position = closestPoint ??
        (markerPosition == null
            ? null
            : LatLng(latitude: markerPosition.latitude, longitude: markerPosition.longitude));

    if (position == null) {
      return;
    }

    final markerPoint = GeoPointMessage(latitude: position.latitude, longitude: position.longitude);

    final cameraData = ref.read(cameraPositionProvider) ?? await dgisController.value?.getCameraPosition();

    final cameraZoom = cameraData?.zoom;
    final cameraTilt = cameraData?.tilt;
    final point = cameraData?.point;
    final bearing = cameraData?.bearing;
    final newPoint = point;

    final cameraPosition = ref.read(cameraPositionProvider.notifier);

    // Normalize camera tilt to calculate the viewports
    if (cameraData != null && cameraData.tilt != 0) {
      await cameraPosition.animateTo(
        CameraPositionMessage(point: cameraData.point, zoom: cameraZoom ?? 17, tilt: 0, bearing: bearing ?? 0),
      );
    }

    // Get viewports: visible (whole screen) and tappable (area of the screen where marker will not overlap on other elements)
    CustomRect? visibleRect;
    final dgisControllerValue = dgisController.value;
    if (dgisControllerValue != null) {
      final visibleArea = await ref.read(dgisControllerProvider.notifier).getVisibleArea(dgisControllerValue);
      visibleRect = CustomRect.fromArea(area: visibleArea.areaContour(), center: markerPoint, bearing: bearing ?? 0.0);
    }

    final tappableRect = _getRectWithPaddings(visibleRect, paddingConfig);

    // Check if point is in viewport
    final isInViewZone = _isInRectZone(visibleRect, markerPoint);

    // Check if point is in tappable zone
    final isInTappableZone = _isInRectZone(tappableRect, markerPoint);

    final cameraHaveToBeMoved = isInViewZone && !isInTappableZone;

    if (cameraHaveToBeMoved && newPoint != null && tappableRect != null) {
      final p = _movePoint(markerPoint, tappableRect);
      final newLat = newPoint.latitude - p.y;
      final newLon = newPoint.longitude - p.x;
      newPoint
        ..latitude = newLat
        ..longitude = newLon;
    }

    // If point is in view zone, we do nothing or we slightly move to point of the camera if needed
    // Else we animate to marker point (we will see the marker on the screen and the camera will be centered on it)
    // If you want to center the map, you must pass the zoom value to PoiCameraConfig
    final cameraPoint = isInViewZone && newPoint != null && cameraConfig?.zoom == null ? newPoint : markerPoint;

    // Act like 2GIS app: if point is in view zone, we do:
    // a) slightly animate to point if it's not in tappable zone but in view zone
    // b) tilt set to 0 in all cases
    // c) zoom set to 17 if point is not in view zone or if zoom is not set
    // d) bearing set to 0 if not set

    await cameraPosition.animateTo(
      CameraPositionMessage(
        point: cameraPoint,
        zoom: isInViewZone ? cameraZoom ?? 16 : cameraConfig?.zoom ?? 16,
        tilt: (isInViewZone ? cameraTilt : cameraConfig?.tilt) ?? 0,
        bearing: bearing ?? 0,
      ),
    );
  }
}

final paddingConfigProvider = _poiPaddingConfigProvider;

/// Check if the point is in the rectangle
bool _isInRectZone(CustomRect? rect, GeoPointMessage markerPoint) {
  if (rect == null) {
    return false;
  }

  // Vectors of rectangle sides
  final p1P2 = algebra.Vector2(
    rect.topRight.latitude - rect.topLeft.latitude,
    rect.topRight.longitude - rect.topLeft.longitude,
  );
  final p2P3 = algebra.Vector2(
    rect.bottomRight.latitude - rect.topRight.latitude,
    rect.bottomRight.longitude - rect.topRight.longitude,
  );
  final p3P4 = algebra.Vector2(
    rect.bottomLeft.latitude - rect.bottomRight.latitude,
    rect.bottomLeft.longitude - rect.bottomRight.longitude,
  );
  final p4P1 = algebra.Vector2(
    rect.topLeft.latitude - rect.bottomLeft.latitude,
    rect.topLeft.longitude - rect.bottomLeft.longitude,
  );

  // Vectors from rectangle points to point
  final p1marker = algebra.Vector2(
    markerPoint.latitude - rect.topLeft.latitude,
    markerPoint.longitude - rect.topLeft.longitude,
  );
  final p2marker = algebra.Vector2(
    markerPoint.latitude - rect.topRight.latitude,
    markerPoint.longitude - rect.topRight.longitude,
  );
  final p3marker = algebra.Vector2(
    markerPoint.latitude - rect.bottomRight.latitude,
    markerPoint.longitude - rect.bottomRight.longitude,
  );
  final p4marker = algebra.Vector2(
    markerPoint.latitude - rect.bottomLeft.latitude,
    markerPoint.longitude - rect.bottomLeft.longitude,
  );

  // Compute cross products: For each side of the rectangle, compute the cross product between the side vector and the vector to the point
  final cross1 = p1P2.cross(p1marker);
  final cross2 = p2P3.cross(p2marker);
  final cross3 = p3P4.cross(p3marker);
  final cross4 = p4P1.cross(p4marker);

  // Check the signs:
  // - If all the cross products have the same sign (either all positive or all negative), then the point is inside the rectangle.
  // - If the signs are mixed, the point lies outside the rectangle.

  return (cross1.sign + cross2.sign + cross3.sign + cross4.sign).abs() == 4;
}

/// Create the rectangle from the area with paddings
CustomRect? _getRectWithPaddings(CustomRect? rect, PoiPaddingConfig? paddingConfig) {
  if (rect == null) {
    return null;
  }
  final paddingOfCamera = paddingConfig?.paddingOfCamera;
  final sizeOfScreen = paddingConfig?.sizeOfScreen;
  if (sizeOfScreen == null || paddingOfCamera == null) {
    return rect;
  }
  final paddingInPixels = paddingOfCamera;
  final paddingInPercents = EdgeInsets.only(
    left: paddingInPixels.left / sizeOfScreen.width,
    right: paddingInPixels.right / sizeOfScreen.width,
    top: paddingInPixels.top / sizeOfScreen.height,
    bottom: paddingInPixels.bottom / sizeOfScreen.height,
  );

  /// A rotated rectangle is defined by its four corners, say P1(x_1, y_1), P2(x_2, y_2), P3(x_3, y_3), P4(x_4, y_4).
  /// Determine the Direction Vectors
  /// Calculate the direction vectors for each side of the rectangle:
  final fromLeft =
      algebra.Vector2(
        rect.topRight.latitude - rect.topLeft.latitude,
        rect.topRight.longitude - rect.topLeft.longitude,
      ) *
      paddingInPercents.left;
  final fromTop =
      algebra.Vector2(
        rect.bottomRight.latitude - rect.topRight.latitude,
        rect.bottomRight.longitude - rect.topRight.longitude,
      ) *
      paddingInPercents.top;
  final fromRight =
      algebra.Vector2(
        rect.bottomLeft.latitude - rect.bottomRight.latitude,
        rect.bottomLeft.longitude - rect.bottomRight.longitude,
      ) *
      paddingInPercents.right;
  final fromBottom =
      algebra.Vector2(
        rect.topLeft.latitude - rect.bottomLeft.latitude,
        rect.topLeft.longitude - rect.bottomLeft.longitude,
      ) *
      paddingInPercents.bottom;

  // Apply the Offsets
  // Now, subtract the calculated offsets from the corresponding points:
  final topLeft = GeoPointMessage(
    latitude: rect.topLeft.latitude + fromLeft.x + fromTop.x,
    longitude: rect.topLeft.longitude + fromLeft.y + fromTop.y,
  );
  final topRight = GeoPointMessage(
    latitude: rect.topRight.latitude + fromRight.x + fromTop.x,
    longitude: rect.topRight.longitude + fromRight.y + fromTop.y,
  );
  final bottomRight = GeoPointMessage(
    latitude: rect.bottomRight.latitude + fromRight.x + fromBottom.x,
    longitude: rect.bottomRight.longitude + fromRight.y + fromBottom.y,
  );
  final bottomLeft = GeoPointMessage(
    latitude: rect.bottomLeft.latitude + fromLeft.x + fromBottom.x,
    longitude: rect.bottomLeft.longitude + fromLeft.y + fromBottom.y,
  );

  return CustomRect(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft);
}

/// Resulting vector to move the point to the edge of the rect
algebra.Vector2 _movePoint(GeoPointMessage point, CustomRect innerRect) {
  final listOfPoints = [innerRect.topLeft, innerRect.topRight, innerRect.bottomRight, innerRect.bottomLeft];
  var vectorFinal = algebra.Vector2(0, 0);

  for (var i = 0; i < listOfPoints.length; i++) {
    // Top, right, bottom, left
    final vector2 = _getFromSideVector(
      point,
      listOfPoints[i % listOfPoints.length],
      listOfPoints[(i + 1) % listOfPoints.length],
      listOfPoints[(i + 2) % listOfPoints.length],
    );
    vectorFinal += vector2 ?? algebra.Vector2(0, 0);
  }

  return vectorFinal;
}

/// Get the vector to move the point from the current position to the edge of the rect
/// If the point is inside the rect, return null
///
/// The main idea is to calculate the cross product of the base line, get the sin(a) value
/// and then calculate the length of the vector to move the point to the edge of the rect
///
/// Here we assume that ABC points are listed in clockwise order. It is important to cross product sign and
/// conclusions that we make based on it.
///
/// Example:
/// A - top left = (0, 5)
/// B - top right = (5, 5)
/// C - bottom right = (5, 0)
/// P - point = (2, 7)
/// P' - the point that we are looking for
///
/// The point is outside the rect, so we have to move it to the top side in vector (0, -2)
///
/// \vec{AB} = (5, 5) - (0, 5) = (5, 0)
/// \vec{BC} = (5, 0) - (5, 5) = (0, -5) => \vec{n} = (0, -1) - the direction in which we will move the point
/// \vec{AP} = (2, 7) - (0, 5) = (2, 2)
///
/// \vec{AB} x \vec{AP} = ||AB|| * ||AP|| * sin(AB, AP) = AB_x * AP_y - AB_y * AP_x = 5 * 2 - 0 * 2 = 10
/// sin(AB, AP) = 10 / (5 * sqrt(2^2 + 2^2)) = 0.7071067811865475
///
/// PP' - is the opposite side of a right triangle, AP - hypotenuse
/// PP' = ||AP|| * sin(AB, AP) = 2 * 0.7071067811865475 = 1.414213562373095
///
/// So vector to move is:
/// \vec{n} * PP' = (0, -1) * 1.414213562373095 = (0, -1.414213562373095)
algebra.Vector2? _getFromSideVector(
  GeoPointMessage point,
  GeoPointMessage pointA,
  GeoPointMessage pointB,
  GeoPointMessage pointC,
) {
  // This factor is used to increase the precision of the calculations. If we use the original values, the result will
  // be close to zero and very similar to the accuracy error.
  const factor = 10000.0;

  // 1. Calculate vectors
  // Base vector that represents side of the rect. \vec{AB}
  final baseVector = algebra.Vector2(
    pointB.longitude * factor - pointA.longitude * factor,
    pointB.latitude * factor - pointA.latitude * factor,
  );
  // If we have to move the point, then in this direction. \vec{BC}
  final n = algebra.Vector2(
    pointC.longitude * factor - pointB.longitude * factor,
    pointC.latitude * factor - pointB.latitude * factor,
  ).normalized();
  // Vector from A to point
  final toPointVector = algebra.Vector2(
    point.longitude * factor - pointA.longitude * factor,
    point.latitude * factor - pointA.latitude * factor,
  );
  final toPointVector2 = algebra.Vector2(point.longitude - pointA.longitude, point.latitude - pointA.latitude);
  // 2. Calculate the sin value
  // Cross product. AB x AP = ||AB|| * ||AP|| * sin(AB, AP)
  final crossProduct = baseVector.cross(toPointVector);

  final sinValue = crossProduct / (toPointVector.length * baseVector.length);
  // If the point is to the n direction of the base line, then we don't have to move it to the n direction
  if (crossProduct > 0) {
    final l = toPointVector2.length * sinValue;
    return n * l;
  }
  return null;
}
