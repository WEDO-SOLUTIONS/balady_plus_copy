import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/widgets/dragger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/map_search/ui/map_search_bar.dart';

class NaviSearchHeader extends BottomSheetStateComponent<ThreeStateBottomSheet> {
  final bool requestFocus;
  final VoidCallback onClose;
  final Color backgroundColor;

  const NaviSearchHeader({
    required this.requestFocus,
    required this.onClose,
    required this.backgroundColor,
    super.key,
  }) : super(defaultState: ThreeStateBottomSheet.open);

  @override
  Widget build(BuildContext context, ThreeStateBottomSheet state, double interpolation) {
    final multiplier = 1 - interpolation;
    final bottomPadding =
        state == ThreeStateBottomSheet.hidden ? (multiplier * Spacing.$8x) : (multiplier * Spacing.$4x);

    return Consumer(
      builder: (context, ref, child) {
        final searchState = ref.watch(searchProvider(SearchScopeEnum.map.value));

        final color = state == ThreeStateBottomSheet.hidden
            ? backgroundColor
            : switch (searchState) {
                SearchStateHistory() => backgroundColor,
                _ => context.colorsV3.backgroundSurface4,
              };

        return Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              ColoredBox(
                color: color,
                child: const SizedBox(
                  height: 24,
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(padding: EdgeInsets.only(top: 8.0), child: Dragger()),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x).copyWith(bottom: bottomPadding),
                child: MapSearchBar(
                  requestFocus: requestFocus,
                  onClose: onClose,
                  isCloseButton: state == ThreeStateBottomSheet.hidden,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
