import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_field.dart';
import 'package:mapness/shared/ui/buttons/nav_button.dart';
import 'package:provider/provider.dart';

class MapSearchBar extends ConsumerStatefulWidget {
  const MapSearchBar({
    super.key,
    required this.requestFocus,
    required this.onClose,
  });

  final bool requestFocus;
  final VoidCallback onClose;

  @override
  ConsumerState<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends ConsumerState<MapSearchBar> {
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
    if (widget.requestFocus) {
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = context.read<SearchScope>();
    ref.listen(searchProvider(scope.value), (previous, next) {
      if (next is SearchStateResults) {
        _focusNode.unfocus();
      }
    });

    return Row(
      children: [
        Expanded(
          child: SearchField(
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
                    onTap: widget.onClose,
                    icon: "assets/icons/svg/ic_search_close.svg",
                  ),
                )
              : const SizedBox.shrink(),
        )
      ],
    );
  }
}
