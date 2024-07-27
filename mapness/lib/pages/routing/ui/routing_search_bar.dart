import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:provider/provider.dart';

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
  late TextEditingController _controller;
  final ValueNotifier<bool> _focused = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode()
      ..addListener(() {
        if (_focusNode.hasFocus) {
          _focused.value = true;
        }
      });
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = context.watch<SearchScope>();
    ref.listen(searchProvider(scope.value), (previous, next) {
      if (next.searchText != _controller.text) {
        _controller
          ..text = next.searchText
          ..selection = TextSelection.collapsed(offset: _controller.text.length);
      }
    });
    return BaladySearchWithBackButton(
      searchInput: BaladyInput.searchV2(
        focusNode: _focusNode,
        onChanged: (query) {
          Metrics.logEventAdvanced(
            MetricsConstants.routesKeys.searchSubmit,
            group: MetricsConstants.routesTag,
            action: MetricAction.type.toString(),
            props: {'query': query},
          );

          ref.read(searchProvider(scope.value).notifier).searchQueryChanged(query);
        },
        onSubmitted: (query) {
          Metrics.logEventAdvanced(
            MetricsConstants.routesKeys.searchSubmit,
            group: MetricsConstants.routesTag,
            action: MetricAction.type.toString(),
            props: {'query': query},
          );
          ref.read(searchProvider(scope.value).notifier).searchByText(query);
          if (query.isNotEmpty) {
            ref.read(searchHistoryProvider(scope.value).notifier).put(
                  SearchHistoryItem.fromQuery(query: query),
                );
          }
        },
        controller: _controller,
        hintText: widget.placeholder,
        fillColor: context.colorsV2.neutralContainerDefault,
        hintColor: context.colorsV2.foregroundSoft,
        textFieldHeight: 40,
        textStyle: context.textStyleV3.bodySmallRegular,
      ),
      onBackButtonPressed: () {
        Metrics.logEventAdvanced(
          MetricsConstants.routesKeys.searchBackButton,
          group: MetricsConstants.routesTag,
          action: MetricAction.tap.toString(),
        );
        context.pop();
      },
      backButtonLabel: context.l10n.cancel,
    );
  }
}
