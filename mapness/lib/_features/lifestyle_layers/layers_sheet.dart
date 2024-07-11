import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/lifestyle_layers/map_controls.dart' as controls;
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/widgets/lifestyle_layers/layers_sheet_content.dart';
import 'package:mapness/widgets/lifestyle_layers/parking_details_content.dart';

class LayersSheet extends ConsumerStatefulWidget {
  const LayersSheet({super.key});

  @override
  ConsumerState<LayersSheet> createState() => LayersSheetState();
}

class LayersSheetState extends ConsumerState<LayersSheet> {
  late final DraggableScrollableController _draggableScrollableController;

  @override
  void initState() {
    super.initState();
    _draggableScrollableController = DraggableScrollableController();
    _draggableScrollableController.addListener(() {
      if (_draggableScrollableController.isAttached && _draggableScrollableController.size < 0.12) {
        ref.read(goRouterProvider).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(layersControlsProvider);
    final direction = ref.watch(uiDirectionProvider);

    final controlsBottomExtent = MediaQuery.of(context).size.height * .5;

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
            controller: _draggableScrollableController,
            minChildSize: 0,
            maxChildSize: .5,
            snapSizes: const [.0, .5],
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
                    switch (state.layersWidgetType) {
                      LayersWidgetType.layers => LayersSheetContent(
                          scrollController: scrollController,
                        ),
                      LayersWidgetType.parking => ParkingDetailsContent(
                          scrollController: scrollController,
                        ),
                    },
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
