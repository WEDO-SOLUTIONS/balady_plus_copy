import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/hajj/poi_marker_rcmc.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/content_transition.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/subtitle.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/title.dart';
import 'package:mapness/shared/ui/sheets/card_header.dart';
import 'package:sheetify/sheetify.dart';

class HajjPoiHeader extends ConsumerWidget {
  final PoiMarkerRcmc poiMarkerRcmc;
  final Function()? onTapClose;

  const HajjPoiHeader({
    required this.onTapClose,
    required this.poiMarkerRcmc,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => ColoredBox(
    color: context.colors.backgroundSurface2,
    child: Padding(
      padding: const EdgeInsets.only(
        left: Spacing.$4x,
        right: Spacing.$4x,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(
            title: CardHeaderWidget(child: TitleComponent(title: poiMarkerRcmc.title)),
            onTapClose: onTapClose,
            subTitle: CardHeaderWidget(
              child: SubtitleComponent(
                subtitle: poiMarkerRcmc.categoryName,
              ),
            ),
          ),
          _HeaderInfoWidget(poiMarkerRcmc: poiMarkerRcmc),
        ],
      ),
    ),
  );
}

class _HeaderInfoWidget extends SheetAnimatedWidget<PoiCardBottomSheetState> {
  final PoiMarkerRcmc poiMarkerRcmc;

  const _HeaderInfoWidget({
    required this.poiMarkerRcmc,
  }) : super(
         defaultState: PoiCardBottomSheetState.halfOpen,
       );

  @override
  Widget build(BuildContext context, PoiCardBottomSheetState state, double interpolation) {
    if (state.index > PoiCardBottomSheetState.halfOpen.index) {
      return const SizedBox.shrink();
    }

    var scale = interpolation;

    if (state == PoiCardBottomSheetState.halfOpen) {
      scale = 1 - interpolation;
    }

    return ContentTransition(
      interpolation: scale,
      child: Padding(
        padding: const EdgeInsets.only(
          top: Spacing.$2x,
          bottom: Spacing.$3x,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContentRow(
              options: ContentRowOptions(
                subtitle: poiMarkerRcmc.address,
                subtitleStyle: context.textStyles.bodyLargeRegular,
                padding: const EdgeInsets.only(bottom: Spacing.$0_5x),
                subtitleMaxlines: 1,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
