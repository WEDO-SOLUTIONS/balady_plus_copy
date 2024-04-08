import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/pages/kiblah/providers/kaaba_bearing.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/compass.dart';
import 'package:mapness/shared/ui/buttons/filled_back_button.dart';

class KiblahHeader extends ConsumerWidget {
  const KiblahHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kaabaBearing = ref.watch(kaabaBearingProvider);
    final userBearing = ref.watch(compassProvider);

    final isReady = userBearing != null && kaabaBearing != null;

    int bearingDiff =
        isReady ? (kaabaBearing.floor() - userBearing.floor()).abs() : 0;

    final turnClockwise = bearingDiff > 180;
    if (turnClockwise) {
      bearingDiff = 360 - bearingDiff;
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 12,
        left: 12,
        right: 12,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: FilledBackButton(
              onClose: () {
                ref.read(mapControlsProvider.notifier).update(
                      MapControlsStateDashboard(),
                    );
                const LandingRoute().go(context);
              },
            ),
          ),
          Text(
            isReady
                ? context.l10n.kiblahBearingDiff
                    .replaceFirst('%degrees', '$bearingDiff')
                : context.l10n.calibrating,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .textL
                .copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
