import 'package:balady_uikit/balady_uikit.dart' as ui_kit;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/_features/lifestyle_layers/map_controls.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/_features/lifestyle_layers/providers/lib/layers_type_extension.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/app_language.dart';

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

    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        if (_draggableScrollableController.isAttached) {
          _draggableScrollableController.animateTo(
            .6,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final watch = ref.watch(layersControlsProvider.notifier);
    final state = ref.watch(layersControlsProvider);
    final lang = ref.watch(appLanguageProvider);

    final headerStyle = Theme.of(context).extension<ui_kit.ThemeTextStyles>()!.heading2;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ColoredBox(
          color: context.staticColor.surfaceOverlayModal,
          child: GestureDetector(
            onTap: () {
              context.pop();
            },
          ),
        ),
        const MapControls(),
        DraggableScrollableSheet(
          controller: _draggableScrollableController,
          minChildSize: 0,
          maxChildSize: .5,
          snapSizes: const [.0, .3, .5],
          snap: true,
          builder: (context, scrollController) => Directionality(
            textDirection: switch (lang) {
              Language.english => TextDirection.ltr,
              Language.arabic => TextDirection.rtl,
            },
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
                        child: Material(
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              const SizedBox(height: 6),
                              const SheetDragger(),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(context.l10n.layersOnTheMap, style: headerStyle),
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
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                      SliverList.separated(
                        separatorBuilder: (_, __) => const SizedBox(height: 4),
                        itemCount: LayerType.withoutParking.length,
                        itemBuilder: (_, index) {
                          final value = LayerType.withoutParking[index];
                          final isSelected = state.selectedType == value;
                          final textColor = isSelected
                              ? context.color.textAndIconsStatusAccent
                              : context.color.textAndIconsBasePrimary;

                          return ui_kit.ContentRow(
                            onTap: () async {
                              ref.read(searchByRubricsQueryProvider.notifier).update(null);

                              if (value == LayerType.favourites) {
                                await CommonFunctions.authOrOpen(
                                  context,
                                  callback: () async {
                                    watch.handleTap(value);
                                  },
                                );
                              } else {
                                watch.handleTap(value);
                              }
                            },
                            options: ui_kit.ContentRowOptions(
                              wrapperEnabled: true,
                              wrapperColor: isSelected
                                  ? context.color.surfaceStatusContrastAccent.withOpacity(0.12)
                                  : Colors.transparent,
                              leadingIcon: value.iconData().icon(color: textColor),
                              title: value.titleLocale(context.l10n),
                              titleStyle: context.textStyle.text.copyWith(color: textColor),
                            ),
                          );
                        },
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
    );
  }
}
