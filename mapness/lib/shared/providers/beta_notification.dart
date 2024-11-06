import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'beta_notification.g.dart';

@Riverpod(keepAlive: true)
class BetaNotification extends _$BetaNotification {
  @override
  bool build() => false;

  void setShown() {
    state = true;
  }
}
