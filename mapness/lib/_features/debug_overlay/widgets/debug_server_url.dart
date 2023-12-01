import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapness/shared/providers/dgis_url.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class DebugServerUrl extends ConsumerWidget {
  const DebugServerUrl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = ref.watch(dgisUrlProvider);

    return Column(
      children: [
        Text(
          "Experimental! may be expensive",
          style: Theme.of(context)
              .extension<ThemeTextStyles>()
              ?.textS
              .copyWith(color: Colors.black),
        ),
        Text(
          'api url: $url',
          style: Theme.of(context)
              .extension<ThemeTextStyles>()
              ?.accentS
              .copyWith(color: Colors.black),
        ),
        Row(
          children: [
            LabeledElevatedButton(
              onPressed: () => ref.read(dgisUrlProvider.notifier).setStaging(),
              label: 'staging',
            ),
            const SizedBox(width: 8),
            LabeledElevatedButton(
              onPressed: () =>
                  ref.read(dgisUrlProvider.notifier).setProduction(),
              label: 'production',
            ),
          ],
        )
      ],
    );
  }
}
