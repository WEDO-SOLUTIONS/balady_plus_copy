import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cursors_sheet_visibility_provider.g.dart';

/// BALADY-3960: visibility of the non-modal `CursorsSheet`, mounted
/// permanently in the page Stack (same pattern as `ParkingAutoenabledSheet`)
/// instead of `showModalBottomSheet`, so no `ModalBarrier` blocks the map.
@riverpod
class CursorsSheetVisibility extends _$CursorsSheetVisibility {
  @override
  bool build() => false;

  // ignore: use_setters_to_change_properties
  void show({required bool value}) {
    state = value;
  }
}
