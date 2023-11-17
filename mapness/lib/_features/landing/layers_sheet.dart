import 'package:flutter/material.dart' hide CloseButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_fonts.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/_features/landing/widgets/close_button.dart';

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
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      initialChildSize: .3,
      minChildSize: 0,
      maxChildSize: .7,
      snapSizes: const [0, .7],
      snap: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.0),
                topLeft: Radius.circular(16.0),
              ),
            ),
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      Container(
                        height: 4,
                        width: 26,
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
                            "طبقات على الخريطة",
                            style: PackageFonts.frutigerArabic(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          CloseButton(
                            onTap: () {
                              ref
                                  .watch(mapControlsProvider.notifier)
                                  .update(MapControlsStateIdle());
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const FilterRow(
                        icon: "ic_transport",
                        name: "النقل",
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const FilterRow(
                        icon: "ic_car",
                        name: "ازدحام المرور",
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const FilterRow(
                        icon: "ic_metro",
                        name: "مترو",
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const FilterRow(
                        icon: "ic_monorail",
                        name: "أجهزة الصراف الآلي",
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const FilterRow(
                        icon: "ic_parking",
                        name: "موقف سيارات",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FilterRow extends StatelessWidget {
  const FilterRow({
    super.key,
    required this.icon,
    required this.name,
  });

  final String icon;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/icons/svg/$icon.svg",
            semanticsLabel: 'MinApps Screen',
            package: "mapness",
          ),
          const SizedBox(
            width: 14,
          ),
          Text(
            name,
            style: PackageFonts.frutigerArabic(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
