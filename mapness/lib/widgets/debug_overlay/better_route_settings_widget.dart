import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/routing/providers/routes.dart';

class BetterRouteSettingsWidget extends ConsumerWidget {
  const BetterRouteSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(betterRouteSettingsProvider).value;
    if (settings == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.$4x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Better route settings:', style: context.textStyle.heading2),
          Row(
            children: [
              AppButton(
                buttonColorScheme: ButtonColorScheme.accent,
                size: ButtonSize.small,
                primaryLabel: 'set prod',
                onTap: () {
                  ref.read(betterRouteSettingsProvider.notifier).setSettings(BetterRouteSettings.prod);
                },
              ),
              const SizedBox(width: Spacing.$4x),
              AppButton(
                buttonColorScheme: ButtonColorScheme.accent,
                size: ButtonSize.small,
                primaryLabel: 'set test',
                onTap: () {
                  ref.read(betterRouteSettingsProvider.notifier).setSettings(BetterRouteSettings.test);
                },
              ),
            ],
          ),
          Text('Search delay: ${settings.routeSearchDelay} sec'),
          Text('Time cost threshold: ${settings.betterRouteTimeCostThreshold} sec'),
          Text('Length threshold: ${settings.betterRouteLengthThreshold / 1000} m'),
        ],
      ),
    );
  }
}
