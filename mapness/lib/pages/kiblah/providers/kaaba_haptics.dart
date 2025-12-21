import 'package:mapness/pages/kiblah/providers/kaaba_bearing.dart';
import 'package:mapness/shared/providers/compass.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vibration/vibration.dart';

part 'kaaba_haptics.g.dart';

@riverpod
class KaabaHaptics extends _$KaabaHaptics {
  @override
  bool build() {
    final kaabaBearing = ref.watch(kaabaBearingProvider);
    final userBearing = ref.watch(compassProvider);

    final correct =
        userBearing != null && kaabaBearing != null && (kaabaBearing.floor() - userBearing.floor()).abs() <= 5;

    if (correct && !(stateOrNull ?? true)) {
      Vibration.vibrate();
    }

    return correct;
  }
}
