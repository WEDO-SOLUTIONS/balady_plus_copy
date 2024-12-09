import 'dart:async';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/routing/ui/routing_map_controls.dart';
import 'package:mapness/pages/routing/ui/routing_search_content.dart';
import 'package:mapness/pages/routing/ui/routing_search_header_delegate.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';

class RoutingSearchSheet extends ConsumerStatefulWidget {
  final String placeholder;
  final String? initialQuery;
  final bool showMyLocation;

  const RoutingSearchSheet({
    required this.placeholder,
    required this.showMyLocation,
    this.initialQuery,
    super.key,
  });

  @override
  ConsumerState<RoutingSearchSheet> createState() => _RoutingSearchSheetState();
}

class _RoutingSearchSheetState extends ConsumerState<RoutingSearchSheet> {
  late final DgisBottomSheetController _dgisSheetController;
  final kbVisibilityController = KeyboardVisibilityController();
  late final StreamSubscription<bool> _keyboardVisible;

  bool visible = true;

  @override
  void initState() {
    super.initState();
    _dgisSheetController = DgisBottomSheetController();
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
    _keyboardVisible.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          const RoutingMapControls(bottomExtent: 136),
          LayoutBuilder(
            builder: (context, constraints) => NotificationListener<ScrollNotification>(
              onNotification: _onNotification,
              child: DgisBottomSheet(
                key: const ValueKey('ROUTING SEARCH SHEET'),
                controller: _dgisSheetController,
                initialExpansion: Expansion.expanded,
                availableExpansions: const {
                  Expansion.hidden,
                  Expansion.middle,
                  Expansion.expanded,
                },
                onExpansionChanged: (expansion, {byUser = false}) {
                  if (expansion == Expansion.hidden && context.mounted) {
                    context.pop();
                  }
                },
                middleHeight: constraints.maxHeight * 0.7,
                scrollableBody: (context, scrollController) {
                  scrollController.addListener(_unFocusOnScroll);
                  final bgColor = context.colorsV2.backgroundSurface1;

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(RadiusBorder.xl),
                    child: Material(
                      color: bgColor,
                      child: SearchScope(
                        named: SearchScopeEnum.routes,
                        child: CustomScrollView(
                          controller: scrollController,
                          physics: const ClampingScrollPhysics(),
                          slivers: [
                            SliverPersistentHeader(
                              delegate: RoutingSearchHeaderDelegate(
                                placeholder: widget.placeholder,
                                backgroundColor: bgColor,
                              ),
                              pinned: true,
                            ),
                            RoutingSearchContent(
                              showMyLocation: widget.showMyLocation,
                              scrollController: scrollController,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
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
    final currentExp = _dgisSheetController.currentExpansion;
    if (currentExp == Expansion.expanded || currentExp == Expansion.middle) {
      return;
    }

    Future.delayed(Durations.short1).then((_) {
      _dgisSheetController.animateTo(Expansion.expanded);
    });
  }
}
