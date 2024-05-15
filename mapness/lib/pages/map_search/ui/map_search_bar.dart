import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:provider/provider.dart';

class MapSearchBar extends ConsumerStatefulWidget {
  const MapSearchBar({
    required this.requestFocus,
    required this.onClose,
    super.key,
  });

  final bool requestFocus;
  final VoidCallback onClose;

  @override
  ConsumerState<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends ConsumerState<MapSearchBar> {
  late FocusNode _focusNode;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    if (widget.requestFocus) {
      _focusNode.requestFocus();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.requestFocus) {
      _focusNode.requestFocus();
    } else {
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = context.read<SearchScope>();
    ref
      ..listen(searchProvider(scope.value), (previous, next) {
        if (next is SearchStateResults) {
          _focusNode.unfocus();
        }
      })
      ..listen(searchQueryProvider(scope.value), (previous, next) {
        if (next != _controller.text) {
          _controller
            ..text = next
            ..selection =
                TextSelection.collapsed(offset: _controller.text.length);
        }
      });

    return BaladySearchWithBackButton(
      searchInput: BaladyInput.search(
        focusNode: _focusNode,
        onChanged: (query) {
          ref.read(searchQueryProvider(scope.value).notifier).update(query);
          Metrics.logEventAdvanced(
            MetricsConstants.searchKeys.searchField,
            group: MetricsConstants.searchTag,
            action: MetricAction.type.toString(),
            props: {
              'query': query,
            },
          );
        },
        onSubmitted: (query) {
          Metrics.logEventAdvanced(
            MetricsConstants.searchKeys.searchField,
            group: MetricsConstants.searchTag,
            action: MetricAction.type.toString(),
            props: {
              'query': query,
            },
          );
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
        controller: _controller,
        hintText: context.l10n.search,
      ),
      onBackButtonPressed: widget.onClose,
    );
  }
}
