import 'dart:async';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/tifo/data/tifo_debug_collider_overlay.dart';
import 'package:mapness/features/tifo/data/tifo_debug_color_override.dart';
import 'package:mapness/features/tifo/penalty/penalty_game.dart';
import 'package:mapness/shared/providers/map/debug_3d_model.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

class Debug3DModelPanel extends ConsumerWidget {
  const Debug3DModelPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(debug3dModelProvider);
    final notifier = ref.read(debug3dModelProvider.notifier);
    final activeCount = [
      state.isAdded,
      state.arePolygonsVisible,
      state.areCentroidModelsVisible,
    ].where((value) => value).length;

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DebugSectionHeader(
            icon: Icons.view_in_ar_rounded,
            title: '3D / Polygons',
            subtitle: 'Debug map objects',
            gradient: DebugTheme.gradientTeal,
            trailing: DebugBadge(
              label: '$activeCount/3',
              color: DebugTheme.success,
              isActive: activeCount > 0,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Fixed Model',
            style: context.textStyles.bodySmallMedium.copyWith(
              color: DebugTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const DebugInfoRow(
            label: 'Latitude',
            value: '$debug3dModelLatitude',
          ),
          const DebugInfoRow(
            label: 'Longitude',
            value: '$debug3dModelLongitude',
          ),
          const DebugInfoRow(
            label: 'Model',
            value: debug3dModelPath,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (state.isAdded)
                DebugOutlinedButton(
                  label: state.isBusy ? 'Removing...' : 'Remove',
                  icon: Icons.delete_outline_rounded,
                  color: DebugTheme.error,
                  isCompact: true,
                  onPressed: state.isBusy ? () {} : () => unawaited(notifier.removeModel()),
                )
              else
                DebugButton(
                  label: state.isBusy ? 'Adding...' : 'Add Model',
                  icon: Icons.add_location_alt_rounded,
                  gradient: DebugTheme.gradientTeal,
                  isCompact: true,
                  onPressed: state.isBusy ? () {} : () => unawaited(notifier.addModel()),
                ),
              DebugOutlinedButton(
                label: state.isBusy ? 'Focusing...' : 'Focus',
                icon: Icons.my_location_rounded,
                color: DebugTheme.info,
                isCompact: true,
                onPressed: state.isBusy ? () {} : () => unawaited(notifier.focusModel()),
              ),
            ],
          ),
          const DebugDivider(),
          Text(
            'District Polygons',
            style: context.textStyles.bodySmallMedium.copyWith(
              color: DebugTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          DebugInfoRow(
            label: 'Polygons',
            value: '${debugDistrictPolygons.length}',
          ),
          const DebugInfoRow(
            label: 'Models',
            value: debugDistrictModelPathsLabel,
          ),
          DebugInfoRow(
            label: 'Color',
            value: state.polygonColorMode.label,
            valueColor: Color(state.polygonColorMode.previewStrokeArgb),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final mode in DebugDistrictPolygonColorMode.values)
                _PolygonColorButton(
                  mode: mode,
                  isSelected: state.polygonColorMode == mode,
                  isBusy: state.isBusy,
                  onPressed: () => unawaited(notifier.setPolygonColorMode(mode: mode)),
                ),
            ],
          ),
          DebugToggleRow(
            title: 'Show Polygons',
            subtitle: 'GeoJSON overlay from pasted text',
            value: state.arePolygonsVisible,
            onChanged: (value) => unawaited(notifier.setPolygonsVisible(value: value)),
            gradient: DebugTheme.gradientTeal,
          ),
          DebugToggleRow(
            title: 'Centroid 3D Models',
            subtitle: 'One model in each polygon centroid',
            value: state.areCentroidModelsVisible,
            onChanged: (value) => unawaited(notifier.setCentroidModelsVisible(value: value)),
            gradient: DebugTheme.gradientTeal,
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              DebugOutlinedButton(
                label: state.isBusy ? 'Focusing...' : 'Focus Area',
                icon: Icons.center_focus_strong_rounded,
                color: DebugTheme.info,
                isCompact: true,
                onPressed: state.isBusy ? () {} : () => unawaited(notifier.focusDistrictPolygons()),
              ),
              if (state.hasDistrictLayerObjects)
                DebugOutlinedButton(
                  label: state.isBusy ? 'Clearing...' : 'Clear District Layer',
                  icon: Icons.layers_clear_rounded,
                  color: DebugTheme.error,
                  isCompact: true,
                  onPressed: state.isBusy ? () {} : () => unawaited(notifier.removeDistrictLayerObjects()),
                ),
            ],
          ),
          const DebugDivider(),
          Text(
            'Game mode',
            style: context.textStyles.bodySmallMedium.copyWith(
              color: DebugTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          DebugToggleRow(
            title: 'Activate TIFO',
            subtitle: 'Show the ⚽ FAB + gray polygons on the map',
            value: state.isGameModeActive,
            onChanged: (value) => unawaited(notifier.setGameModeActive(value: value)),
            gradient: DebugTheme.gradientTeal,
          ),
          const SizedBox(height: 8),
          DebugButton(
            label: 'Launch penalty game',
            icon: Icons.sports_soccer_rounded,
            gradient: DebugTheme.gradientTeal,
            isCompact: true,
            onPressed: () => _launchPenaltyGame(ref),
          ),
          if (state.error != null) ...[
            const DebugDivider(),
            Text(
              state.error!,
              style: context.textStyles.captionSmallRegular.copyWith(
                color: DebugTheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Debug-only shortcut: pushes [PenaltyApp] directly on the root navigator,
  /// bypassing every gate (team-select / tutorial / entry / polygon-tap) —
  /// including the building/club lookup in `building_sheet.dart` that
  /// normally resolves kit colors, so the "Kit colors" override in the TIFO
  /// Backend panel must be read here too or it silently does nothing on this
  /// shortcut.
  void _launchPenaltyGame(WidgetRef ref) {
    final navigator = rootNavigatorKey.currentState;
    if (navigator == null) return;
    final colorOverride = ref.read(tifoDebugColorOverrideProvider);
    final strikerColor = colorOverride.enabled ? colorOverride.strikerColor : null;
    final keeperColor = colorOverride.enabled ? colorOverride.keeperColor : null;
    final showColliderDebug = ref.read(tifoDebugColliderOverlayProvider);
    unawaited(
      navigator.push<void>(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (_) => PenaltyApp(
            strikerColor: strikerColor,
            keeperColor: keeperColor,
            showColliderDebug: showColliderDebug,
            onComplete: (_) {
              Future<void>.delayed(const Duration(milliseconds: 850), () {
                rootNavigatorKey.currentState?.pop();
              });
            },
          ),
        ),
      ),
    );
  }
}

class _PolygonColorButton extends StatelessWidget {
  const _PolygonColorButton({
    required this.mode,
    required this.isSelected,
    required this.isBusy,
    required this.onPressed,
  });

  final DebugDistrictPolygonColorMode mode;
  final bool isSelected;
  final bool isBusy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = Color(mode.previewStrokeArgb);
    if (isSelected) {
      return DebugButton(
        label: mode.label,
        icon: Icons.palette_rounded,
        gradient: LinearGradient(colors: [color, color.withOpacity(0.72)]),
        isCompact: true,
        onPressed: isBusy ? () {} : onPressed,
      );
    }

    return DebugOutlinedButton(
      label: mode.label,
      icon: Icons.circle_rounded,
      color: color,
      isCompact: true,
      onPressed: isBusy ? () {} : onPressed,
    );
  }
}
