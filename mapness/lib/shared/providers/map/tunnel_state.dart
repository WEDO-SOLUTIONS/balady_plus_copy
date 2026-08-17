import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
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
  DgisMapController? _controller;

  @override
  bool build() {
    // `listen`, not a one-shot `read`: a MapView recreate (car-model swap —
    // see [MapRecreationCounter]) invalidates `dgisControllerProvider` and
    // builds a brand-new DgisMapController. This provider is keepAlive and so
    // never rebuilds on its own; a `read` would leave it holding the dead
    // controller's stream for the rest of the process. Tunnel events would then
    // stop reaching `_themeChanged`, and the whole-app dark theme in tunnels
    // would quietly stop working until restart — invisibly, because the map
    // surface keeps re-theming natively either way.
    ref
      ..listen<AsyncValue<DgisMapController>>(dgisControllerProvider, (previous, next) {
        final controller = next.value;
        if (controller != null) {
          _attach(controller);
        } else if (next.hasError) {
          logger.log(
            '[tunnel_state] no map controller, tunnel theme stays off: ${next.error}',
            logLevel: MapnessLogLevel.error,
          );
        }
      }, fireImmediately: true)
      ..onDispose(_detach);

    return false;
  }

  void _attach(DgisMapController controller) {
    // A refreshing provider re-emits its previous value; only a genuinely new
    // controller warrants tearing the subscription down.
    if (identical(controller, _controller)) {
      return;
    }

    _detach();
    _controller = controller;
    // Guidance may already be inside a tunnel by the time we attach — both on
    // first read and when a recreate lands mid-tunnel.
    state = controller.isInTunnel;
    _subscription = controller.tunnelStateEvents.listen((event) => state = event.inTunnel);
  }

  void _detach() {
    _subscription?.cancel();
    _subscription = null;
    _controller = null;
  }
}
