import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/poi_card/widgets/shimmer.dart';
import 'package:mapness/app/routes/iwish.dart';
import 'package:mapness/features/iwish/providers/iwish_distance.dart';
import 'package:mapness/features/iwish/providers/iwish_entity.dart';
import 'package:mapness/features/iwish/providers/iwish_markers.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/shared/ui/sheets/loading_sheet.dart';
import 'package:mapness/widgets/iwish/ui/iwish_card.dart';

class IwishCarousel extends ConsumerWidget {
  const IwishCarousel({this.initialId, super.key});
  final String? initialId;

  void _highlighOnMap(String iwishId) {
    // TODO: implement
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final markers = ref.watch(iwishMarkersProvider);

    return markers.when(
      error: (error, stackTrace) => ErrorSheet(
        onRetry: () => ref.read(iwishMarkersProvider.notifier).refresh(),
        buttonLabel: context.l10n.refresh,
      ),
      loading: () => const LoadingSheet(),
      data: (data) => CarouselSlider.builder(
        itemCount: data.length,
        itemBuilder: (context, index, realIndex) => Consumer(
          builder: (context, ref, child) {
            final iwishState = ref.watch(iwishEntityProvider(data[index].id));
            return iwishState.when(
              error: (_, __) => Center(
                child: TextButton(
                  onPressed: () => ref.read(iwishEntityProvider(data[index].id).notifier).refresh(),
                  child: Text(context.l10n.reload),
                ),
              ),
              loading: () => const ShimmerEffectWidget(),
              data: (iwish) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: IwishCard(
                  iwish: iwish,
                  onClose: () => context.pop(),
                  distance: ref.read(iwishDistanceProvider(iwish)),
                  onTap: () => IwishCardRoute(iwishId: iwish.id).replace(context),
                ),
              ),
            );
          },
        ),
        options: CarouselOptions(
          onPageChanged: (index, reason) => _highlighOnMap(data[index].id),
          enableInfiniteScroll: false,
          viewportFraction: 1 - 16 / 375,
          initialPage: initialId == null ? 0 : data.indexWhere((element) => element.id == initialId),
        ),
      ),
    );
  }
}
