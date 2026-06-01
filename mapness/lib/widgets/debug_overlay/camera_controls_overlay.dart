import 'dart:math' as math;

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/free_roam/camera_controls_overlay_provider.dart';
import 'package:mapness/widgets/debug_overlay/camera_controls_debug_panel.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

/// Translucent, on-map HUD mirroring the BE-193 camera-tuning controls so they can
/// be adjusted live while watching the map (e.g. during a navigation simulation).
/// Visibility is driven by [cameraControlsOverlayVisibleProvider], toggled from the
/// debug sheet. Designed to be a direct child of the `DebugOverlay` [Stack].
class CameraControlsOverlay extends ConsumerWidget {
  const CameraControlsOverlay({super.key});

  /// Overall translucency of the HUD so the map stays visible behind it.
  static const double _opacity = 0.82;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(cameraControlsOverlayVisibleProvider);
    if (!visible) {
      return const SizedBox.shrink();
    }

    final media = MediaQuery.of(context);
    final width = math.min(320.0, media.size.width * 0.86);

    return Positioned(
      top: media.padding.top + 12,
      right: 8,
      bottom: media.padding.bottom + 12,
      width: width,
      child: Opacity(
        opacity: _opacity,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            decoration: BoxDecoration(
              color: DebugTheme.background.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: DebugTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _OverlayHeader(
                  onClose: () => ref.read(cameraControlsOverlayVisibleProvider.notifier).hide(),
                ),
                const Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: CameraControlsDebugPanel(inOverlay: true),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OverlayHeader extends StatelessWidget {
  const _OverlayHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(14, 12, 8, 4),
    child: Row(
      children: [
        const Icon(Icons.videocam_rounded, color: DebugTheme.textSecondary, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Camera (live)',
            style: context.textStyles.bodySmallSemiBold.copyWith(color: DebugTheme.textPrimary),
          ),
        ),
        GestureDetector(
          onTap: onClose,
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(Icons.close_rounded, color: DebugTheme.textSecondary, size: 18),
          ),
        ),
      ],
    ),
  );
}
