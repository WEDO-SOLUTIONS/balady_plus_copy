import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/landing/landing_state_mapper.dart';
import 'package:mapness/pages/map_search/ui/map_search_controls.dart';
import 'package:mapness/pages/routing/ui/routing_search_bar.dart';
import 'package:mapness/pages/routing/ui/routing_search_content.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';

@RoutePage()
class RoutingSearchSheetPage extends ConsumerStatefulWidget {
  final String placeholder;
  final String? initialQuery;
  final bool showMyLocation;

  const RoutingSearchSheetPage({
    required this.placeholder,
    required this.showMyLocation,
    this.initialQuery,
    super.key,
  });

  @override
  ConsumerState<RoutingSearchSheetPage> createState() => _RoutingSearchSheetState();
}

class _RoutingSearchSheetState extends ConsumerState<RoutingSearchSheetPage> with WidgetsBindingObserver {
  late final StatefulBottomSheetController<ThreeStateBottomSheet> _statefulBottomSheetController;
  double currentSize = 0.1;
  late final StreamSubscription<bool> _keyboardVisible;
  final kbVisibilityController = KeyboardVisibilityController();
  final settings = MapObjectManagerSettings.search();

  bool visible = true;
  bool isFirstLaunch = false;

  @override
  void initState() {
    super.initState();
    _statefulBottomSheetController = StatefulBottomSheetController(
      initialState: ThreeStateBottomSheet.expanded,
      behavior: AspectRatioSnappingBehavior(aspectRatios: {
        0.0,
        if (Platform.isIOS) .3 else .38,
        if (Platform.isIOS) .931 else .98,
      }),
      stateMapper: const LandingStateMapper(),
    );
    _keyboardVisible = kbVisibilityController.onChange.listen(_onKeyboardToggle);
    WidgetsBinding.instance.addObserver(this);

    if (widget.initialQuery != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          ref.read(searchProvider(SearchScopeEnum.routes.value).notifier).fetchSuggest(widget.initialQuery!);
        },
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _unfocusSearchField();
    }
  }

  @override
  void dispose() {
    _statefulBottomSheetController.dispose();
    _keyboardVisible.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final collapsedHeight = 88 + bottomSafeArea;

    return SearchScope(
      named: SearchScopeEnum.routes,
      child: Stack(
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
            child: SafeArea(
              bottom: false,
              child: StatefulBottomSheet<ThreeStateBottomSheet>(
                keepContentBehindFooter: true,
                scrollController: _statefulBottomSheetController,
                outsideOpacityDelegate: StatefulSheetDelegateFunction(
                  function: (controller) {
                    final aspectRatio = controller.aspectRatio;
                    final interpolation = controller.interpolation;
                    final state = controller.state;

                    final isSheetCoversHalfOfTheScreen = aspectRatio > 0.4;
                    final isSheetStateOpen = state == ThreeStateBottomSheet.open;
                    final isSheetScrolledForHalfOfTheState = interpolation > 0.4;

                    final isFull = (_statefulBottomSheetController.isEnabled &&
                            isSheetStateOpen &&
                            isSheetScrolledForHalfOfTheState) ||
                        isSheetCoversHalfOfTheScreen;

                    return !isFull ? 1.0 : max(0.0, 1 - (aspectRatio - 0.4) * 9);
                  },
                ),
                outside: MapSearchSheetControls(currentSize: currentSize, collapsedSize: collapsedHeight),
                key: const ValueKey('ROUTING SEARCH SHEET'),
                header: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: RoutingSearchBar(
                        placeholder: widget.placeholder,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
                content: [
                  RoutingSearchContent(
                    showMyLocation: widget.showMyLocation,
                    bottomSheetContentScrollController: _statefulBottomSheetController,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
    if (!kbState || _statefulBottomSheetController.state == ThreeStateBottomSheet.expanded) {
      return;
    }

    _statefulBottomSheetController.setState(ThreeStateBottomSheet.expanded);
  }

  void _collapseBottomSheet() {
    _statefulBottomSheetController.setState(ThreeStateBottomSheet.open);
  }
}
