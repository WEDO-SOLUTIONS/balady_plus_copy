import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/widgets/lifestyle_layers/layers_sheet_content.dart';
import 'package:mapness/widgets/lifestyle_layers/parking_details_content.dart';

class LayersSheet extends ConsumerStatefulWidget {
  const LayersSheet({super.key});

  @override
  ConsumerState<LayersSheet> createState() => LayersSheetState();
}

class LayersSheetState extends ConsumerState<LayersSheet> with SingleTickerProviderStateMixin {
  static const _layersPanelMaxHeight = .5;
  static const _parkingPanelMaxHeight = .35;

  late final DraggableScrollableController _layersController;
  late final DraggableScrollableController _parkingLotsController;

  @override
  void initState() {
    super.initState();
    _layersController = DraggableScrollableController();
    _parkingLotsController = DraggableScrollableController();

    _layersController.addListener(() {
      if (_layersController.isAttached && _layersController.size < .1) {
        ref.read(goRouterProvider).pop();
      }
    });
    _parkingLotsController.addListener(() {
      if (_parkingLotsController.isAttached && _parkingLotsController.size < .01) {
        ref.watch(layersControlsProvider.notifier).update(
              layersWidgetType: LayersPanelType.layers,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(layersControlsProvider);

    ref.listen(layersControlsProvider, (_, next) {
      const duration = Duration(milliseconds: 300);
      const easeIn = Curves.ease;

      switch (next.layersPanelType) {
        case LayersPanelType.layers:
          _parkingLotsController
              .animateTo(
            0,
            duration: duration,
            curve: easeIn,
          )
              .then((_) {
            _layersController.animateTo(
              _layersPanelMaxHeight,
              duration: duration,
              curve: easeIn,
            );
          });

        case LayersPanelType.parking:
          _layersController
              .animateTo(
            .11,
            duration: duration,
            curve: easeIn,
          )
              .then((_) {
            _parkingLotsController.animateTo(
              _parkingPanelMaxHeight,
              duration: duration,
              curve: easeIn,
            );
          });
      }
    });

    final direction = ref.watch(uiDirectionProvider);

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ColoredBox(
            color: context.staticColor.surfaceOverlayModal,
            child: GestureDetector(onTap: context.pop),
          ),
          DraggableScrollableSheet(
            controller: _layersController,
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
            controller: _parkingLotsController,
            initialChildSize: .001,
            minChildSize: .001,
            maxChildSize: _parkingPanelMaxHeight,
            snap: true,
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
