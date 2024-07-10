import 'package:balady_uikit/balady_uikit.dart' as ui_kit;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_features/lifestyle_layers/map_controls.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_state.dart' as layers_state;
import 'package:mapness/app/router.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/widgets/layers/layer_sliver_list.dart';

class LayersSheet extends ConsumerStatefulWidget {
  const LayersSheet({super.key});

  @override
  ConsumerState<LayersSheet> createState() => LayersSheetState();
}

class LayersSheetState extends ConsumerState<LayersSheet> {
  late final DraggableScrollableController _draggableScrollableController;
  late final ValueNotifier<int> _notifierIndexLayersTab = ValueNotifier(0);

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

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ColoredBox(
            color: context.staticColor.surfaceOverlayModal,
            child: GestureDetector(onTap: () => context.pop()),
          ),
          const MapControls(),
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
                    CustomScrollView(
                      controller: scrollController,
                      primary: false,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              const SheetDragger(),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(context.l10n.layersOnTheMap, style: context.textStyle.heading2),
                                  const Spacer(),
                                  ui_kit.AppButton.close(
                                    onTap: () {
                                      Metrics.logEventAdvanced(
                                        MetricsConstants.layersKeys.exitIcon,
                                        group: MetricsConstants.layersTag,
                                        action: MetricAction.tap.toString(),
                                      );

                                      context.pop();
                                    },
                                    padding: EdgeInsets.zero,
                                    innerPadding: const EdgeInsets.all(8),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              ui_kit.TabsRow.v2(
                                tabsContent: [
                                  ui_kit.TabsRowV2Content(title: context.l10n.lifestyle),
                                  ui_kit.TabsRowV2Content(title: context.l10n.business),
                                ],
                                onIndexChanged: (index) {
                                  _notifierIndexLayersTab.value = index ?? 0;
                                },
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: _notifierIndexLayersTab,
                          builder: (context, value, _) => LayerSliverList(
                            layerType: value == 0
                                ? layers_state.LayerType.withoutLifestyle
                                : layers_state.LayerType.withoutBusiness,
                            layersState: state,
                          ),
                        ),
                      ],
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
