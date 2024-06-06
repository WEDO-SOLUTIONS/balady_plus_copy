import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/features/quick_filters/providers/quick_filters_data.dart';
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
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: context.staticColor.surfaceOverlayModal.withOpacity(0.7),
      appBar: BaladyTopBar(
        onLeadingPressed: () {
          context.pop();
        },
        leading: Padding(
          padding: const EdgeInsets.only(
            left: NumericBase.$4x,
            right: NumericBase.$4x,
          ),
          child: Row(
            children: [
              Icon(
                isArabic ? SystemIcons.arrowCornerRightSmall : SystemIcons.arrowCornerLeftSmall,
                color: context.color.textAndIconsBaseInversePrimary,
              ),
              const SizedBox(width: NumericBase.$0_5x),
              Text(
                context.l10n.back,
                style: context.textStyle.footNote.copyWith(color: context.staticColor.textAndIconsBaseInversePrimary),
              )
            ],
          ),
        ),
        title: isReady ? '$userBearing°' : context.l10n.calibrating,
        textStyle: context.textStyle.footNoteBold.copyWith(color: context.color.textAndIconsBaseInversePrimary),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Center(child: KiblahCompass()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                left: Spacing.horizontalPaddingInsideWrapper,
                right: Spacing.horizontalPaddingInsideWrapper,
                top: Spacing.horizontalPaddingInsideWrapper,
                bottom: MediaQuery.of(context).padding.bottom + NumericBase.$0_5x,
              ),
              child: AppButton(
                primaryIcon: GeneralIcons.mosq,
                primaryLabel: context.l10n.mosquesNearYou,
                buttonColorScheme: ButtonColorScheme.primary,
                onTap: () {
                  context.pop();
                  ref.read(searchByRubricsQueryProvider.notifier).selectFilter(QuickFilterType.mosques);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
