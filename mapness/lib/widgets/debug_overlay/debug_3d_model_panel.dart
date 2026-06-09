import 'dart:async';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
            label: 'Model',
            value: debugDistrictModelPath,
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
}
