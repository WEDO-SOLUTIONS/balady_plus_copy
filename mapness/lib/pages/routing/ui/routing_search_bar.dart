import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/components.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
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
    return BaladySearchWithBackButtonV2(
      searchInput: BaladyTextInput.search(
        controller: _controller,
        affixIcon: widget.affixIcon,
        config: BaladyInputConfig(
          focusNode: _focusNode,
          onTap: () {
            ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.journeySearch);
          },
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
