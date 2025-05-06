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
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/landing/search_in_rect.dart';
import 'package:mapness/features/map_tap_handler/map_tap_handler_provider.dart';
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
  late final StreamSubscription<bool> _keyboardVisible;
  final _kbVisibilityController = KeyboardVisibilityController();
  final _settings = MapObjectManagerSettings.search();
  StreamSubscription<TapEvent>? _streamSubscription;

  late final StatefulBottomSheetController<ThreeStateBottomSheet> _bottomSheetController;

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

    _bottomSheetController = StatefulBottomSheetController<ThreeStateBottomSheet>(
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
    _setupTapListener();
    WidgetsBinding.instance.addObserver(this);

    _bottomSheetController.addListener(() {
      if (_bottomSheetController.state == ThreeStateBottomSheet.hidden) {
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

    _bottomSheetController.dispose();
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
      searchProvider(SearchScopeEnum.map.value),
      (previous, next) {
        _drawSearchMarkers(next, previous, searchObjectManager);
      },
    );

    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (_) {
            _unfocusSearchField();
            _collapseBottomSheet();
          },
        ),

        ///
        SearchScope(
          named: SearchScopeEnum.map,
          child: StatefulBottomSheet<ThreeStateBottomSheet>(
            outsideOpacityDelegate: _bottomSheetController.defaultOpacityDelegate,
            outside: NaviSearchSheetControls(_bottomSheetController),
            scrollController: _bottomSheetController,
            safeAreaColor: context.colorsV3.backgroundSurface2,
            displayDragger: false,
            backgroundColor: context.colorsV3.backgroundSurface4,
            header: NaviSearchHeader(
              backgroundColor: context.colorsV3.backgroundSurface2,
              requestFocus: false,
              onClose: () => context.router.popForced(),
            ),
            sliverBeforeContent: NaviSearchContent(
              scrollController: _bottomSheetController,
            ),
          ),
        ),
      ],
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
      if (!ref.read(searchInRectProvider).isSearchInThisAreaRequest) {
        ref.read(searchInRectProvider.notifier).searchInThisAreaSwitch(value: false);
        await mapObjectManager.removeAllMarkers();
      }
      await mapObjectManager.addMarkers(markers);
    } else if (searchState is SearchStateEmpty || searchState is SearchStateHistory && searchState.searchText.isEmpty) {
      await mapObjectManager.removeAllMarkers();
    }
  }

  void _unfocusSearchField() {
    if (_kbVisibilityController.isVisible && _bottomSheetController.interpolation == 0) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void _onKeyboardToggle(bool kbState) {
    if (!kbState) {
      return;
    }
    final currentExp = _bottomSheetController.state;
    if (currentExp == ThreeStateBottomSheet.expanded || currentExp == ThreeStateBottomSheet.open) {
      return;
    }
    // We need to wait because of the rebuild the sheet state
    // At the build method we recalculate [collapsedHeight] and we secretly call the [didUpdateWidget] method
    // of [_dgisSheetController]. And if we call the [animateTo] method before the [didUpdateWidget] method
    // we will get set wrong [Expansion] value
    Future.delayed(Durations.short4).then((_) {
      _bottomSheetController.setState(ThreeStateBottomSheet.expanded);
    });
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
    ref.read(searchInRectProvider.notifier).update();
    context.router.popForced();
  }

  void _setupTapListener() {
    _streamSubscription = ref.read(mapTapHandlerProvider.notifier).listen((_) {
      if (context.router.isRouteActive(SearchRoute.name)) {
        _unfocusSearchField();
        _collapseBottomSheet();
      }
    });
  }

  void _collapseBottomSheet() {
    _bottomSheetController.setState(ThreeStateBottomSheet.hidden);
  }
}
