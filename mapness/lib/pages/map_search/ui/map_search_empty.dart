import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';
import 'package:provider/provider.dart';

class MapSearchEmpty extends ConsumerWidget {
  final bool showAddPlaceButton;

  const MapSearchEmpty({super.key, this.showAddPlaceButton = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final description = context.l10n.tryToSearchForADifferentLocation.split('\n');

    void _onAlternativeSearchPressed() {
      final scope = context.read<SearchScope>();
      ref.read(searchProvider(scope.value).notifier).alternativeSearch();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: Spacing.$2x),
          Transform(
            transform: Matrix4.rotationY(context.locale.languageCode == 'ar' ? pi : 0),
            alignment: Alignment.center,
            child: const ErrorImageWidget(),
          ),
          const SizedBox(height: Spacing.$1x),
          Text(
            context.l10n.searchCouldNotFindAnything,
            style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.$2x),
          if (description.isNotEmpty)
            Text(
              description.first,
              textAlign: TextAlign.center,
              style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
            ),
          if (description.length > 1)
            Text(
              description.last.trim(),
              textAlign: TextAlign.center,
              style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
            ),
          const SizedBox(height: Spacing.$4x),
          AppButton(
            onTap: _onAlternativeSearchPressed,
            buttonColorScheme: ButtonColorScheme.accentSecondary,
            primaryLabel: context.l10n.searchMore,
            primaryIcon: SystemIcons.search,
          ),
          const SizedBox(height: Spacing.$2x),
          if (showAddPlaceButton)
            AppButton(
              buttonColorScheme: ButtonColorScheme.accentSecondary,
              buttonType: ButtonType.secondary,
              primaryIcon: GeneralIcons.plusCircle,
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
