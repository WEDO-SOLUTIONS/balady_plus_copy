import 'package:flutter/material.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/content_transition.dart';
import 'package:mapness/features/poi_card/widgets/poi_tabs.dart';
import 'package:sheetify/sheetify.dart';

class TabComponent extends SheetAnimatedWidget<PoiCardBottomSheetState> {
  final TabController tabController;
  final int objectId;
  final PoiCardState? poiCardState;

  const TabComponent({
    required this.tabController,
    required this.objectId,
    required this.poiCardState,
    super.key,
  }) : super(defaultState: PoiCardBottomSheetState.halfOpen);

  @override
  Widget build(
    BuildContext context,
    PoiCardBottomSheetState state,
    double interpolation,
  ) {
    if (state == PoiCardBottomSheetState.hidden) {
      return const SizedBox.shrink();
    }
    var scale = Curves.easeOutQuart.transform(interpolation);
    if (state == PoiCardBottomSheetState.expanded ||
        state == PoiCardBottomSheetState.open) {
      scale = 1;
    }

    return ContentTransition(
      interpolation: scale,
      child: PoiTabs(
        tabController: tabController,
        objectId: objectId,
        poiCardState: poiCardState,
      ),
    );
  }
}
