import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/landing/search_in_rect.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/features/search/ui/search_scope.dart' as scope;
import 'package:mapness/shared/constants/metrics_constants.dart' as metric_const;
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart' as metrics;
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:provider/provider.dart';

/// Exposes listener notification for uikit sync when [BaladyTextInput] is recreated but text is unchanged.
class _MapSearchTextEditingController extends TextEditingController {
  void notifySuffixSync() => notifyListeners();
}

/// Search field for map / navi / favourites. Owns [TextEditingController] and [FocusNode]
/// so the parent sheet must not create or dispose them — avoids use-after-dispose races.
class MapSearchBar extends ConsumerStatefulWidget {
  final bool requestFocus;
  final VoidCallback onClose;
  final bool isCloseButton;
  final String? initialState;
  final bool showLeadingBackButton;
  final VoidCallback? onLeadingBackPressed;

  /// Fires synchronously on every tap on the field, before focus / keyboard work.
  /// Parents use this to expand the enclosing bottom sheet without waiting for
  /// `flutter_keyboard_visibility`, whose `onChange` signal is unreliable on
  /// Android when the keyboard reopens on the same screen (BALADY-3580).
  final VoidCallback? onTap;

  const MapSearchBar({
    required this.requestFocus,
    required this.onClose,
    this.isCloseButton = false,
    this.showLeadingBackButton = false,
    this.onLeadingBackPressed,
    this.onTap,
    super.key,
    this.initialState,
  });

  @override
  ConsumerState<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends ConsumerState<MapSearchBar> {
  late final _MapSearchTextEditingController _controller;
  late final FocusNode _focusNode;
  ProviderSubscription<SearchState>? _searchSubscription;
  final _scope = scope.SearchScopeEnum.map.value;
  bool _initialFocusScheduled = false;
  Animation<double>? _routeAnimation;
  void Function(AnimationStatus)? _routeAnimationStatusListener;

  void _safeControllerWrite(VoidCallback action) {
    try {
      action();
    } catch (_) {
      // Ignore if internals detached during transitions.
    }
  }

  void _safeFocusAction(VoidCallback action) {
    try {
      action();
    } catch (_) {
      // Ignore if focus node disposed / detached.
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = _MapSearchTextEditingController();
    _focusNode = FocusNode();
    if (widget.initialState != null) {
      _updateText(widget.initialState!);
      ref.read(searchProvider(_scope).notifier).fetchSuggest(_controller.text);
    }
  }

  /// Defers initial keyboard until the page transition animation completes —
  /// otherwise the keyboard fights the route animation and the user perceives lag.
  void _scheduleInitialFocus() {
    if (_initialFocusScheduled || !widget.requestFocus) {
      return;
    }
    _initialFocusScheduled = true;
    final animation = ModalRoute.of(context)?.animation;
    if (animation == null || animation.status == AnimationStatus.completed) {
      _safeFocusAction(_focusNode.requestFocus);
      return;
    }
    void listener(AnimationStatus status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        animation.removeStatusListener(listener);
        _routeAnimation = null;
        _routeAnimationStatusListener = null;
        if (mounted && status == AnimationStatus.completed) {
          _safeFocusAction(_focusNode.requestFocus);
        }
      }
    }
    _routeAnimation = animation;
    _routeAnimationStatusListener = listener;
    animation.addStatusListener(listener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleInitialFocus();
    _searchSubscription?.close();
    final scope = context.read<SearchScope>();
    _searchSubscription = ref.listenManual<SearchState>(
      searchProvider(scope.value),
      (previous, next) {
        if (!mounted) {
          return;
        }
        final isSearchInRectRequest = ref.read(searchInRectProvider(scope.value)).isSearchInThisAreaRequest;
        if (next.searchText.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            ref.read(searchInRectProvider(scope.value).notifier).update();
          });
        }

        _updateText(next.searchText);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }
          if (next is SearchStateLoading) {
            _safeFocusAction(_focusNode.unfocus);
          } else if (next is SearchStateResults && !isSearchInRectRequest && previous is SearchStateLoading) {
            _safeFocusAction(_focusNode.requestFocus);
          }
        });
      },
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    final listener = _routeAnimationStatusListener;
    if (listener != null) {
      _routeAnimation?.removeStatusListener(listener);
    }
    _routeAnimation = null;
    _routeAnimationStatusListener = null;
    _searchSubscription?.close();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateText(String text) {
    _safeControllerWrite(() {
      final unchanged = text == _controller.text;
      if (!unchanged) {
        _controller
          ..text = text
          ..selection = TextSelection.collapsed(offset: _controller.text.length);
      } else if (text.isNotEmpty) {
        // Programmatic text already matches, but BaladyTextInput may have been recreated (e.g. toggling
        // more-filters changes BaladySearchWithBackButtonV2 layout: option null vs Row). New State starts
        // with _showClearButton=false and only the controller listener updates it — no notification if text
        // did not change. Ping listeners so the in-field clear icon syncs.
        _controller.notifySuffixSync();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scope = context.read<SearchScope>();
    final searcher = ref.watch(searchProvider(scope.value).notifier);

    return _buildSearchRow(context, scope, searcher);
  }

  Widget _buildSearchRow(BuildContext context, SearchScope scope, Search searcher) {
    // Always keep BaladySearch under Expanded — never swap between "bare" vs Row+Expanded.
    // Otherwise toggling showLeadingBackButton disposes the text field; if uikit disposes the
    // passed controller, our State still owns a dead controller and crashes next sync.
    final searchField = BaladySearchWithBackButtonV2(
      key: const ValueKey('map-search-balady-field'),
      searchInput: BaladyTextInput.search(
        controller: _controller,
        config: BaladyInputConfig(
          isDisposed: false,
          focusNode: _focusNode,
          onChanged: (query) {
            ref.read(searchInRectProvider(scope.value).notifier).update();
            ref.read(searchProvider(scope.value).notifier).searchQueryChanged(query);
            BssService.instance.sendEvent(
              BssRequest(
                eventType: BSSEventType.action,
                actionType: BSSActionType.textInput,
                uiElement: const BssUIElement(
                  name: BssUIElementNames.searchBar,
                  ownerName: BssUIElementNames.directorySearchScreen,
                ),
                payload: BssPayload(searchRequest: BssSearchRequest(text: query)),
              ),
            );
            metrics.Metrics.logEventAdvanced(
              metric_const.MetricsConstants.searchKeys.searchField,
              group: metric_const.MetricsConstants.searchTag,
              action: metrics.MetricAction.type.toString(),
              props: {'query': query},
            );
          },
          onTap: () {
            // Notify parent first so it can synchronously expand the enclosing
            // bottom sheet — this is the reliable signal on Android, instead of
            // waiting for `flutter_keyboard_visibility` (BALADY-3580).
            widget.onTap?.call();
            ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.journeySearch);
            BssService.instance.sendEvent(
              const BssRequest(
                eventType: BSSEventType.action,
                actionType: BSSActionType.tap,
                uiElement: BssUIElement(
                  name: BssUIElementNames.searchBar,
                  ownerName: BssUIElementNames.directorySearchScreen,
                ),
              ),
            );
          },
          onSubmitted: (query) {
            metrics.Metrics.logEventAdvanced(
              metric_const.MetricsConstants.searchKeys.searchField,
              group: metric_const.MetricsConstants.searchTag,
              action: metrics.MetricAction.type.toString(),
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
              searcher.searchByText(query);
              ref
                  .read(urbiAnalyticsProvider)
                  .track(
                    '${metric_const.MetricsConstants.searchTag}::${metric_const.MetricsConstants.searchKeys.searchButtonPressed}',
                  );
              ref
                  .read(searchHistoryProvider(scope.value).notifier)
                  .put(SearchHistoryItem.fromQuery(query: query).toMessage());
            }
            _safeFocusAction(_focusNode.requestFocus);
          },
          hintText: context.l10n.searchPlaceOrAddress,
          fillColor: context.colors.neutralContainerDefault,
          hintColor: context.colors.foregroundSoft,
          textStyle: context.textStyles.bodySmallRegular,
        ),
      ),
      option: widget.showLeadingBackButton
          ? null
          : widget.isCloseButton
          ? SearchIconBackOption(icon: SystemIcons.close, onPressed: () => _onBackPressed(searcher))
          : SearchTextBackOption(text: context.l10n.cancel, onPressed: () => _onBackPressed(searcher)),
    );

    if (!widget.showLeadingBackButton) {
      return searchField;
    }

    return Row(
      children: [
        AppButton(
          buttonColorScheme: ButtonColorScheme.neutral,
          buttonType: ButtonType.secondary,
          primaryIcon: SystemIcons.arrowCornerLeftSmall,
          onTap: widget.onLeadingBackPressed,
          padding: const EdgeInsets.all(0),
          innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
        ),
        const SizedBox(width: Spacing.$3x),
        Expanded(child: searchField),
      ],
    );
  }

  void _onBackPressed(Search searcher) {
    FocusScope.of(context).unfocus();
    searcher.clear();
    widget.onClose();
  }
}
