import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';

DarkMapStateModel _model(bool isDark) =>
    DarkMapStateModel(isDark: isDark, currentMapMode: DarkMapStateEnum.asInASystem);

void main() {
  group('shouldApplyDarkModeChange (BALADY-3961)', () {
    test('a loading emission is ignored', () {
      expect(
        shouldApplyDarkModeChange(const AsyncLoading<DarkMapStateModel>(), appliedIsDark: false),
        isFalse,
      );
    });

    test('data with the same isDark is ignored', () {
      final next = AsyncData(_model(false));
      expect(shouldApplyDarkModeChange(next, appliedIsDark: false), isFalse);
    });

    test('data with a flipped isDark triggers a re-apply', () {
      final next = AsyncData(_model(true));
      expect(shouldApplyDarkModeChange(next, appliedIsDark: false), isTrue);
    });

    test('loading with a carried-over previous value is still ignored', () {
      final previous = AsyncData(_model(false));
      // copyWithPrevious is @internal, but it's exactly the shape
      // ref.invalidateSelf() produces mid-resume — no public equivalent.
      // ignore: invalid_use_of_internal_member
      final next = const AsyncLoading<DarkMapStateModel>().copyWithPrevious(previous);
      expect(next.isLoading, isTrue);
      expect(shouldApplyDarkModeChange(next, appliedIsDark: false), isFalse);
    });
  });
}
