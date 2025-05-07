import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'parking_autoenabled_sheet_provider.g.dart';

@riverpod
class ParkingAutoenabledSheet extends _$ParkingAutoenabledSheet {
  @override
  bool build() => false;

  // ignore: use_setters_to_change_properties
  void showParkingAutoEnableSheet({required bool value}) {
    if (value == true) {
      ref.read(pathNavEtaProvider.notifier).toggleIsExpanded(isExpanded: false);
    }
    state = value;
  }
}
