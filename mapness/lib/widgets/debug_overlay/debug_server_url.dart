import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/config/environment_config.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class DebugServerUrl extends ConsumerWidget {
  const DebugServerUrl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envProvider = ref.watch(dgisEnvironmentProvider);
    return envProvider.map(
      data: (data) {
        final env = data.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Experimental! may be expensive',
              style: Theme.of(context).extension<ThemeTextStyles>()?.caption.copyWith(color: Colors.black),
            ),
            Text(
              'Balady Public API url: ${env.url}',
              style: Theme.of(context).extension<ThemeTextStyles>()?.footNoteBold.copyWith(color: Colors.black),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledElevatedButton(
                  onPressed: () => ref.read(dgisEnvironmentProvider.notifier).setEnv(DgisEnv.urbiDev),
                  label: 'Urbi Dev',
                ),
                const SizedBox(width: 8),
                LabeledElevatedButton(
                  onPressed: () => ref.read(dgisEnvironmentProvider.notifier).setEnv(DgisEnv.urbiPreprod),
                  label: 'Urbi Pre-Prod',
                ),
                const SizedBox(width: 8),
                LabeledElevatedButton(
                  onPressed: () => ref.read(dgisEnvironmentProvider.notifier).setEnv(DgisEnv.momrahStaging),
                  label: 'Momrah Staging',
                ),
                const SizedBox(width: 8),
                LabeledElevatedButton(
                  onPressed: () => ref.read(dgisEnvironmentProvider.notifier).setEnv(DgisEnv.momrahProd),
                  label: 'Momrah Prod',
                ),
              ],
            ),
          ],
        );
      },
      error: (_) => const SizedBox.shrink(),
      loading: (_) => const SizedBox.shrink(),
    );
  }
}
