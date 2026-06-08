import 'dart:async';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/map/debug_style_attributes.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

class DebugStyleAttributesPanel extends ConsumerWidget {
  const DebugStyleAttributesPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(debugStyleAttributesProvider);
    final notifier = ref.read(debugStyleAttributesProvider.notifier);
    final activeCount = [
      state.customVehicleMarkersOn,
      state.hasSelectedVehicleMarker,
    ].where((value) => value).length;

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DebugSectionHeader(
            icon: Icons.tune_rounded,
            title: 'Style Arguments',
            subtitle: 'Custom vehicle marker globals',
            gradient: DebugTheme.gradientBlue,
            trailing: DebugBadge(
              label: '$activeCount/2',
              color: DebugTheme.info,
              isActive: activeCount > 0,
            ),
          ),
          const SizedBox(height: 6),
          DebugToggleRow(
            title: 'Custom Vehicle Markers',
            subtitle: 'global customVehicleMarkersOn',
            value: state.customVehicleMarkersOn,
            onChanged: (value) => unawaited(notifier.setCustomVehicleMarkersOn(value: value)),
            gradient: DebugTheme.gradientBlue,
          ),
          const DebugDivider(),
          Text(
            'Vehicle Marker Type',
            style: context.textStyles.bodySmallMedium.copyWith(
              color: DebugTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final control in debugVehicleMarkerTypeControls)
                _MarkerTypeButton(
                  control: control,
                  isActive: state.vehicleMarkerType == control.value,
                  onPressed: () => unawaited(notifier.setVehicleMarkerType(control.value)),
                ),
            ],
          ),
          if (activeCount > 0) ...[
            const DebugDivider(),
            Align(
              alignment: Alignment.centerRight,
              child: DebugOutlinedButton(
                label: 'Reset',
                icon: Icons.restart_alt_rounded,
                color: DebugTheme.info,
                isCompact: true,
                onPressed: () => unawaited(notifier.resetAll()),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MarkerTypeButton extends StatelessWidget {
  const _MarkerTypeButton({
    required this.control,
    required this.isActive,
    required this.onPressed,
  });

  final DebugVehicleMarkerTypeControl control;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final icon = control.value.isEmpty ? Icons.block_rounded : Icons.directions_car_rounded;

    if (isActive) {
      return DebugButton(
        label: control.title,
        icon: icon,
        isCompact: true,
        gradient: DebugTheme.gradientBlue,
        onPressed: onPressed,
      );
    }

    return DebugOutlinedButton(
      label: control.title,
      icon: icon,
      isCompact: true,
      onPressed: onPressed,
    );
  }
}
