import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/favourites/providers/favourite_markers.dart';

import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class LayersSheet extends ConsumerStatefulWidget {
  const LayersSheet({super.key});

  @override
  ConsumerState<LayersSheet> createState() => LayersSheetState();
}

class LayersSheetState extends ConsumerState<LayersSheet> {
  late final DraggableScrollableController _draggableScrollableController;

  @override
  void initState() {
    _draggableScrollableController = DraggableScrollableController();
    _draggableScrollableController.addListener(() {
      if (_draggableScrollableController.size < .1) {
        ref.read(mapControlsProvider.notifier).update(MapControlsStateIdle());
        ref
            .watch(layersControlsProvider.notifier)
            .update(visible: false, selectedType: null);
      }
    });

    // TODO(vefimov): костыль, чтобы статус выключенного
    // слоя извне не отламывался в шторе слоев;
    // нужно переписать логику слоев в целом
    Future.delayed(Duration.zero, () {
      var favState = ref.read(favouriteToggleProvider);
      if (favState) {
        ref
            .read(layersControlsProvider.notifier)
            .setSelected(LayerType.favourites);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var watch = ref.watch(layersControlsProvider.notifier);
    var state = ref.watch(layersControlsProvider);

    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      initialChildSize: .6,
      minChildSize: 0,
      maxChildSize: .6,
      snapSizes: const [0, .6],
      snap: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.0),
                topLeft: Radius.circular(16.0),
              ),
            ),
            child: CustomScrollView(
              controller: scrollController,
              primary: false,
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(children: [
                    Container(
                      height: 4,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDDE4EE),
                        borderRadius: BorderRadius.all(Radius.circular(24)),
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
                              .headingS,
                        ),
                        const Spacer(),
                        _buildcloseButton(
                          () {
                            ref
                                .watch(mapControlsProvider.notifier)
                                .update(MapControlsStateIdle());
                            watch.update(visible: false, selectedType: null);
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ]),
                ),
                SliverList.separated(
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemCount: LayerType.values.length,
                  itemBuilder: (_, int index) {
                    var value = LayerType.values[index];
                    return FilterRow(
                      value: value,
                      onTap: () {
                        value.onTap(ref);
                        watch.setSelected(value);
                      },
                      isSelected: state.selectedType == value,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildcloseButton(Function() onTap) {
    const borderRadius = BorderRadius.all(
      Radius.circular(8),
    );
    const colorPrimary = Color(0xff1E2A36);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              color: colorPrimary.withAlpha(10),
            ),
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              "assets/icons/svg/ic_search_close.svg",
              semanticsLabel: 'MinApps Screen',
              package: "mapness",
              color: colorPrimary.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }
}

class FilterRow extends StatelessWidget {
  final LayerType value;
  final Function() onTap;
  final bool isSelected;

  const FilterRow({
    super.key,
    required this.value,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(
      Radius.circular(8),
    );

    return Material(
      color: Colors.white,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              SvgPicture.asset(
                value.iconPath(),
                semanticsLabel: 'MinApps Screen',
                package: "mapness",
                color: isSelected
                    ? const Color(0xff4CA5B4)
                    : const Color(0xff1E2A36).withOpacity(0.5),
              ),
              const SizedBox(
                width: 14,
              ),
              Text(
                value.title(context.l10n),
                style: Theme.of(context).extension<ThemeTextStyles>()!.textM,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
