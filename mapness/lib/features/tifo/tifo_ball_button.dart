import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/tifo/tifo_flow_provider.dart';
import 'package:mapness/features/tifo/tifo_tutorial.dart';
import 'package:mapness/shared/providers/map/debug_3d_model.dart';
import 'package:mapness/shared/utils/detach.dart';

/// Floating circular green button with the ⚽ emoji.
///
/// Source: Figma `dashboard (active)` node `1:8331` (Tifo file).
///
/// Tap behavior:
///  * If the user finished team selection and hasn't seen the in-game
///    tutorial yet → push [TifoTutorial] and mark it seen.
///  * Otherwise → focus the map on the TIFO district polygons via
///    [Debug3DModelController.focusDistrictPolygons].
class TifoBallButton extends ConsumerWidget {
  const TifoBallButton({super.key});

  static const double size = 56;
  static const Color _bg = Color(0xFF16A34A);
  static const Color _emojiColor = Color(0xFF0A0A0A);

  void _handleTap(WidgetRef ref) {
    final flow = ref.read(tifoFlowProvider);
    if (flow.shouldPlayTutorial) {
      final navigator = rootNavigatorKey.currentState;
      if (navigator == null) return;
      ref.read(tifoFlowProvider.notifier).markTutorialSeen();
      detach(
        navigator.push<void>(
          PageRouteBuilder<void>(
            opaque: false,
            barrierColor: Colors.black.withOpacity(0.55),
            barrierDismissible: true,
            pageBuilder: (_, __, ___) => const TifoTutorial(),
            transitionsBuilder: (_, anim, __, child) => SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: anim,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            ),
          ),
        ),
        tag: 'tifoBallButton.animate',
      );
      return;
    }
    detach(
      ref.read(debug3dModelProvider.notifier).focusDistrictPolygons(),
      tag: 'tifoBallButton.focusDistrictPolygons',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Semantics(
    button: true,
    label: 'Focus TIFO districts',
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _handleTap(ref),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _bg,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _bg.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Text(
          '⚽',
          style: TextStyle(
            fontSize: 26,
            height: 1.0,
            color: _emojiColor,
          ),
        ),
      ),
    ),
  );
}
