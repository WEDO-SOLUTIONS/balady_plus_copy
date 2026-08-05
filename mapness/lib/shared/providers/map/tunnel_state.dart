import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tunnel_state.g.dart';

/// Whether guidance is currently running through a tunnel.
///
/// The map surface itself is re-themed natively (`TunnelDetector` in `dgis_map`, which
/// also serves CarPlay and Android Auto); this provider carries the same signal into
/// Flutter so the rest of the app can go dark with it.
///
/// Deliberately separate from `darkModeProvider`: that one is the user's persisted
/// day/night preference and feeds the metro, dynamic-POI and marker layers, which
/// reload their whole icon set whenever it flips — far too heavy to drive off a
/// stretch of tunnel.
@Riverpod(keepAlive: true)
class TunnelState extends _$TunnelState {
  StreamSubscription<TunnelStateEvent>? _subscription;

  @override
  bool build() {
    _initListener();

    return false;
  }

  Future<void> _initListener() async {
    final controller = await ref.read(dgisControllerProvider.future);

    // Guidance may already be inside a tunnel by the time this is first read.
    state = controller.isInTunnel;
    _subscription = controller.tunnelStateEvents.listen((event) => state = event.inTunnel);

    ref.onDispose(() => _subscription?.cancel());
  }
}
