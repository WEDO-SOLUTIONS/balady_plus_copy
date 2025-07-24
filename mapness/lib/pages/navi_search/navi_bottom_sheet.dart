import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/landing/search_in_rect.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/navi_search/ui/navi_search_content.dart';
import 'package:mapness/pages/navi_search/ui/navi_search_controls.dart';
import 'package:mapness/pages/navi_search/ui/navi_search_header.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/bottom_sheet_controller_helper_extension.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/rubric_marker_type_mapper.dart';

/// Search sheet that is shown on the explore screen.
class NaviBottomSheet extends ConsumerStatefulWidget {
  final bool isPathNavScreen;

  const NaviBottomSheet({
    super.key,
    this.isPathNavScreen = false,
  });

  @override
  ConsumerState<NaviBottomSheet> createState() => _NaviBottomSheetState();
}

class _NaviBottomSheetState extends ConsumerState<NaviBottomSheet> with WidgetsBindingObserver {
  late final StatefulBottomSheetController<ThreeStateBottomSheet> _statefulBottomSheetController;
  double currentSize = 0.1;
  late final StreamSubscription<bool> _keyboardVisible;
  final _kbVisibilityController = KeyboardVisibilityController();
  final _settings = MapObjectManagerSettings.search();
  StreamSubscription<TapEvent>? _streamSubscription;
  final _scope = SearchScopeEnum.navi.value;

  @override
  void initState() {
    super.initState();
    if (widget.isPathNavScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    ref.read(dgisControllerProvider).valueOrNull?.stopFollowNavigation();
    ref.read(dgisControllerProvider).value?.setCameraPositionPoint(CameraPositionPointMessage(x: 0.5, y: 0.5));

    _statefulBottomSheetController = StatefulBottomSheetController<ThreeStateBottomSheet>(
      behavior: MultiSnappingBehavior(
        models: [
          AspectRatioSnappingModel({.7, .931}),
          ComponentsSnappingModel(componentsDescriptions: [const SnapComponent.size(component: Components.header)]),
        ],
      ),
      stateMapper: const ThreeStateMapper(),
      initialState: ThreeStateBottomSheet.open,
    );

    _keyboardVisible = _kbVisibilityController.onChange.listen(_onKeyboardToggle);
    WidgetsBinding.instance.addObserver(this);

    _statefulBottomSheetController.addListener(() {
      if (_statefulBottomSheetController.state == ThreeStateBottomSheet.hidden) {
        _unfocusSearchField();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _unfocusSearchField();
    }
  }

  @override
  void deactivate() {
    ref.read(dgisControllerProvider).valueOrNull?.startFollowNavigation();
    ref.read(dgisControllerProvider).value?.setCameraPositionPoint(CameraPositionPointMessage(x: 0.5, y: 0.85));
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

    _statefulBottomSheetController.dispose();
    _keyboardVisible.cancel();

    _streamSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchObjectManager = ref.watch(
      mapObjectManagerProvider(
        named: _settings.name,
        layerId: _settings.layerId,
      ).notifier,
    );
    ref.listen(
      searchProvider(_scope),
      (previous, next) {
        _drawSearchMarkers(next, previous, searchObjectManager);
      },
    );

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
            child: StatefulBottomSheet<ThreeStateBottomSheet>(
              animateOpening: false,
              keepContentBehindFooter: true,
              scrollController: _statefulBottomSheetController,
              outsideOpacityDelegate: _statefulBottomSheetController.defaultOpacityDelegate,
              outside: NaviSearchSheetControls(_statefulBottomSheetController),
              safeAreaColor: context.colorsV3.backgroundSurface2,
              displayDragger: false,
              backgroundColor: context.colorsV3.backgroundSurface4,
              key: const ValueKey('NAVI SEARCH SHEET'),
              header: NaviSearchHeader(
                backgroundColor: context.colorsV3.backgroundSurface2,
                requestFocus: false,
                onClose: () => context.router.popForced(),
              ),
              sliverBeforeContent: NaviSearchContent(
                bottomSheetContentScrollController: _statefulBottomSheetController,
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

      final markers = await searchState.results.getMarkers(
        router: ref.read(appRouterProvider),
        iconResolver: mapMarkerMapper.getMarkerType,
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
      }
    }
    return true;
  }

  void _unfocusSearchField() {
    if (_kbVisibilityController.isVisible && _statefulBottomSheetController.interpolation == 0) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void _onKeyboardToggle(bool kbState) {
    if (!kbState || _statefulBottomSheetController.state == ThreeStateBottomSheet.expanded) {
      return;
    }

    _statefulBottomSheetController.setState(ThreeStateBottomSheet.expanded);
  }

  void onClose() {
    Metrics.logEventAdvanced(
      MetricsConstants.searchKeys.exitIcon,
      group: MetricsConstants.searchTag,
      action: MetricAction.tap.toString(),
    );
    _removeAllMarkersAndPop();
  }

  void _removeAllMarkersAndPop() {
    ref
        .read(
          mapObjectManagerProvider(
            named: _settings.name,
            layerId: _settings.layerId,
          ).notifier,
        )
        .removeAllMarkers();
    ref.read(searchInRectProvider(_scope).notifier).update();
    context.router.popForced();
  }

  void _collapseBottomSheet() {
    _statefulBottomSheetController.setState(ThreeStateBottomSheet.hidden);
  }
}
