import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dynamic_poi_selection_provider.g.dart';

/// Holds the id of the currently-selected dynamic POI, or `null` when none.
///
/// The selected POI renders in its `selected` visual state (brighter fill,
/// stronger stroke, recoloured glyph) — see `DynamicPoiMarkerBitmap`.
/// Selection is set by tapping a marker / polygon in
/// `DynamicPoiLayer._buildMarker.onTap`, and cleared:
///   - when the POI card is dismissed,
///   - on empty-area tap (`map_tap_handler_provider.dart`),
///   - implicitly, when a different dynamic POI is tapped (`select(newId)`).
@Riverpod(keepAlive: true)
class SelectedDynamicPoiId extends _$SelectedDynamicPoiId {
  @override
  String? build() => null;

  /// Replace the selected id. Pass `null` to clear. Explicit method name (not
  /// a setter) reads better at call sites and is consistent with other
  /// Riverpod notifiers in this package.
  // ignore: use_setters_to_change_properties
  void select(String? id) => state = id;
}
