import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/widgets/lifestyle_layers/layers_sheet_content.dart';
import 'package:mapness/widgets/lifestyle_layers/parking_details_content.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class LayersSheetPage extends StatefulHookConsumerWidget {
  const LayersSheetPage({super.key});

  @override
  ConsumerState<LayersSheetPage> createState() => LayersSheetPageState();
}

class LayersSheetPageState extends ConsumerState<LayersSheetPage> with SingleTickerProviderStateMixin {
  late final ToggleSheetController _layersController;
  late final ToggleSheetController _parkingLotsController;

  late final barrierColorDelegate = ToggleSheetDelegateFunction(
    function: (controller) => screenOverlayDimming40.withAlpha(
      (controller.fraction * 255).toInt(),
    ),
  );
  late Color screenOverlayDimming40;

  @override
  void initState() {
    super.initState();

    _layersController = ToggleSheetController(
        durationMultiplier: 2,
        onClose: (_) {
          if (_parkingLotsController.isClosed) {
            context.router.pop();
          }
        });
    _parkingLotsController = ToggleSheetController(
        durationMultiplier: 2,
        onClose: (_) {
          _layersController.open();
        });
  }

  @override
  void dispose() {
    _layersController.dispose();
    _parkingLotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenOverlayDimming40 = context.colors.screenOverlayDimming40;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ToggleSheet(
            scrollController: _layersController,
            backgroundColor: context.colors.backgroundSurface1,
            safeAreaColor: context.colors.backgroundSurface1,
            dragger: const SheetDragger(),
            outside: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (!_parkingLotsController.isClosed) {
                  _showLayersPanel();
                } else {
                  _hideLayersPanel();
                }
              },
              child: const SizedBox.expand(),
            ),
            barrierColorDelegate: barrierColorDelegate,
            sliver: LayersSheetContent(
              tapOnParkingLotsMenu: () => _showParkingLotsPanel(),
              onClose: () => context.router.pop(),
            ),
          ),
          ToggleSheet(
            scrollController: _parkingLotsController,
            backgroundColor: context.colors.backgroundSurface1,
            safeAreaColor: context.colors.backgroundSurface1,
            dragger: const SheetDragger(),
            startConfig: ToggleSheetStart.closed,
            barrierColorDelegate: barrierColorDelegate,
            sliver: ParkingDetailsContent(
              onPanelClose: () {
                _showLayersPanel();
              },
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
    ref.watch(layersControlsProvider.notifier).update(
          layersWidgetType: LayersPanelType.layers,
        );
    _layersController.open();
    _parkingLotsController.close();
  }

  void _showParkingLotsPanel() {
    ref.watch(layersControlsProvider.notifier).update(
          layersWidgetType: LayersPanelType.parking,
        );
    _layersController.close();
    _parkingLotsController.open();
  }
}
