import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

class BetterRouteSettingsWidget extends ConsumerWidget {
  const BetterRouteSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(betterRouteSettingsProvider).value;
    if (settings == null) {
      return const SizedBox.shrink();
    }

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DebugSectionHeader(
            icon: Icons.route_rounded,
            title: 'Better Route Settings',
            subtitle: 'Configure route optimization',
            gradient: DebugTheme.gradientGreen,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SettingsButton(
                  label: 'Prod',
                  isActive: settings == BetterRouteSettings.prod,
                  onPressed: () {
                    ref.read(betterRouteSettingsProvider.notifier).setSettings(BetterRouteSettings.prod);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SettingsButton(
                  label: 'Test',
                  isActive: settings == BetterRouteSettings.test,
                  onPressed: () {
                    ref.read(betterRouteSettingsProvider.notifier).setSettings(BetterRouteSettings.test);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: DebugTheme.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _SettingRow(
                  label: 'Search delay',
                  value: '${settings.routeSearchDelay} sec',
                ),
                _SettingRow(
                  label: 'Time threshold',
                  value: '${settings.betterRouteTimeCostThreshold} sec',
                ),
                _SettingRow(
                  label: 'Length threshold',
                  value: '${(settings.betterRouteLengthThreshold / 1000).toStringAsFixed(1)} km',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: isActive ? DebugTheme.gradientGreen : null,
        color: isActive ? null : DebugTheme.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? Colors.transparent : DebugTheme.border,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: DebugTheme.success.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          label,
          style: context.textStyles.bodySmallSemiBold.copyWith(
            color: isActive ? Colors.white : DebugTheme.textSecondary,
          ),
        ),
      ),
    ),
  );
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textStyles.captionSmallRegular.copyWith(
            color: DebugTheme.textMuted,
          ),
        ),
        Text(
          value,
          style: context.textStyles.captionSmallMedium.copyWith(
            color: DebugTheme.textPrimary,
          ),
        ),
      ],
    ),
  );
}
