import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/routing/ui/routing_map_controls.dart';
import 'package:mapness/pages/routing/ui/routing_search_content.dart';
import 'package:mapness/pages/routing/ui/routing_search_header_delegate.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';

const _searchScope = 'RoutingSearch';

class RoutingSearchSheet extends ConsumerStatefulWidget {
  const RoutingSearchSheet({
    required this.placeholder,
    required this.showMyLocation,
    this.initialQuery,
    super.key,
  });

  final String placeholder;
  final String? initialQuery;
  final bool showMyLocation;

  @override
  ConsumerState<RoutingSearchSheet> createState() => _RoutingSearchSheetState();
}

class _RoutingSearchSheetState extends ConsumerState<RoutingSearchSheet> {
  late DraggableScrollableController _controller;

  bool visible = true;

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController();
    _controller.addListener(() {
      if (_controller.size <= 0.001 && visible) {
        context.pop(null);
      }
    });
    Future.delayed(
        const Duration(
          milliseconds: 100,
        ), () {
      _controller.animateTo(
        0.9,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    });
    if (widget.initialQuery != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          ref.read(searchQueryProvider(_searchScope).notifier).update(
                widget.initialQuery!,
              );
        },
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          const RoutingMapControls(bottomExtent: 136),
          LayoutBuilder(
            builder: (context, constraints) => DgisBottomSheet(
              initialExpansion: Expansion.middle,
              availableExpansions: const {
                Expansion.hidden,
                Expansion.middle,
                Expansion.expanded
              },
              onExpansionChanged: (expansion, {byUser = false}) {
                if (expansion == Expansion.hidden && context.mounted) {
                  context.pop();
                }
              },
              middleHeight: constraints.maxHeight * 0.7,
              scrollableBody: (context, scrollController) => Container(
                decoration: BoxDecoration(
                  color: context.color.surface_base_primary,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.0),
                    topLeft: Radius.circular(16.0),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: SearchScope(
                    named: _searchScope,
                    child: CustomScrollView(
                      controller: scrollController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      physics: const ClampingScrollPhysics(),
                      slivers: [
                        SliverPersistentHeader(
                          delegate: RoutingSearchHeaderDelegate(
                            placeholder: widget.placeholder,
                            draggableScrollableController: _controller,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
