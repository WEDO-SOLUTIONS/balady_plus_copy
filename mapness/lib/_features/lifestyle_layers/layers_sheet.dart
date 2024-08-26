import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  static const duration = Duration(milliseconds: 250);
  static const _showHideDuration = Duration(milliseconds: 150);

  static const curve = Curves.easeIn;

  late final DraggableScrollableController _layersController;
  late final DraggableScrollableController _parkingLotsController;

  late final AnimationController bgColorController;
  late ColorTween bgOpacity;
  late Animation<Color?> colorAnimation;

  @override
  void initState() {
    super.initState();

    bgColorController = AnimationController(
      duration: _showHideDuration,
      vsync: this,
    );
    bgOpacity = ColorTween(
      begin: Colors.transparent,
      end: const Color.fromRGBO(0, 0, 0, 0.7),
    );
    colorAnimation = bgOpacity.animate(bgColorController)
      ..addListener(() {
        setState(() {});
      });

    _layersController = DraggableScrollableController();
    _parkingLotsController = DraggableScrollableController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showBottomSheet());
  }

  @override
  void dispose() {
    super.dispose();
    _layersController.dispose();
    _parkingLotsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(layersControlsProvider);
    final direction = ref.watch(uiDirectionProvider);

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ColoredBox(
            color: colorAnimation.value ?? Colors.transparent,
            child: GestureDetector(onTap: () {
              if (state.layersPanelType == LayersPanelType.layers) {
                _hideLayersPanel();
              } else {
                _showLayersPanel();
              }
            }),
          ),
          DraggableScrollableSheet(
            controller: _layersController,
            minChildSize: .0,
            initialChildSize: .0,
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
                      tapOnParkingLotsMenu: () {
                        _showParkingLotsPanel();
                      },
                      onClose: () {
                        _hideLayersPanel();
                      },
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
                      onPanelClose: () {
                        _showLayersPanel();
                      },
                      scrollController: scrollController,
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

  void _parkingControllerListener() {
    if (_parkingLotsController.isAttached && _parkingLotsController.size < .01) {
      _showLayersPanel();
    }
  }

  void _hideLayersPanel() {
    bgColorController.reverse();
    _layersController.animateTo(
      .0,
      duration: _showHideDuration,
      curve: curve,
    );
  }

  void _showLayersPanel() {
    ref.watch(layersControlsProvider.notifier).update(
          layersWidgetType: LayersPanelType.layers,
        );
    _layersController.animateTo(
      _layersPanelMaxHeight,
      duration: duration,
      curve: curve,
    );
    _parkingLotsController
      ..removeListener(_parkingControllerListener)
      ..animateTo(
        0,
        duration: duration,
        curve: curve,
      );
  }

  void _showParkingLotsPanel() {
    ref.watch(layersControlsProvider.notifier).update(
          layersWidgetType: LayersPanelType.parking,
        );
    _layersController.animateTo(
      .11,
      duration: duration,
      curve: curve,
    );
    _parkingLotsController
        .animateTo(
      _parkingPanelMaxHeight,
      duration: duration,
      curve: curve,
    )
        .then((_) {
      _parkingLotsController.addListener(_parkingControllerListener);
    });
  }

  void _showBottomSheet() {
    ref.read(layersControlsProvider.notifier).initialize();
    bgColorController.forward();
    _layersController
        .animateTo(
      _layersPanelMaxHeight,
      duration: _showHideDuration,
      curve: curve,
    )
        .then((_) {
      _layersController.addListener(() {
        if (_layersController.isAttached && _layersController.size < .1) {
          ref.read(goRouterProvider).pop();
        }
      });
    });
  }
}
