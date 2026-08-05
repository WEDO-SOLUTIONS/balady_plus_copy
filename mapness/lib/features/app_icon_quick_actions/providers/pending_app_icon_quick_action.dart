import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pending_app_icon_quick_action.g.dart';

class PendingAppIconQuickActionRequest {
  const PendingAppIconQuickActionRequest({
    required this.shortcutKey,
    this.isFirstRun = false,
  });

  final String shortcutKey;
  final bool isFirstRun;
}

/// Holds a shortcut tap when the app/router is not ready yet (cold start).
@Riverpod(keepAlive: true)
class PendingAppIconQuickAction extends _$PendingAppIconQuickAction {
  @override
  PendingAppIconQuickActionRequest? build() => null;

  void setPending(String shortcutKey, {bool isFirstRun = false}) {
    state = PendingAppIconQuickActionRequest(
      shortcutKey: shortcutKey,
      isFirstRun: isFirstRun,
    );
  }

  bool get hasPending => state != null;

  PendingAppIconQuickActionRequest? take() {
    final value = state;
    state = null;
    return value;
  }
}
