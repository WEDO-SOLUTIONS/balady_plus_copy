# urbi_map Notes

This subtree owns the Flutter/native map bridge packages.

## Session Context

- Indoor floor-plan visibility is exposed to Flutter via `setIndoorFloorPlansEnabled`.
- The Pigeon source is `dgis_map_platform_interface/pigeons/messages.dart`; generated outputs are produced by running `fvm dart pub run pigeon --input pigeons/messages.dart` from `urbi_map/dgis_map_platform_interface/`.
- The public Dart wrappers are `dgis_map_platform_interface/lib/src/dgis_map_plugin.dart` and `dgis_map/lib/dgis_map_controller.dart`.
- Android maps the bridge method to `map.indoorManager.setIndoorState(IndoorManagerState.ENABLED/DISABLED)`.
- iOS maps the bridge method to `map.indoorManager.setIndoorState(newState: .enabled/.disabled)`.
- Native `DgisMapView` implementations should handle calls before `IndoorControlHandler` is initialized by falling back to `map.indoorManager` directly.

## Verification

```bash
rtk fvm dart format -l 120 urbi_map/dgis_map_platform_interface/pigeons/messages.dart urbi_map/dgis_map_platform_interface/lib/src/dgis_map_plugin.dart urbi_map/dgis_map/lib/dgis_map_controller.dart
rtk fvm flutter analyze --no-pub lib/dgis_map_controller.dart
rtk fvm flutter analyze --no-pub pigeons/messages.dart lib/src/dgis_map_plugin.dart
```
