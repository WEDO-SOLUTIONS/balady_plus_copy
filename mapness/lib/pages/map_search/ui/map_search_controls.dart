import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/landing/search_in_rect.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/features/tifo/tifo_buildings_map_layer.dart';
import 'package:mapness/shared/constants/metrics_constants.dart' hide Search;
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/landing/compass_control.dart';
import 'package:mapness/widgets/landing/complience_building_legend.dart';
import 'package:mapness/widgets/landing/dashboard_header.dart';
import 'package:mapness/widgets/landing/follow_control.dart';
import 'package:mapness/widgets/landing/layers_control.dart';
import 'package:mapness/widgets/landing/tifo_control.dart';
import 'package:mapness/widgets/map_dimensions_control/dimension_contrtol.dart';
import 'package:mapness/widgets/weather/weather_control.dart';
import 'package:sheetify/sheetify.dart';

class MapSearchSheetControls extends ConsumerStatefulWidget {
  // In percent of the screen
  final double? currentSize;
  final double collapsedSize;
  final ThreeStateSheet? sheetState;
  final VoidCallback? onClose;

  // Calculate the topbar and bottom padding
  static const screenPadding = 80 + 70;

  const MapSearchSheetControls({
    required this.collapsedSize,
    this.onClose,
    this.sheetState,
    this.currentSize,
    super.key,
  });

  @override
  MapSearchSheetControlsState createState() => MapSearchSheetControlsState();
}

class MapSearchSheetControlsState extends ConsumerState<MapSearchSheetControls> {
  final _scope = SearchScopeEnum.map.value;

  void _searchInArea() {
    ref.read(searchInRectProvider(_scope).notifier).update();
    ref.read(searchProvider(_scope).notifier).searchInThisArea(_scope);
  }

  @override
  Widget build(BuildContext context) {
    final scope = _scope;
    final searchState = ref.watch(searchProvider(_scope));
    final searcher = ref.watch(searchProvider(_scope).notifier);

    final isMinimized = widget.sheetState == ThreeStateSheet.hidden;
    final isButtonVisible = ref.watch(searchInRectProvider(scope).select((s) => s.isButtonVisible)) && isMinimized;
    final double screenHeight = MediaQuery.of(context).size.height;

    bool hideAll = false;
    bool hideControls = false;
    double bottomPadding = uikit.Spacing.$4x;

    hideControls = widget.sheetState != ThreeStateSheet.hidden;
    hideAll = widget.sheetState == ThreeStateSheet.expanded;

    final double padding = (widget.currentSize ?? 0) * screenHeight;

    // Update Padding for the bottom sheet size
    if ((widget.currentSize ?? 0) > 0.28 && (widget.currentSize ?? 0) < 0.4) {
      // for a new feature you need to change and replace the magic number, now these numbers are taken by taking into account all the indents, the height of the bottom nav bar
      bottomPadding = uikit.Spacing.$4x + padding - MapSearchSheetControls.screenPadding;
    } else {
      bottomPadding = uikit.Spacing.$4x;
    }

    return SizedBox.expand(
      child: IgnorePointer(
        ignoring: hideAll,
        child: SafeArea(
          bottom: false,
          child: AnimatedOpacity(
            opacity: hideAll ? 0 : 1,
            duration: const Duration(milliseconds: 250),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                switch (searchState) {
                  SearchStateEmpty() || SearchStateLoading() || SearchStateResults() || SearchStateError() => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: uikit.Spacing.$4x).copyWith(top: uikit.Spacing.$2x),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: DashboardHeader(),
                            ),
                            uikit.Spacing.$3x.widthBox,
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: uikit.Shadows.s,
                                borderRadius: BorderRadius.circular(uikit.RadiusBorder.l),
                              ),
                              child: uikit.AppButton(
                                buttonColorScheme: uikit.ButtonColorScheme.neutral,
                                buttonType: uikit.ButtonType.secondary,
                                color: context.colors.backgroundSurface2,
                                iconColor: context.colors.foregroundDefault,
                                primaryIcon: uikit.SystemIcons.close,
                                onTap: () => _onBackPressed(searcher),
                                padding: const EdgeInsets.all(0),
                                innerPadding: const EdgeInsets.symmetric(horizontal: uikit.Spacing.$2x),
                              ),
                            ),
                          ],
                        ),
                        uikit.Spacing.$2x.heightBox,
                      ],
                    ),
                  ),
                  SearchStateHistory() || SearchStateSuggest() => const SizedBox(),
                },
                if (!hideControls)
                  AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    child: Expanded(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: AnimatedPadding(
                          duration: const Duration(milliseconds: 400),
                          padding: EdgeInsets.only(
                            left: uikit.Spacing.$4x,
                            top: uikit.Spacing.$4x,
                            right: uikit.Spacing.$4x,
                            bottom: bottomPadding,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [WeatherControl()],
                                    ),
                                    const Spacer(),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          const LayersControl(),
                                          const SizedBox(height: 8),
                                          const DimensionControl(),
                                          if (ref.watch(tifoAvailableProvider)) ...[
                                            const SizedBox(height: 8),
                                            const TifoControl(),
                                          ],
                                          const Spacer(),
                                          const CompassControl(),
                                          const SizedBox(height: 8),
                                          ComplianceBuildingLegend(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  if (isButtonVisible)
                                    uikit.AppButton(
                                      buttonColorScheme: uikit.ButtonColorScheme.accentSecondary,
                                      primaryLabel: context.l10n.searchInThisArea,
                                      onTap: _searchInArea,
                                      innerPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    ),
                                  const Spacer(),
                                  const FollowControl(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onBackPressed(Search searcher) {
    FocusScope.of(context).unfocus();
    searcher.clear();
    widget.onClose?.call();
  }
}
