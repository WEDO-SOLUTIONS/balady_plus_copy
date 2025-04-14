import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/landing/search_in_rect.dart';

import 'package:mapness/features/map_tap_handler/map_tap_handler_provider.dart';

import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/map_search/ui/map_search_content.dart';

import 'package:mapness/pages/map_search/ui/map_search_header_delegate.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';

import 'package:mapness/shared/lib/urbi_metrics.dart';

import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';

/// Search sheet that is shown on the explore screen.
class FeedbackAddressSheet extends ConsumerStatefulWidget {
  final bool requestFocus;
  final bool withClustering;
  final double biggestHeight;
  final Expansion? expansion;

  const FeedbackAddressSheet({
    required this.withClustering,
    required this.biggestHeight,
    required this.requestFocus,
    this.expansion,
    super.key,
  });

  @override
  ConsumerState<FeedbackAddressSheet> createState() => _MapSearchSheetState();
}

class _MapSearchSheetState extends ConsumerState<FeedbackAddressSheet> with WidgetsBindingObserver {
  late final DgisBottomSheetController _dgisSheetController;
  double currentSize = 0.1;
  late final StreamSubscription<bool> _keyboardVisible;
  final kbVisibilityController = KeyboardVisibilityController();
  final settings = MapObjectManagerSettings.search();
  StreamSubscription<TapEvent>? _streamSubscription;

  ClusteringMapObjectManager? _clustering;

  final _initialExpansion = Expansion.middle;

  @override
  void initState() {
    super.initState();
    _dgisSheetController = DgisBottomSheetController();
    _keyboardVisible = kbVisibilityController.onChange.listen(_onKeyboardToggle);
    _setupTapListener();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _unfocusSearchField();
    }
  }

  @override
  void dispose() {
    _keyboardVisible.cancel();
    _dgisSheetController.dispose();
    _streamSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final collapsedHeight = 88 + bottomSafeArea;

    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (_) {
            _unfocusSearchField();
            _collapseBottomSheet();
          },
        ),
        NotificationListener<ScrollNotification>(
          onNotification: _onNotification,
          child: DgisBottomSheet(
              key: const Key('MAP SEARCH SHEET KEY'),
              showBarrier: false,
              controller: _dgisSheetController,
              initialExpansion: widget.expansion ?? _initialExpansion,
              availableExpansions: const {
                Expansion.expanded,
              },
              middleHeight: widget.biggestHeight * 0.8,
              collapsedHeight: collapsedHeight,
              scrollableBody: (context, scrollController) {
                final bgColor = context.colorsV2.backgroundSurface1;
                return ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(RadiusBorder.xl),
                  ),
                  child: Material(
                    color: bgColor,
                    child: SearchScope(
                      named: SearchScopeEnum.map,
                      child: CustomScrollView(
                        controller: scrollController,
                        physics: const ClampingScrollPhysics(),
                        slivers: [
                          SliverPersistentHeader(
                            delegate: MapSearchHeaderDelegate(
                              backgroundColor: bgColor,
                              requestFocus: widget.requestFocus,
                              onClose: onClose,
                            ),
                            pinned: true,
                          ),
                          MapSearchContent(
                            scrollController: scrollController,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  bool _onNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      // BSA-1103
      // We need to check if the user is dragging the sheet
      // If not we don't need to unfocus the search field
      //
      // This check is necessary because the [ScrollStartNotification] is called even on the scroll of the TextField
      // when the user is typing a long text and the TextField is scrolling to show it
      if (notification.dragDetails != null) {
        _unfocusSearchField();
      }
    }
    return true;
  }

  void _unfocusSearchField() {
    if (kbVisibilityController.isVisible) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void _onKeyboardToggle(bool kbState) {
    if (!kbState) {
      return;
    }
    final currentExp = _dgisSheetController.currentExpansion;
    if (currentExp == Expansion.expanded || currentExp == Expansion.middle) {
      return;
    }
    // We need to wait because of the rebuild the sheet state
    // At the build method we recalculate [collapsedHeight] and we secretly call the [didUpdateWidget] method
    // of [_dgisSheetController]. And if we call the [animateTo] method before the [didUpdateWidget] method
    // we will get set wrong [Expansion] value
    Future.delayed(Durations.short2).then((_) {
      _dgisSheetController.animateTo(Expansion.expanded);
    });
  }

  void onClose() {
    Metrics.logEventAdvanced(
      MetricsConstants.searchKeys.exitIcon,
      group: MetricsConstants.searchTag,
      action: MetricAction.tap.toString(),
    );
    _removeAllMarkersAndPop();
  }

  void _removeAllMarkersAndPop() {
    ref
        .read(
          mapObjectManagerProvider(
            named: settings.name,
            layerId: settings.layerId,
            clustering: widget.withClustering ? _clustering : null,
          ).notifier,
        )
        .removeAllMarkers();
    ref.read(searchInRectProvider.notifier).update();
    context.router.popForced();
  }

  void _setupTapListener() {
    _streamSubscription = ref.read(mapTapHandlerProvider.notifier).listen((_) {
      if (context.router.isRouteActive(SearchRoute.name)) {
        _unfocusSearchField();
        _collapseBottomSheet();
      }
    });
  }

  void _collapseBottomSheet() {
    _dgisSheetController.animateTo(Expansion.collapsed);
  }
}
