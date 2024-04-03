import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/landing_page.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/pages/kiblah/providers/kaaba_bearing.dart';
import 'package:mapness/pages/kiblah/ui/kiblah_compass.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/compass.dart';

class KiblahPage extends ConsumerWidget {
  const KiblahPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kaabaBearing = ref.watch(kaabaBearingProvider);
    final userBearing = ref.watch(compassProvider)?.floor().abs();
    final isReady = userBearing != null && kaabaBearing != null;

    return Material(
      color: Colors.black.withOpacity(0.7),
      child: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Align(
            //   alignment: AlignmentDirectional.centerStart,
            //   child: BaladyTopBar(
            //     onLeadingPressed: () {
            //       ref.read(mapControlsProvider.notifier).update(MapControlsStateDashboard());
            //       const LandingRoute().go(context);
            //     },
            //     leading: Icon(
            //       BaladyIcons.Arrow_Corner_Left_L,
            //       color: context.color.textAndIconsBaseInversePrimary,
            //     ),
            //     title: isReady ? '$userBearing°' : context.l10n.calibrating,
            //     textStyle: context.textStyle.footNoteBold.copyWith(color: context.color.textAndIconsBaseInversePrimary),
            //   ),
            // ),
            const Center(child: KiblahCompass()),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Container(
            //     width: double.infinity,
            //     margin: const EdgeInsets.symmetric(
            //       horizontal: Spacing.horizontalPaddingInsideWrapper,
            //       vertical: Spacing.horizontalPaddingInsideCell,
            //     ),
            //     child: AppButton(
            //       primaryIcon: BaladyIcons.Mosq2,
            //       primaryLabel: context.l10n.mosquesNearYou,
            //       buttonColorScheme: ButtonColorScheme.primary,
            //       onTap: () {
            //         ref.read(mapControlsProvider.notifier).update(MapControlsStateDashboard());
            //         const LandingRoute(focusMaker: LangingFocusMaker.mosques)
            //             .go(context);
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
