import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';

import 'package:mapness/widgets/search/ui/search_field.dart' as widgets;
import 'package:provider/provider.dart';

class SearchField extends ConsumerStatefulWidget {
  const SearchField({
    super.key,
    required this.focusNode,
  });

  final FocusNode focusNode;

  @override
  ConsumerState<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<SearchField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final scope = context.watch<SearchScope>();
    ref.listen(searchQueryProvider(scope.value), (previous, next) {
      if (next != _controller.text) {
        _controller.text = next;
        _controller.selection =
            TextSelection.collapsed(offset: _controller.text.length);
      }
    });

    return widgets.SearchField(
      controller: _controller,
      focusNode: widget.focusNode,
      onChanged: (query) {
        ref.read(searchQueryProvider(scope.value).notifier).update(query);
      },
      onSubmitted: (query) {
        ref.read(searchProvider(scope.value).notifier).searchByText(query);
      },
    );
  }
}
