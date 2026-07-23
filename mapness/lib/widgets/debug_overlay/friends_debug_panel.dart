import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/friends_on_map/providers/data/mock/mock_friends_data_source.dart';
import 'package:mapness/features/friends_on_map/providers/friends_debug_settings_provider.dart';
import 'package:mapness/widgets/debug_overlay/debug_theme.dart';

/// Debug controls for `MockFriendsDataSource`: point count and update
/// interval, both applied immediately (see `friends_data_source_provider.dart`).
class FriendsDebugPanel extends ConsumerWidget {
  const FriendsDebugPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointsCount = ref.watch(friendsDebugPointsCountProvider);
    final intervalSeconds = ref.watch(friendsDebugUpdateIntervalSecondsProvider);

    return DebugCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DebugSectionHeader(
            icon: Icons.people_alt_rounded,
            title: 'Friends layer',
            subtitle: 'Mock data source settings',
            gradient: DebugTheme.gradientTeal,
          ),
          const SizedBox(height: 14),
          _DebugSlider(
            label: 'Points count',
            valueLabel: '$pointsCount',
            value: pointsCount.toDouble(),
            min: kFriendsMockMinPoints.toDouble(),
            max: kFriendsMockMaxPoints.toDouble(),
            divisions: kFriendsMockMaxPoints - kFriendsMockMinPoints,
            minLabel: '$kFriendsMockMinPoints',
            maxLabel: '$kFriendsMockMaxPoints',
            onChanged: (value) => ref.read(friendsDebugPointsCountProvider.notifier).setPointsCount(value.round()),
          ),
          const SizedBox(height: 12),
          _DebugSlider(
            label: 'Update interval',
            valueLabel: '${intervalSeconds}s',
            value: intervalSeconds.toDouble(),
            min: kFriendsMockMinIntervalSeconds.toDouble(),
            max: kFriendsMockMaxIntervalSeconds.toDouble(),
            divisions: kFriendsMockMaxIntervalSeconds - kFriendsMockMinIntervalSeconds,
            minLabel: '${kFriendsMockMinIntervalSeconds}s',
            maxLabel: '${kFriendsMockMaxIntervalSeconds}s',
            onChanged: (value) =>
                ref.read(friendsDebugUpdateIntervalSecondsProvider.notifier).setUpdateIntervalSeconds(value.round()),
          ),
        ],
      ),
    );
  }
}

class _DebugSlider extends StatelessWidget {
  const _DebugSlider({
    required this.label,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.minLabel,
    required this.maxLabel,
    required this.onChanged,
  });

  final String label;
  final String valueLabel;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String minLabel;
  final String maxLabel;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: DebugTheme.surfaceLight,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: context.textStyles.captionSmallRegular.copyWith(color: DebugTheme.textMuted),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: DebugTheme.gradientTeal,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                valueLabel,
                style: context.textStyles.captionSmallMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: DebugTheme.accent,
            inactiveTrackColor: DebugTheme.border,
            thumbColor: Colors.white,
            overlayColor: DebugTheme.accent.withOpacity(0.2),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8, elevation: 4),
          ),
          child: Slider(value: value, min: min, max: max, divisions: divisions, onChanged: onChanged),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              minLabel,
              style: context.textStyles.captionSmallRegular.copyWith(color: DebugTheme.textMuted, fontSize: 10),
            ),
            Text(
              maxLabel,
              style: context.textStyles.captionSmallRegular.copyWith(color: DebugTheme.textMuted, fontSize: 10),
            ),
          ],
        ),
      ],
    ),
  );
}
