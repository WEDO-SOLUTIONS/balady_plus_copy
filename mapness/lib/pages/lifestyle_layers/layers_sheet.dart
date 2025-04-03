import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/widgets/lifestyle_layers/layers_sheet_content.dart';
import 'package:mapness/widgets/lifestyle_layers/parking_details_content.dart';

@RoutePage()
class LayersSheetPage extends ConsumerStatefulWidget {
  const LayersSheetPage({super.key});

  @override
  ConsumerState<LayersSheetPage> createState() => LayersSheetPageState();
}

class LayersSheetPageState extends ConsumerState<LayersSheetPage> with SingleTickerProviderStateMixin {
  static const _layersPanelMaxHeight = .35;
  static const _parkingPanelMaxHeight = .35;
  static const _duration = Duration(milliseconds: 250);
  static const _showHideDuration = Duration(milliseconds: 150);

  static const _curve = Curves.easeIn;

  late final DraggableScrollableController _layersController;
  late final DraggableScrollableController _parkingLotsController;

  // Another one to check if the panel is shown and we don't pop it on small size of the sheet
  bool _isShown = false;

  @override
  void initState() {
    super.initState();

    _layersController = DraggableScrollableController();
    _layersController.addListener(_layersControllerListener);
    _parkingLotsController = DraggableScrollableController();

    WidgetsBinding.instance.addPostFrameCallback((_) => _showBottomSheet());
  }

  @override
  void dispose() {
    _layersController.dispose();
    _parkingLotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(layersControlsProvider);
    final direction = ref.watch(uiDirectionProvider);

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Close the panel when tapping on the screen
          // [CustomTransitionPage.barrierDismissible = true] doesn't work
          // so we have to add a transparent InkWell to close the panel manually
          //
          // I hope this is temporary and GoRouter will support barrierDismissible
          InkWell(
            splashColor: Colors.transparent,
            onTap: _hideLayersPanel,
            child: Container(
              color: context.staticColor.surfaceOverlayModal,
              width: double.maxFinite,
              height: double.maxFinite,
            ),
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
    if (_isShown) {
      _layersController
          .animateTo(
            .0,
            duration: _showHideDuration,
            curve: _curve,
          )
          .then((_) => _isShown = false);
    }
  }

  // If the main layer [_layersController] is in hidden position then close the panel and make pop
  void _layersControllerListener() {
    if (_isShown && _layersController.size < .01) {
      _isShown = false;
      context.router.popForced();
    }
  }

  void _showLayersPanel() {
    ref.watch(layersControlsProvider.notifier).update(
          layersWidgetType: LayersPanelType.layers,
        );
    _layersController.animateTo(
      _layersPanelMaxHeight,
      duration: _duration,
      curve: _curve,
    );
    _parkingLotsController
      ..removeListener(_parkingControllerListener)
      ..animateTo(
        0,
        duration: _duration,
        curve: _curve,
      );
  }

  void _showParkingLotsPanel() {
    ref.watch(layersControlsProvider.notifier).update(
          layersWidgetType: LayersPanelType.parking,
        );
    _layersController.animateTo(
      .11,
      duration: _duration,
      curve: _curve,
    );
    _parkingLotsController
        .animateTo(
      _parkingPanelMaxHeight,
      duration: _duration,
      curve: _curve,
    )
        .then((_) {
      _parkingLotsController.addListener(_parkingControllerListener);
    });
  }

  void _showBottomSheet() {
    ref.read(layersControlsProvider.notifier).initialize();

    _layersController
        .animateTo(
          _layersPanelMaxHeight,
          duration: _showHideDuration,
          curve: _curve,
        )
        .then((_) => _isShown = true);
  }
}
