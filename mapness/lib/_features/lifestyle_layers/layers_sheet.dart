import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/_features/lifestyle_layers/map_controls.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/_features/lifestyle_layers/providers/lib/layers_type_extension.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';

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
      if (_draggableScrollableController.size < .2) {
        ref.read(goRouterProvider).pop();
      }
    });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _draggableScrollableController.isAttached
          ? _draggableScrollableController.animateTo(
              .6,
              duration: const Duration(milliseconds: 100),
              curve: Curves.linear,
            )
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final watch = ref.watch(layersControlsProvider.notifier);
    final state = ref.watch(layersControlsProvider);
    final lang = ref.watch(appLanguageProvider);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        const MapControls(),
        DraggableScrollableSheet(
          controller: _draggableScrollableController,
          initialChildSize: .6,
          minChildSize: 0,
          maxChildSize: .6,
          snapSizes: const [.0, .3, .6],
          snap: true,
          builder: (context, scrollController) => Directionality(
            textDirection: switch (lang) {
              Language.english => TextDirection.ltr,
              Language.arabic => TextDirection.rtl,
            },
            child: Container(
              padding: const EdgeInsets.all(16),
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
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Material(
                          color: Colors.transparent,
                          child: Column(children: [
                            Container(
                              height: 4,
                              width: 40,
                              decoration: BoxDecoration(
                                color: context.color.surfaceBasePrimary,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(24)),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                Text(
                                  context.l10n.layersOnTheMap,
                                  style: Theme.of(context)
                                      .extension<ThemeTextStyles>()!
                                      .heading1,
                                ),
                                const Spacer(),
                                CustomCloseButton(
                                  onClose: () => context.pop(),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],),
                        ),
                      ),
                      SliverList.separated(
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemCount: LayerType.values.length,
                        itemBuilder: (_, index) {
                          final value = LayerType.values[index];

                          return FilterRow(
                            value: value,
                            onTap: () async {
                              ref
                                  .read(searchByRubricsQueryProvider.notifier)
                                  .update(null);

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
                            isSelected: state.selectedType == value,
                          );
                        },
                      ),
                    ],
                  ),
                  if (state.isLoading)
                    Center(
                        child: CircularProgressIndicator(
                      color: context.color.textAndIconsStatusAccent,
                    ),),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FilterRow extends StatelessWidget {

  const FilterRow({
    required this.value, required this.onTap, required this.isSelected, super.key,
  });
  final LayerType value;
  final Function() onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(
      Radius.circular(8),
    );

    final textM = Theme.of(context).extension<ThemeTextStyles>()!.text;

    return Material(
      color: Colors.white,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SvgPicture.asset(
                value.iconPath(),
                semanticsLabel: 'MinApps Screen',
                package: 'mapness',
                color: isSelected
                    ? context.color.strokeAccent
                    : const Color.fromRGBO(30, 42, 54, 0.5),
              ),
              const SizedBox(
                width: 14,
              ),
              Text(
                value.titleLocale(context.l10n),
                style: textM.copyWith(
                  color: isSelected ? context.color.strokeAccent : textM.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
