import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/shared/providers/map/cursors_sheet_visibility_provider.dart';

/// BALADY-3960: a repeated cursor tap must still reach the sheet, and the
/// reset must be safe from any close path, even after the provider is gone.
void main() {
  late ProviderContainer container;
  late List<(bool?, bool)> notifications;
  late ProviderSubscription<bool> subscription;

  CursorsSheetVisibility notifier() => container.read(cursorsSheetVisibilityProvider.notifier);

  setUp(() {
    container = ProviderContainer();
    notifications = [];
    subscription = container.listen(cursorsSheetVisibilityProvider, (prev, next) => notifications.add((prev, next)));
  });

  tearDown(() => container.dispose());

  test('requestOpen raises the flag, and notifies again while it is already up', () {
    notifier().requestOpen();
    notifier().requestOpen();

    expect(container.read(cursorsSheetVisibilityProvider), isTrue);
    expect(notifications, [(false, true), (true, true)]);
  });

  test('settleClosed resets the flag once and is a no-op when already down', () {
    notifier()
      ..requestOpen()
      ..settleClosed()
      ..settleClosed();

    expect(container.read(cursorsSheetVisibilityProvider), isFalse);
    expect(notifications, [(false, true), (true, false)]);
  });

  test('settleClosed after the provider was disposed does not throw', () async {
    final stale = notifier()..requestOpen();
    subscription.close();
    await container.pump();
    expect(container.exists(cursorsSheetVisibilityProvider), isFalse);

    expect(stale.settleClosed, returnsNormally);
  });
}
