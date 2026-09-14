import 'dart:async';

import 'package:mapness/shared/utils/logger/logger.dart';

/// Starts [future] without awaiting it, but - unlike a bare `unawaited(...)` -
/// never lets its error disappear.
///
/// A dropped `Future` whose error is never observed escapes to the enclosing
/// `Zone`. In debug that surfaces as a red screen; in release it is swallowed
/// silently and the only symptom is state that quietly stops updating. Both
/// failure modes are hard to trace back to the call site, which is why every
/// fire-and-forget call in this codebase must carry a [tag].
///
/// Use this only where awaiting is genuinely impossible - synchronous callbacks
/// such as `ref.listen`, `onTap`, `onDispose` or `Timer` handlers. Inside an
/// `async` body, prefer a plain `await`.
///
/// ```dart
/// ref.listen(busLayerVisibleProvider, (_, isShown) {
///   detach(isShown ? show() : hide(), tag: 'jeddahBus.toggle');
/// });
/// ```
void detach(
  Future<void> future, {
  required String tag,
}) {
  // This helper *is* the sanctioned drop point; the error is handled below.
  // ignore: discarded_futures
  future.catchError(
    (Object error, StackTrace stackTrace) {
      logger.log(
        'detached future "$tag" failed: $error\n$stackTrace',
        logLevel: MapnessLogLevel.error,
      );
    },
  );
}

/// [detach] for futures that produce a value which the caller does not need.
///
/// Mirrors [detach]; kept separate so the common `Future<void>` case is not
/// forced to spell out a type argument.
void detachValue<T>(
  Future<T> future, {
  required String tag,
}) {
  // ignore: discarded_futures
  future.then<void>(
    (_) {},
    onError: (Object error, StackTrace stackTrace) {
      logger.log(
        'detached future "$tag" failed: $error\n$stackTrace',
        logLevel: MapnessLogLevel.error,
      );
    },
  );
}
