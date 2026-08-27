import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/pages/landing/landing_page.dart';
import 'package:mapness/widgets/lifestyle_layers/bus/bus_details_content.dart';
import 'package:mapness/widgets/lifestyle_layers/layers_sheet_content.dart';
import 'package:mapness/widgets/lifestyle_layers/parking_details_content.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class LayersSheetPage extends StatefulHookConsumerWidget {
  const LayersSheetPage({super.key});

  @override
  ConsumerState<LayersSheetPage> createState() => LayersSheetPageState();
}

class LayersSheetPageState extends ConsumerState<LayersSheetPage> {
  late final ToggleSheetController _layersController;
  late final ToggleSheetController _parkingLotsController;
  late final ToggleSheetController _busSubMenuController;
  bool _isParkingSheetMounted = false;
  bool _isBusSubMenuSheetMounted = false;
  bool _isClosingRoute = false;

  late final barrierColorDelegate = ToggleSheetDelegateFunction(
    function: (controller) {
      // Fade the dimming in as the sheet opens, up to the opacity the design
      // token already carries — never past it.
      //
      // BALADY-3755: this used to be `withAlpha((fraction * 255).toInt())`,
      // which had two defects. `fraction` can be NaN/Infinity when the host
      // view collapses, and `toInt()` throws `UnsupportedError` on both. And at
      // fraction 1.0 it forced alpha to 255, turning a 55% scrim into a fully
      // opaque one that hid the map completely. Scaling the token's own alpha
      // keeps the maximum at the designed value.
      final fraction = controller.fraction;
      final ratio = fraction.isFinite ? fraction.clamp(0.0, 1.0) : 0.0;
      return screenOverlayDimming40.withAlpha((screenOverlayDimming40.alpha * ratio).round());
    },
  );
  late Color screenOverlayDimming40;

  @override
  void initState() {
    super.initState();

    _layersController = ToggleSheetController(
      durationMultiplier: 2,
      onClose: (_) {
        if (_parkingLotsController.isClosed && _busSubMenuController.isClosed && mounted) {
          _closeRouteWithoutSheetPopScope();
        }
      },
    );
    _parkingLotsController = ToggleSheetController(
      durationMultiplier: 2,
      onClose: (_) {
        if (mounted && _isParkingSheetMounted) {
          setState(() {
            _isParkingSheetMounted = false;
          });
        }
        _layersController.open();
      },
    );
    _busSubMenuController = ToggleSheetController(
      durationMultiplier: 2,
      onClose: (_) {
        if (mounted && _isBusSubMenuSheetMounted) {
          setState(() {
            _isBusSubMenuSheetMounted = false;
          });
        }
        if (mounted) {
          _layersController.open();
        }
      },
    );
  }

  @override
  void dispose() {
    _layersController.dispose();
    _parkingLotsController.dispose();
    _busSubMenuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenOverlayDimming40 = context.colors.screenOverlayDimming40;
    if (_isClosingRoute) {
      return const Scaffold(body: SizedBox.expand());
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ToggleSheet(
            scrollController: _layersController,
            backgroundColor: context.colors.backgroundSurface4,
            safeAreaColor: context.colors.backgroundSurface4,
            dragger: const SheetDragger(),
            outside: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (!_parkingLotsController.isClosed && !_busSubMenuController.isClosed) {
                  _showLayersPanel();
                } else {
                  _hideLayersPanel();
                }
              },
              child: const SizedBox.expand(),
            ),
            barrierColorDelegate: barrierColorDelegate,
            sliver: LayersSheetContent(
              layerTapItems: const {LayerType.parkingLots, LayerType.busSubMenu},
              onIconTap: (layerType) {
                if (layerType == LayerType.parkingLots) {
                  _showParkingLotsPanel();
                } else if (layerType == LayerType.busSubMenu) {
                  _showBusSubMenuPanel();
                }
              },
              onClose: () {
                final tabsRouter = context.innerRouterOf<TabsRouter>(BottomMenuRoute.name);
                final isRoutingOpen = tabsRouter?.current.name == RoutingPointsRoute.name;

                // This trick we use to open the sheet after closing it
                // in order to avoid overlapping of the two sheets
                if (isRoutingOpen) {
                  final controller = ref.read(bottomSheetControllerProvider).controller;
                  final isBottomSheetOpen = controller?.state == ThreeStateSheet.open;
                  if (isBottomSheetOpen) {
                    controller?.setState(ThreeStateSheet.open);
                  }
                }
                _closeRouteWithoutSheetPopScope();
              },
            ),
          ),
          Visibility(
            visible: _isParkingSheetMounted,
            maintainState: true,
            child: ToggleSheet(
              scrollController: _parkingLotsController,
              backgroundColor: context.colors.backgroundSurface4,
              safeAreaColor: context.colors.backgroundSurface4,
              dragger: const SheetDragger(),
              startConfig: ToggleSheetStart.closed,
              barrierColorDelegate: barrierColorDelegate,
              sliver: ParkingDetailsContent(
                onPanelClose: () {
                  _showLayersPanel();
                },
              ),
            ),
          ),
          Visibility(
            visible: _isBusSubMenuSheetMounted,
            maintainState: true,
            child: ToggleSheet(
              scrollController: _busSubMenuController,
              backgroundColor: context.colors.backgroundSurface4,
              safeAreaColor: context.colors.backgroundSurface4,
              dragger: const SheetDragger(),
              startConfig: ToggleSheetStart.closed,
              barrierColorDelegate: barrierColorDelegate,
              sliver: BusDetailsContent(onPanelClose: _showLayersPanel),
            ),
          ),
        ],
      ),
    );
  }

  void _hideLayersPanel() {
    _layersController.close();
  }

  void _showLayersPanel() {
    ref.read(layersControlsProvider.notifier).update(layersWidgetType: LayersPanelType.layers);
    _layersController.open();
    _parkingLotsController.close();
    _busSubMenuController.close();
  }

  void _showParkingLotsPanel() {
    ref.read(layersControlsProvider.notifier).update(layersWidgetType: LayersPanelType.parking);
    if (!_isParkingSheetMounted) {
      setState(() {
        _isParkingSheetMounted = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _layersController.close();
        _parkingLotsController.open();
      });
      return;
    }
    _layersController.close();
    _parkingLotsController.open();
  }

  void _showBusSubMenuPanel() {
    ref.read(layersControlsProvider.notifier).update(layersWidgetType: LayersPanelType.busLayers);
    if (!_isBusSubMenuSheetMounted) {
      setState(() {
        _isBusSubMenuSheetMounted = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _layersController.close();
        _busSubMenuController.open();
      });
      return;
    }
    _layersController.close();
    _busSubMenuController.open();
  }

  void _closeRouteWithoutSheetPopScope() {
    if (!mounted || _isClosingRoute) {
      return;
    }

    setState(() {
      _isClosingRoute = true;
      _isParkingSheetMounted = false;
      _isBusSubMenuSheetMounted = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.router.pop();
      }
    });
  }
}
