import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/dgis_envirement.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class DebugServerUrl extends ConsumerWidget {
  const DebugServerUrl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(dgisEnvirementProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Experimental! may be expensive",
          style: Theme.of(context)
              .extension<ThemeTextStyles>()
              ?.textS
              .copyWith(color: Colors.black),
        ),
        Text(
          'Balady Public API url: ${env.url}',
          style: Theme.of(context)
              .extension<ThemeTextStyles>()
              ?.accentS
              .copyWith(color: Colors.black),
        ),
        Text(
          'SSO Url: ${env.sso.ssoUrl}\nSSO Client: ${env.sso.ssoClient}\nSSO Secret: ${env.sso.ssoSecret}',
          style: Theme.of(context)
              .extension<ThemeTextStyles>()
              ?.accentS
              .copyWith(color: Colors.black),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabeledElevatedButton(
              onPressed: ref.read(dgisEnvirementProvider.notifier).setDev,
              label: 'Urbi Dev',
            ),
            const SizedBox(width: 8),
            LabeledElevatedButton(
              onPressed: ref.read(dgisEnvirementProvider.notifier).setPreprod,
              label: 'Urbi Pre-Prod',
            ),
            const SizedBox(width: 8),
            LabeledElevatedButton(
              onPressed:
                  ref.read(dgisEnvirementProvider.notifier).setMomrahStaging,
              label: 'Momrah Staging',
            ),
            const SizedBox(width: 8),
            LabeledElevatedButton(
              onPressed:
                  ref.read(dgisEnvirementProvider.notifier).setMomrahProd,
              label: 'Momrah Prod',
            ),
          ],
        )
      ],
    );
  }
}
