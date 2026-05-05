import 'package:mapness/features/dynamic_poi/dynamic_poi_visibility.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dynamic_poi_visibility_provider.g.dart';

/// Caches the dynamic-POI visibility config (zoom windows per geometry type).
/// Loaded once from Firebase Remote Config; falls back to
/// [DynamicPoiVisibility.fallback] on missing/malformed payload.
@Riverpod(keepAlive: true)
Future<DynamicPoiVisibility> dynamicPoiVisibilityConfig(Ref ref) =>
    DynamicPoiVisibility.load();
