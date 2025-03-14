import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/landing/landing_state_mapper.dart';
import 'package:mapness/pages/routing/ui/routing_search_bar.dart';
import 'package:mapness/pages/routing/ui/routing_search_content.dart';
import 'package:mapness/widgets/landing/dashboard/map_dashboard_controls.dart';

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

class _RoutingSearchSheetState extends ConsumerState<RoutingSearchSheetPage> {
  late final StatefulBottomSheetController<ThreeStateBottomSheet> _dgisSheetController;
  final kbVisibilityController = KeyboardVisibilityController();
  late final StreamSubscription<bool> _keyboardVisible;

  bool visible = true;
  bool isFirstLaunch = false;

  @override
  void initState() {
    super.initState();
    _dgisSheetController = StatefulBottomSheetController(
      initialState: ThreeStateBottomSheet.expanded,
      behavior: AspectRatioSnappingBehavior(aspectRatios: {
        0.0,
        if (Platform.isIOS) .3 else .38,
        if (Platform.isIOS) .931 else .98,
      }),
      stateMapper: const LandingStateMapper(),
    );

    _dgisSheetController.addListener(
      () {
        if (_dgisSheetController.state == ThreeStateBottomSheet.open && context.mounted) {
          setState(() {
            isFirstLaunch = true;
          });
        } else if (_dgisSheetController.state == ThreeStateBottomSheet.hidden && context.mounted) {
          if (isFirstLaunch) {
            setState(() {
              isFirstLaunch = false;
              ref.read(appRouterProvider).back();
            });
          }
        }
      },
    );
    _keyboardVisible = kbVisibilityController.onChange.listen(_onKeyboardToggle);

    if (widget.initialQuery != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          ref.read(searchProvider(SearchScopeEnum.routes.value).notifier).fetchSuggest(widget.initialQuery!);
        },
      );
    }
  }

  @override
  void dispose() {
    _dgisSheetController.dispose();
    _keyboardVisible.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SearchScope(
        named: SearchScopeEnum.routes,
        child: LayoutBuilder(
          builder: (context, constraints) => NotificationListener<ScrollNotification>(
            onNotification: _onNotification,
            child: SafeArea(
              bottom: false,
              child: StatefulBottomSheet<ThreeStateBottomSheet>(
                outside: MapDashboardControls(_dgisSheetController, key: const ValueKey('RoutesControls')),
                outsideOpacityDelegate: (controller) {
                  final aspectRatio = controller.aspectRatio;
                  final interpolation = controller.interpolation;
                  final state = controller.state;

                  final isSheetCoversHalfOfTheScreen = aspectRatio > 0.4;
                  final isSheetStateOpen = state == ThreeStateBottomSheet.open;
                  final isSheetScrolledForHalfOfTheState = interpolation > 0.4;

                  final isFull =
                      (_dgisSheetController.isEnabled && isSheetStateOpen && isSheetScrolledForHalfOfTheState) ||
                          isSheetCoversHalfOfTheScreen;

                  return !isFull ? 1.0 : max(0.0, 1 - (aspectRatio - 0.4) * 9);
                },
                key: const ValueKey('ROUTING SEARCH SHEET'),
                scrollController: _dgisSheetController,
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
                    scrollController: _dgisSheetController,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void _unFocusOnScroll() {
    if (kbVisibilityController.isVisible) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
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
        _unFocusOnScroll();
      }
    }
    return true;
  }

  void _onKeyboardToggle(bool kbState) {
    if (!kbState) {
      return;
    }
    final currentExp = _dgisSheetController.state;
    if (currentExp == ThreeStateBottomSheet.expanded || currentExp == ThreeStateBottomSheet.open) {
      return;
    }

    Future.delayed(Durations.short1).then((_) {
      _dgisSheetController.setState(ThreeStateBottomSheet.expanded);
    });
  }
}
