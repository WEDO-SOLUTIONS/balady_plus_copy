import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/widgets/search/ui/search_field.dart' as widgets;
import 'package:provider/provider.dart';

class SearchField extends ConsumerStatefulWidget {
  const SearchField({
    required this.focusNode,
    super.key,
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
        _controller
          ..text = next
          ..selection =
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
        if (query.isNotEmpty) {
          ref.read(searchHistoryProvider(scope.value).notifier).put(
                SearchHistoryItem(
                  title: query,
                  address: '',
                  objectId: null,
                  entranceId: null,
                ),
              );
        }
      },
    );
  }
}
