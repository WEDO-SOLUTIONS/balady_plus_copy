import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/lifestyle_layers/map_controls.dart' as controls;
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/widgets/lifestyle_layers/layers_sheet_content.dart';
import 'package:mapness/widgets/lifestyle_layers/parking_details_content.dart';

import '../../app/router.dart';

class LayersSheet extends ConsumerStatefulWidget {
  const LayersSheet({super.key});

  @override
  ConsumerState<LayersSheet> createState() => LayersSheetState();
}

class LayersSheetState extends ConsumerState<LayersSheet> {
  static const _layersPanelMaxHeight = .5;
  static const _layersPanelHideHeight = .11;
  static const _parkingPanelMaxHeight = .35;

  late final DraggableScrollableController _layersScrollableController;
  late final DraggableScrollableController _parkingLotsScrollableController;

  @override
  void initState() {
    super.initState();
    _layersScrollableController = DraggableScrollableController();
    _parkingLotsScrollableController = DraggableScrollableController();
    _layersScrollableController.addListener(() {
      if (_layersScrollableController.isAttached && _layersScrollableController.size < .10) {
        ref.read(goRouterProvider).pop();
      }
    });
    _parkingLotsScrollableController.addListener(() {
      if (_parkingLotsScrollableController.isAttached && _parkingLotsScrollableController.size == 0) {
        ref.watch(layersControlsProvider.notifier).update(
              layersWidgetType: LayersPanelType.layers,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(layersControlsProvider);
    final direction = ref.watch(uiDirectionProvider);

    ref.listen(layersControlsProvider, (_, nextState) async {
      const duration = Duration(milliseconds: 200);
      const easeIn = Curves.easeIn;

      switch (nextState.layersPanelType) {
        case LayersPanelType.layers:
          await _parkingLotsScrollableController.animateTo(
            0,
            duration: duration,
            curve: easeIn,
          );
          await _layersScrollableController.animateTo(
            _layersPanelMaxHeight,
            duration: duration,
            curve: easeIn,
          );
        case LayersPanelType.parking:
          await _layersScrollableController.animateTo(
            _layersPanelHideHeight,
            duration: duration,
            curve: easeIn,
          );
          await _parkingLotsScrollableController.animateTo(
            _parkingPanelMaxHeight,
            duration: duration,
            curve: easeIn,
          );
      }
    });

    final controlsBottomExtent = MediaQuery.of(context).size.height * _layersPanelMaxHeight;

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ColoredBox(
            color: context.staticColor.surfaceOverlayModal,
            child: GestureDetector(onTap: context.pop),
          ),
          controls.MapControls(
            bottomExtent: controlsBottomExtent,
          ),
          DraggableScrollableSheet(
            controller: _layersScrollableController,
            minChildSize: .0,
            maxChildSize: _layersPanelMaxHeight,
            snapSizes: const [.0, _layersPanelMaxHeight],
            snap: true,
            builder: (context, scrollController) => Directionality(
              textDirection: direction,
              child: Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    LayersSheetContent(
                      scrollController: scrollController,
                    ),
                    if (state.isLoading)
                      Center(
                        child: CircularProgressIndicator(
                          color: context.color.textAndIconsStatusAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            controller: _parkingLotsScrollableController,
            initialChildSize: 0,
            minChildSize: 0,
            maxChildSize: _parkingPanelMaxHeight,
            shouldCloseOnMinExtent: false,
            snapSizes: const [_parkingPanelMaxHeight],
            builder: (context, scrollController) => Directionality(
              textDirection: direction,
              child: Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    ParkingDetailsContent(
                      scrollController: scrollController,
                    ),
                    if (state.isLoading)
                      Center(
                        child: CircularProgressIndicator(
                          color: context.color.textAndIconsStatusAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
