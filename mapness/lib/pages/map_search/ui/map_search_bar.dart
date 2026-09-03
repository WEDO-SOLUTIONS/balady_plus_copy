import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';
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
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:provider/provider.dart';

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
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  ProviderSubscription<SearchState>? _searchSubscription;
  final _scope = scope.SearchScopeEnum.map.value;
  bool _initialFocusScheduled = false;
  Animation<double>? _routeAnimation;
  void Function(AnimationStatus)? _routeAnimationStatusListener;

  /// DataFinder: tracks the first focus of the search box for `is_first_click`.
  bool _searchBoxClicked = false;

  /// Suppresses the `search_box_click` focus listener during the internal
  /// unfocus→refocus cycle that runs after search results load (see
  /// [didChangeDependencies]) — that refocus is not a user action.
  //bool _suppressFocusEvent = false;

  /// Guards against `search_box_click` firing twice for the same activation
  /// (focus listener + `onTap`). Reset whenever the box loses focus, so the
  /// next genuine activation reports again.
  // bool _boxClickFiredThisFocus = false;

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
    _controller = TextEditingController();
    _focusNode = FocusNode();
    // DataFinder: fire `search_box_click` whenever the box GAINS FOCUS, not just
    // on a manual tap — this covers programmatic auto-focus on open (BRD:
    // "Triggered when the search box gains focus").
    // _focusNode.addListener(_onFocusChanged);
    // if (widget.requestFocus) {
    //   _safeFocusAction(_focusNode.requestFocus);
    // }
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

  /// Fires the FIRST `search_box_click` when the box auto-focuses on open.
  /// Later activations are reported from the field's `onTap` (genuine user taps
  /// only) so we don't emit a spurious event when focus merely *returns* to the
  /// box after a pushed route/dialog (e.g. the favourite sheet) closes.
  // void _onFocusChanged() {
  //   if (!_focusNode.hasFocus) {
  //     // Box lost focus → allow the next genuine activation to report again.
  //     _boxClickFiredThisFocus = false;
  //     return;
  //   }
  //   if (!mounted || _suppressFocusEvent || _searchBoxClicked) {
  //     return;
  //   }
  //   _fireSearchBoxClick();
  // }

  /// Emits `search_box_click` with the current source, at most once per focus
  /// session (the focus listener and `onTap` share this guard). [isFirstClick]
  /// is true only for the very first activation after the bar opened.
  void _fireSearchBoxClick() {
    // if (_boxClickFiredThisFocus || !mounted) {
    //   return;
    // }
    // _boxClickFiredThisFocus = true;
    final searcher = ref.read(searchProvider(_scope).notifier);
    ref
        .read(appAnalyticsProvider)
        .searchBoxClick(
          eventSource: searcher.dataFinderEventSource,
          isFirstClick: !_searchBoxClicked,
        );
    _searchBoxClicked = true;
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
      if (text != _controller.text) {
        _controller
          ..text = text
          ..selection = TextSelection.collapsed(offset: _controller.text.length);
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
            // DataFinder: report the manual text input.
            ref
                .read(appAnalyticsProvider)
                .searchBoxInput(
                  operationType: DataFinderInputOperation.manual,
                  inputText: query,
                );
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
          },
          onTap: () {
            ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.journeySearch);
            // DataFinder: the FIRST search_box_click comes from the focus
            // listener (covers auto-focus on open). Genuine RE-taps after the
            // box lost focus are reported here, so we don't miss them — but a
            // mere focus RETURN (e.g. after the favourite sheet closes) is not a
            // tap and is correctly skipped.
            widget.onTap?.call();
            _fireSearchBoxClick();
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
              // DataFinder: report the search submit (keyboard action).
              ref
                  .read(appAnalyticsProvider)
                  .searchButtonClick(
                    eventSource: searcher.dataFinderEventSource,
                    searchText: query,
                  );
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
