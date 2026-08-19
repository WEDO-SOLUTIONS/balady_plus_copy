import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/tifo/data/tifo_debug_identity.dart';

/// Hive isn't available in a plain unit test, so persistence silently no-ops
/// (the controller swallows the failure by design) — the in-memory state
/// transitions are what these cover.
void main() {
  late ProviderContainer container;
  TifoDebugIdentityController controller() => container.read(tifoDebugIdentityProvider.notifier);
  TifoDebugIdentity state() => container.read(tifoDebugIdentityProvider);

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('starts on the host session', () {
    expect(state().isActive, isFalse);
    expect(state().savedIds, isEmpty);
  });

  test('using an id activates it and remembers it once', () async {
    await controller().use('tester-01');
    await controller().use('tester-02');
    await controller().use('tester-01');

    expect(state().isActive, isTrue);
    expect(state().userId, 'tester-01');
    // Most recent first, no duplicates.
    expect(state().savedIds, ['tester-01', 'tester-02']);
  });

  test('blank input is ignored', () async {
    await controller().use('   ');
    expect(state().isActive, isFalse);
    expect(state().savedIds, isEmpty);
  });

  test('the switch keeps the picked id so it can be flipped back', () async {
    await controller().use('tester-01');
    await controller().setEnabled(enabled: false);

    expect(state().isActive, isFalse);
    expect(state().userId, 'tester-01');

    await controller().setEnabled(enabled: true);
    expect(state().isActive, isTrue);
  });

  test('forgetting the active id falls back to the host session', () async {
    await controller().use('tester-01');
    await controller().forget('tester-01');

    expect(state().savedIds, isEmpty);
    expect(state().userId, isEmpty);
    expect(state().enabled, isFalse, reason: 'must not keep acting as a deleted user');
  });

  test('forgetting an inactive id leaves the active one alone', () async {
    await controller().use('tester-02');
    await controller().use('tester-01');
    await controller().forget('tester-02');

    expect(state().userId, 'tester-01');
    expect(state().isActive, isTrue);
    expect(state().savedIds, ['tester-01']);
  });
}
