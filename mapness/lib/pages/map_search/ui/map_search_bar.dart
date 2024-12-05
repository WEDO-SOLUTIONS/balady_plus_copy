import 'dart:async';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/providers/search_in_rect.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/features/statistic/providers/statistics_provider.dart';
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
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _updateText(String text) {
    if (text != _controller.text) {
      _controller
        ..text = text
        ..selection = TextSelection.collapsed(offset: _controller.text.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = context.read<SearchScope>();
    final searcher = ref.watch(searchProvider(scope.value).notifier);
    ref.listen(searchProvider(scope.value), (previous, next) {
      if (next.searchText.isEmpty) {
        ref.read(searchInRectProvider.notifier).update();
      }

      _updateText(next.searchText);
      if (next is SearchStateLoading) {
        _focusNode.unfocus();
      }
    });

    return BaladySearchWithBackButton(
      searchInput: BaladyInput.searchV2(
        focusNode: _focusNode,
        onChanged: (query) {
          ref.read(searchProvider(scope.value).notifier).searchQueryChanged(query);
          Metrics.logEventAdvanced(
            MetricsConstants.searchKeys.searchField,
            group: MetricsConstants.searchTag,
            action: MetricAction.type.toString(),
            props: {
              'query': query,
            },
          );
        },
        onTap: () {
          _controller.selection = TextSelection.fromPosition(
            TextPosition(
              offset: _controller.text.length,
            ),
          );
        },
        onSubmitted: (query) async {
          Metrics.logEventAdvanced(
            MetricsConstants.searchKeys.searchField,
            group: MetricsConstants.searchTag,
            action: MetricAction.type.toString(),
            props: {
              'query': query,
            },
          );
          if (query.trim().isNotEmpty) {
            await searcher.searchByText(query);
            await ref.read(searchHistoryProvider(scope.value).notifier).put(
                  SearchHistoryItem(
                    title: query,
                    address: '',
                    objectId: null,
                    entranceId: null,
                    createdAt: DateTime.timestamp().toIso8601String(),
                  ),
                );
            unawaited(ref.read(SendStatisticProvider(query).future));
          }
          _focusNode.requestFocus();
        },
        controller: _controller,
        hintText: context.l10n.search,
        fillColor: context.colorsV2.neutralContainerDefault,
        hintColor: context.colorsV2.foregroundSoft,
        // TODO(uikit): BoxConstraints(0.0<=w<=Infinity, 48.0<=h<=40.0; NOT NORMALIZED)
        textStyle: context.textStyleV3.bodySmallRegular,
      ),
      option: SearchTextBackOption(
        text: context.l10n.cancel,
        onPressed: () {
          FocusScope.of(context).unfocus();
          searcher.clear();
          widget.onClose();
        },
      ),
    );
  }
}
