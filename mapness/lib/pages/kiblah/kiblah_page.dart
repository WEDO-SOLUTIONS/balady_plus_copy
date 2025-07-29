import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/kiblah/providers/kaaba_bearing.dart';
import 'package:mapness/pages/kiblah/ui/kiblah_compass.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/compass.dart';

@RoutePage()
class KiblahPage extends ConsumerWidget {
  const KiblahPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kaabaBearing = ref.watch(kaabaBearingProvider);
    final userBearing = ref.watch(compassProvider)?.floor().abs();
    final isReady = userBearing != null && kaabaBearing != null;

    return Scaffold(
      backgroundColor: context.staticColor.surfaceOverlayModal.withOpacity(0.7),
      appBar: BaladyTopBar(
        onLeadingPressed: () {
          context.router.popForced();
        },
        leading: Padding(
          padding: const EdgeInsets.only(
            left: Spacing.$4x,
            right: Spacing.$4x,
          ),
          child: Row(
            children: [
              Icon(
                SystemIcons.arrowCornerLeftLarge,
                color: context.color.textAndIconsBaseInversePrimary,
              ),
              const SizedBox(width: Spacing.$0_5x),
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
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Center(child: KiblahCompass()),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(
                  left: Spacing.$4x,
                  right: Spacing.$4x,
                  top: Spacing.$4x,
                  bottom: Spacing.$5x,
                ),
                child: AppButton(
                  primaryIcon: GeneralIcons.mosq,
                  size: ButtonSize.large,
                  primaryLabel: context.l10n.mosquesNearYou,
                  buttonColorScheme: ButtonColorScheme.accent,
                  onTap: () => _onMosquesNearTap(context, ref),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMosquesNearTap(BuildContext context, WidgetRef ref) {
    context.router.replace(SearchRoute(requestFocus: false));
    // TODO(Sergei): research and understand why searchProvider keep alive only after first search is performed, then refactor this
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchProvider(SearchScopeEnum.map.value).notifier).quickSearch(QuickFilter.mosques);
    });
  }
}
