import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/widgets/lifestyle_layers/layers_sheet_content.dart';
import 'package:mapness/widgets/lifestyle_layers/parking_details_content.dart';

@RoutePage()
class LayersSheetPage extends StatefulHookConsumerWidget {
  const LayersSheetPage({super.key});

  @override
  ConsumerState<LayersSheetPage> createState() => LayersSheetPageState();
}

class LayersSheetPageState extends ConsumerState<LayersSheetPage> with SingleTickerProviderStateMixin {
  late final StatelessBottomSheetController _layersController;
  late final StatelessBottomSheetController _parkingLotsController;

  @override
  void initState() {
    super.initState();

    _layersController = StatelessBottomSheetController(
        durationMultiplier: 2,
        onClose: (_) {
          if (_parkingLotsController.isClosed) {
            context.router.popForced();
          }
        });
    _parkingLotsController = StatelessBottomSheetController(
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
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            StatelessBottomSheet(
              scrollController: _layersController,
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
              backgroundColorDelegate: StatelessSheetDelegateFunction(
                function: (controller) => context.colors.screenOverlayDimming40.withAlpha(
                  (controller.aspectRatio * 255).toInt(),
                ),
              ),
              sliverBeforeContent: LayersSheetContent(
                tapOnParkingLotsMenu: () => _showParkingLotsPanel(),
                onClose: () => context.router.popForced(),
              ),
            ),
            StatelessBottomSheet(
              scrollController: _parkingLotsController,
              startConfig: BottomSheetStart.closed,
              backgroundColorDelegate: StatelessSheetDelegateFunction(
                function: (controller) => context.colors.screenOverlayDimming40.withAlpha(
                  (controller.aspectRatio * 255).toInt(),
                ),
              ),
              sliverBeforeContent: ParkingDetailsContent(
                onPanelClose: () {
                  _showLayersPanel();
                },
              ),
            ),
          ],
        ),
      );

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
