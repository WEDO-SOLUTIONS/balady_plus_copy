import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 1.2,
          ),
        ),
        Text(
          'api url: $url',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            height: 1.2,
          ),
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
