import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/routing/ui/routing_search_content.dart';
import 'package:mapness/pages/routing/ui/routing_search_header_delegate.dart';

const _searchScope = 'RoutingSearch';

class RoutingSearchSheet extends ConsumerStatefulWidget {
  const RoutingSearchSheet({
    super.key,
    required this.placeholder,
    required this.showMyLocation,
  });

  final String placeholder;
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
    Future.delayed(Duration.zero, () {
      _controller.animateTo(
        0.9,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DraggableScrollableSheet(
        controller: _controller,
        initialChildSize: 0,
        minChildSize: 0,
        maxChildSize: 0.9,
        snap: true,
        snapSizes: const [0, 0.9],
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF1F4F8),
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
    );
  }
}
