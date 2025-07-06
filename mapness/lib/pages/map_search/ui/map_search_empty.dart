import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class MapSearchEmpty extends ConsumerWidget {
  final bool isShowAddPlaceButton;

  const MapSearchEmpty({super.key, this.isShowAddPlaceButton = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final desctiption = context.l10n.tryToSearchForADifferentLocation.split('\n');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: Spacing.$2x),
          SvgPicture.asset(
            Assets.imagesSvg.illustrationError.keyName,
          ),
          const SizedBox(height: Spacing.$1x),
          Text(
            context.l10n.searchCouldNotFindAnything,
            style: context.textStyleV3.h4SemiBold,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.$2x),
          Text(
            desctiption.first,
            textAlign: TextAlign.center,
            style: context.textStyleV3.bodySmallRegular.copyWith(
              color: context.colorsV3.foregroundSoft,
            ),
          ),
          Text(
            desctiption.last.trim(),
            textAlign: TextAlign.center,
            style: context.textStyleV3.bodySmallRegular.copyWith(
              color: context.colorsV3.foregroundSoft,
            ),
          ),
          const SizedBox(height: Spacing.$4x),
          if (isShowAddPlaceButton)
            AppButton(
              buttonColorScheme: ButtonColorScheme.primary,
              primaryIcon: GeneralIcons.plusCircle,
              // for the first iteration all buttons have same label. Will be changed later
              primaryLabel: context.l10n.addPlace,
              onTap: () {
                ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.addPoiSearch);
                context.router.push(QuickFeedbackRoute());
              },
            ),
        ],
      ),
    );
  }
}
