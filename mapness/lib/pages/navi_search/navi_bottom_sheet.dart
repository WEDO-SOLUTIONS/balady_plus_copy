import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/landing/search_in_rect.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/landing/landing_state_mapper.dart';
import 'package:mapness/pages/map_search/ui/map_search_content_v2.dart';
import 'package:mapness/pages/navi_search/ui/navi_search_content.dart';
import 'package:mapness/pages/navi_search/ui/navi_search_header.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/rubric_marker_type_mapper.dart';
import 'package:sheetify/sheetify.dart';

/// Search sheet that is shown on the explore screen.
class NaviBottomSheet extends ConsumerStatefulWidget {
  final bool isPathNavScreen;

  const NaviBottomSheet({super.key, this.isPathNavScreen = false});

  @override
  ConsumerState<NaviBottomSheet> createState() => _NaviBottomSheetState();
}

class _NaviBottomSheetState extends ConsumerState<NaviBottomSheet> with WidgetsBindingObserver {
  late final MultiStateSheetController<ThreeStateSheet> _multiStateSheetController;
  double currentSize = 0.1;
  late final StreamSubscription<bool> _keyboardVisible;
  final _kbVisibilityController = KeyboardVisibilityController();
  final _settings = MapObjectManagerSettings.search();
  StreamSubscription<TapEvent>? _streamSubscription;
  final _scope = SearchScopeEnum.navi.value;
  ThreeStateSheet _sheetState = ThreeStateSheet.expanded;
  Color? _barrierColor;
  bool _showMoreQuickFilters = false;
  DgisMapController? _dgisController;

  final outsideOpacityDelegate = StatefulSheetDelegate.func<double, ThreeStateSheet>((controller) {
    final fraction = controller.fraction;
    final state = controller.state;

    return state.index < 1 ? 1.0 : max(0.0, 1 - (fraction - 0.4) * 9);
  });

  late final barrierColorDelegate = StatefulSheetDelegate.func<Color?, ThreeStateSheet>((controller) {
    final state = controller.state;
    return state.index > 1 ? _barrierColor : null;
  });

  @override
  void initState() {
    super.initState();
    if (widget.isPathNavScreen) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    }

    _dgisController = ref.read(dgisControllerProvider).value;
    _dgisController?.stopFollowNavigation();
    _dgisController?.setCameraPositionPoint(CameraPositionPointMessage(x: 0.5, y: 0.5));

    _multiStateSheetController = MultiStateSheetController<ThreeStateSheet>(
      behavior: MultiSnappingBehavior(
        models: [
          FractionSnappingModel({.8, 1.0}),
          ComponentsSnappingModel(componentsDescriptions: [const SnapComponent.size(component: Components.header)]),
        ],
      ),
      stateMapper: const LandingStateMapper(),
      initialState: ThreeStateSheet.expanded,
    );

    _keyboardVisible = _kbVisibilityController.onChange.listen(_onKeyboardToggle);
    WidgetsBinding.instance.addObserver(this);
    _multiStateSheetController.addListener(_onSheetChanged);
  }

  void _onSheetChanged() {
    if (!mounted) {
      return;
    }
    final newState = _multiStateSheetController.state;
    if (newState == ThreeStateSheet.hidden) {
      _unfocusSearchField();
    }
    if (newState != _sheetState) {
      setState(() {
        _sheetState = newState;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _barrierColor = context.colors.screenOverlayDimming40;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _unfocusSearchField();
    }
  }

  @override
  void deactivate() {
    _dgisController?.startFollowNavigation();
    _dgisController?.setCameraPositionPoint(CameraPositionPointMessage(x: 0.5, y: 0.85));
    super.deactivate();
  }

  @override
  void dispose() {
    if (widget.isPathNavScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    _multiStateSheetController
      ..removeListener(_onSheetChanged)
      ..dispose();
    _keyboardVisible.cancel();

    _streamSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchObjectManager = ref.watch(
      mapObjectManagerProvider(named: _settings.name, layerId: _settings.layerId).notifier,
    );
    ref.listen(searchProvider(_scope), (previous, next) {
      if (!mounted) {
        return;
      }
      if (_showMoreQuickFilters && next is! SearchStateHistory) {
        _setShowMoreQuickFilters(false);
      }
      _drawSearchMarkers(next, previous, searchObjectManager);
    });

    return SearchScope(
      named: SearchScopeEnum.navi,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) {
              _unfocusSearchField();
              _collapseBottomSheet();
            },
          ),
          NotificationListener<ScrollNotification>(
            onNotification: _onNotification,
            child: MultiStateSheet<ThreeStateSheet>(
              keepContentBehindFooter: true,
              scrollController: _multiStateSheetController,
              outsideOpacityDelegate: outsideOpacityDelegate,
              barrierColorDelegate: barrierColorDelegate,
              safeAreaColor: _sheetState == ThreeStateSheet.hidden || _showMoreQuickFilters
                  ? context.colors.backgroundSurface1
                  : context.colors.backgroundSurface4,
              dragger: null,
              backgroundColor: context.colors.backgroundSurface4,
              key: const ValueKey('NAVI SEARCH SHEET'),
              header: NaviSearchHeader(
                backgroundColor: context.colors.backgroundSurface1,
                requestFocus: true,
                onClose: onClose,
                showLeadingBackButton: _showMoreQuickFilters,
                onLeadingBackPressed: () => _setShowMoreQuickFilters(false),
              ),
              sliver: SliverToBoxAdapter(
                child: NaviSearchContent(
                  bottomSheetContentScrollController: _multiStateSheetController,
                  showMoreQuickFilters: _showMoreQuickFilters,
                  onMoreQuickFiltersChanged: _setShowMoreQuickFilters,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _drawSearchMarkers(
    SearchState searchState,
    SearchState? prevState,
    MapObjectManager mapObjectManager,
  ) async {
    if (searchState is SearchStateResults &&
        (prevState is! SearchStateResults || prevState.results != searchState.results)) {
      final mapMarkerMapper = ref.read(rubricMarkerMapperProvider.notifier);

      final isRtl = ref.read(appLanguageProvider) == Language.arabic;
      final dark = await ref.watch(darkModeProvider.future);
      final activeCityEvent = ref.read(activeCityEventProvider);

      final markers = await searchState.results.getMarkers(
        router: ref.read(appRouterProvider),
        iconResolver: mapMarkerMapper.getMarkerType,
        activeCityEvent: activeCityEvent,
        isRtl: isRtl,
        isDark: dark.isDark,
      );
      if (!ref.read(searchInRectProvider(_scope)).isSearchInThisAreaRequest) {
        ref.read(searchInRectProvider(_scope).notifier).searchInThisAreaSwitch(value: false);
        await mapObjectManager.removeAllMarkers();
      }
      await mapObjectManager.addMarkers(markers);
    } else if (searchState is SearchStateEmpty || searchState is SearchStateHistory && searchState.searchText.isEmpty) {
      await mapObjectManager.removeAllMarkers();
    }
  }

  bool _onNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      // BSA-1103
      // We need to check if the user is dragging the sheet
      // If not we don't need to unfocus the search field
      //
      // This check is necessary because the [ScrollStartNotification] is called even on the scroll of the TextField
      // when the user is typing a long text and the TextField is scrolling to show it
      if (notification.dragDetails != null) {
        _unfocusSearchField();
        MapSearchContent.scrollSendEvent(
          searchState: ref.read(searchProvider(_scope)),
          historyListSize: ref.read(searchHistoryProvider(_scope)).length,
          sendEvent: BssService.instance.sendEvent,
        );
      }
    }
    return true;
  }

  void _unfocusSearchField() {
    if (_kbVisibilityController.isVisible && _multiStateSheetController.interpolation == 0) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void _onKeyboardToggle(bool kbState) {
    if (!kbState || _multiStateSheetController.state == ThreeStateSheet.expanded) {
      return;
    }

    _multiStateSheetController.setState(ThreeStateSheet.expanded);
  }

  void onClose() {
    _removeAllMarkersAndPop();
  }

  void _removeAllMarkersAndPop() {
    ref.read(mapObjectManagerProvider(named: _settings.name, layerId: _settings.layerId).notifier).removeAllMarkers();
    ref.read(searchInRectProvider(_scope).notifier).update();
    context.router.pop();
  }

  void _collapseBottomSheet() {
    _multiStateSheetController.setState(ThreeStateSheet.hidden);
  }

  void _setShowMoreQuickFilters(bool value) {
    if (!mounted || _showMoreQuickFilters == value) {
      return;
    }
    setState(() => _showMoreQuickFilters = value);
  }
}
