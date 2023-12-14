import 'package:flutter/material.dart' hide CloseButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/lifestyle_layers/domain/point_layers_data.dart';
import 'package:mapness/_features/lifestyle_layers/domain/white_lands.dart';
import 'package:mapness/_features/lifestyle_layers/map_cards/white_land_map_card.dart';

class LayersDetailsWidget extends ConsumerStatefulWidget {
  final PointLayersData? data;
  const LayersDetailsWidget({super.key,this.data});

  @override
  ConsumerState<LayersDetailsWidget> createState() => LayersDetailsState();
}

class LayersDetailsState extends ConsumerState<LayersDetailsWidget> {
  late final DraggableScrollableController _draggableScrollableController;

  @override
  void initState() {
    _draggableScrollableController = DraggableScrollableController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var selectedPoint = widget.data as WhiteLands?;

    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      initialChildSize: .3,
      minChildSize: .15,
      maxChildSize: .6,
      snapSizes: const [.3, .6],
      snap: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return Material(
          color: Colors.transparent,
          child: Directionality(
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
              child: Stack(
                children: [
                  CustomScrollView(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          WhiteLandMapCard(
                            municipality: selectedPoint?.MUNNAME,
                            subMunicipality: selectedPoint?.STREETNAME,
                            parcelNo: selectedPoint?.PARCELCODE,
                            stageNo: selectedPoint?.PHASE,
                            onClose: () => context.pop(),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}