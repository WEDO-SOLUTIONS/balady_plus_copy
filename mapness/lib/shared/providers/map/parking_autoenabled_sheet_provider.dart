import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'parking_autoenabled_sheet_provider.g.dart';

@riverpod
class ParkingAutoenabledSheet extends _$ParkingAutoenabledSheet {
  @override
  bool build() => false;

  // ignore: use_setters_to_change_properties
  void showParkingAutoEnableSheet({required bool value}) {
    state = value;
  }
}
