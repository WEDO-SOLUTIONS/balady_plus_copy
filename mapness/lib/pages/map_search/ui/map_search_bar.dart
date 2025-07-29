import 'dart:async';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/landing/search_in_rect.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/features/statistic/providers/statistics_provider.dart';
import 'package:mapness/shared/constants/metrics_constants.dart' as metric_const;
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart' as metrics;
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:provider/provider.dart';

class MapSearchBar extends ConsumerStatefulWidget {
  final bool requestFocus;
  final VoidCallback onClose;
  final bool isCloseButton;

  const MapSearchBar({
    required this.requestFocus,
    required this.onClose,
    this.isCloseButton = false,
    super.key,
  });

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
      final isSearchInRectRequest = ref.read(searchInRectProvider(scope.value)).isSearchInThisAreaRequest;
      if (next.searchText.isEmpty) {
        ref.read(searchInRectProvider(scope.value).notifier).update();
      }

      _updateText(next.searchText);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (next is SearchStateLoading) {
          _focusNode.unfocus();
        } else if (next is SearchStateResults && !isSearchInRectRequest && previous is SearchStateLoading) {
          _focusNode.requestFocus();
        }
      });
    });

    return BaladySearchWithBackButtonV2(
      searchInput: BaladyTextInput.search(
        controller: _controller,
        config: BaladyInputConfig(
          focusNode: _focusNode,
          onChanged: (query) {
            ref.read(searchInRectProvider(scope.value).notifier).update();
            ref.read(searchProvider(scope.value).notifier).searchQueryChanged(query);
            BssService.instance.sendEvent(
              visibleRect: ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect,
              BssRequest(
                eventType: BSSEventType.action,
                actionType: BSSActionType.textInput,
                uiElement: const BssUIElement(
                  name: BssUIElementNames.searchBar,
                  ownerName: BssUIElementNames.directorySearchScreen,
                ),
                payload: BssPayload(
                  searchRequest: BssSearchRequest(text: query),
                ),
              ),
            );
            metrics.Metrics.logEventAdvanced(
              metric_const.MetricsConstants.searchKeys.searchField,
              group: metric_const.MetricsConstants.searchTag,
              action: metrics.MetricAction.type.toString(),
              props: {
                'query': query,
              },
            );
          },
          onTap: () {
            ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.journeySearch);
            BssService.instance.sendEvent(
              visibleRect: ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect,
              const BssRequest(
                eventType: BSSEventType.action,
                actionType: BSSActionType.tap,
                uiElement: BssUIElement(
                  name: BssUIElementNames.searchBar,
                  ownerName: BssUIElementNames.directorySearchScreen,
                ),
              ),
            );
            _controller.selection = TextSelection.fromPosition(
              TextPosition(
                offset: _controller.text.length,
              ),
            );
          },
          onSubmitted: (query) async {
            metrics.Metrics.logEventAdvanced(
              metric_const.MetricsConstants.searchKeys.searchField,
              group: metric_const.MetricsConstants.searchTag,
              action: metrics.MetricAction.type.toString(),
              props: {
                'query': query,
              },
            );
            await BssService.instance.sendEvent(
              visibleRect: ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect,
              BssRequest(
                eventType: BSSEventType.action,
                actionType: BSSActionType.tap,
                uiElement: const BssUIElement(
                  name: BssUIElementNames.searchStart,
                  ownerName: BssUIElementNames.searchBar,
                ),
                payload: BssPayload(
                  searchRequest: BssSearchRequest(text: query),
                ),
              ),
            );
            if (query.trim().isNotEmpty) {
              await searcher.searchByText(query);
              await ref.read(urbiAnalyticsProvider).track(
                    '${metric_const.MetricsConstants.searchTag}::${metric_const.MetricsConstants.searchKeys.searchButtonPressed}',
                  );
              await ref.read(searchHistoryProvider(scope.value).notifier).put(
                    SearchHistoryItem.fromQuery(query: query),
                  );
              unawaited(ref.read(SendStatisticProvider(query).future));
            }
            _focusNode.requestFocus();
          },

          hintText: context.l10n.search,
          fillColor: context.colors.neutralContainerDefault,
          hintColor: context.colors.foregroundSoft,
          // TODO(uikit): BoxConstraints(0.0<=w<=Infinity, 48.0<=h<=40.0; NOT NORMALIZED)
          textStyle: context.textStyles.bodySmallRegular,
        ),
      ),
      option: widget.isCloseButton
          ? SearchIconBackOption(
              icon: SystemIcons.close,
              onPressed: () => _onBackPressed(searcher),
            )
          : SearchTextBackOption(
              text: context.l10n.cancel,
              onPressed: () => _onBackPressed(searcher),
            ),
    );
  }

  void _onBackPressed(Search searcher) {
    FocusScope.of(context).unfocus();
    searcher.clear();
    widget.onClose();
  }
}
