import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/components.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:provider/provider.dart';

class RoutingSearchBar extends ConsumerStatefulWidget {
  final String placeholder;
  final BaladyInputAffixIcon? affixIcon;

  const RoutingSearchBar({
    required this.placeholder,
    this.affixIcon,
    super.key,
  });

  @override
  ConsumerState<RoutingSearchBar> createState() => _RoutingSearchBarState();
}

class _RoutingSearchBarState extends ConsumerState<RoutingSearchBar> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  final ValueNotifier<bool> _focused = ValueNotifier(false);

  /// DataFinder: tracks the first focus of the box for `is_first_click`.
  bool _searchBoxClicked = false;

  /// Guards `search_box_click` against firing twice for one activation (focus
  /// listener + `onTap`). Reset on focus-loss so the next activation reports.
  bool _boxClickFiredThisFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode()..addListener(_onFocusChanged);
    _focusNode.requestFocus();
  }

  /// Fires the FIRST `search_box_click` on auto-focus; genuine re-taps go
  /// through `onTap`. A mere focus RETURN after a pushed route/dialog closes is
  /// not reported (BRD "Triggered when the search box gains focus").
  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      _boxClickFiredThisFocus = false;
      return;
    }
    if (!mounted || _searchBoxClicked) {
      return;
    }
    _focused.value = true;
    _fireSearchBoxClick();
  }

  /// Emits `search_box_click`, at most once per focus session.
  void _fireSearchBoxClick() {
    if (_boxClickFiredThisFocus || !mounted) {
      return;
    }
    _boxClickFiredThisFocus = true;
    final scopeValue = context.read<SearchScope>().value;
    final searcher = ref.read(searchProvider(scopeValue).notifier);
    ref.read(appAnalyticsProvider).searchBoxClick(
          eventSource: searcher.dataFinderEventSource,
          isFirstClick: !_searchBoxClicked,
        );
    _searchBoxClicked = true;
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
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
    return BaladySearchWithBackButtonV2(
      searchInput: BaladyTextInput.search(
        controller: _controller,
        affixIcon: widget.affixIcon,
        config: BaladyInputConfig(
          focusNode: _focusNode,
          onTap: () {
            ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.journeySearch);
            // DataFinder: report genuine re-taps (first focus is handled by the
            // focus listener). A focus return after a dialog closes is skipped.
            _fireSearchBoxClick();
          },
          onChanged: (query) {
            Metrics.logEventAdvanced(
              MetricsConstants.routesKeys.searchSubmit,
              group: MetricsConstants.routesTag,
              action: MetricAction.type.toString(),
              props: {'query': query},
            );

            // DataFinder: report the manual text input.
            ref.read(appAnalyticsProvider).searchBoxInput(
                  operationType: DataFinderInputOperation.manual,
                  inputText: query,
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
            // DataFinder: report the search submit (keyboard action).
            if (query.trim().isNotEmpty) {
              ref.read(appAnalyticsProvider).searchButtonClick(
                    eventSource: ref.read(searchProvider(scope.value).notifier).dataFinderEventSource,
                    searchText: query,
                  );
            }
            BssService.instance.sendEvent(
              BssRequest(
                eventType: BSSEventType.action,
                actionType: BSSActionType.tap,
                uiElement: const BssUIElement(
                  name: BssUIElementNames.searchStart,
                  ownerName: BssUIElementNames.searchBar,
                ),
                payload: BssPayload(searchRequest: BssSearchRequest(text: query)),
              ),
            );
            if (query.trim().isNotEmpty) {
              ref.read(searchProvider(scope.value).notifier).searchByText(query);
              ref
                  .read(urbiAnalyticsProvider)
                  .track(
                    '${MetricsConstants.searchTag}::${MetricsConstants.searchKeys.searchButtonPressed}',
                  );

              ref
                  .read(searchHistoryProvider(scope.value).notifier)
                  .put(
                    SearchHistoryItem.fromQuery(query: query).toMessage(),
                  );
            }
          },
          hintText: widget.placeholder,
          fillColor: context.colors.neutralContainerDefault,
          hintColor: context.colors.foregroundSoft,
          textStyle: context.textStyles.bodySmallRegular,
        ),
      ),
      option: SearchTextBackOption(
        text: context.l10n.cancel,
        onPressed: () {
          Metrics.logEventAdvanced(
            MetricsConstants.routesKeys.searchBackButton,
            group: MetricsConstants.routesTag,
            action: MetricAction.tap.toString(),
          );
          FocusScope.of(context).unfocus();
          context.router.pop();
        },
      ),
    );
  }
}
