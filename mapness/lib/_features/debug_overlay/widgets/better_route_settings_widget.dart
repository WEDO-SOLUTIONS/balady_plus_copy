import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class BetterRouteSettingsWidget extends ConsumerWidget {
  const BetterRouteSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(betterRouteSettingsProvider).valueOrNull;
    if (settings == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: NumericBase.$4x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Better route settings:', style: context.textStyle.heading2),
          Row(
            children: [
              AppButton(
                  buttonColorScheme: ButtonColorScheme.primary,
                  size: ButtonSize.small,
                  primaryLabel: 'set prod',
                  onTap: () {
                    ref.read(betterRouteSettingsProvider.notifier).setSettings(BetterRouteSettings.prod);
                  }),
              const SizedBox(width: NumericBase.$4x),
              AppButton(
                  buttonColorScheme: ButtonColorScheme.primary,
                  size: ButtonSize.small,
                  primaryLabel: 'set test',
                  onTap: () {
                    ref.read(betterRouteSettingsProvider.notifier).setSettings(BetterRouteSettings.test);
                  }),
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
