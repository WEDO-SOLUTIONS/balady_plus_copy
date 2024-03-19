import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/features/routing/ui/search_field.dart';

import 'package:mapness/shared/ui/buttons/nav_button.dart';

class RoutingSearchBar extends ConsumerStatefulWidget {
  const RoutingSearchBar({
    required this.placeholder,
    required this.draggableScrollableController,
    super.key,
  });

  final String placeholder;
  final DraggableScrollableController draggableScrollableController;

  @override
  ConsumerState<RoutingSearchBar> createState() => _RoutingSearchBarState();
}

class _RoutingSearchBarState extends ConsumerState<RoutingSearchBar> {
  late FocusNode _focusNode;
  final ValueNotifier<bool> _focused = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()
      ..addListener(() {
        if (_focusNode.hasFocus) {
          _focused.value = true;
        }
      });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: SearchField(
              placeholder: widget.placeholder,
              focusNode: _focusNode,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _focused,
            builder: (context, value, child) => value
                ? Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 12,
                    ),
                    child: NavButton(
                      onTap: () {
                        context.pop();
                      },
                      icon: 'assets/icons/svg/ic_search_close.svg',
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      );
}
