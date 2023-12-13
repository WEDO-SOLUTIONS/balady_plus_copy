import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/lifestyle_layers/domain/point_layers_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'layers_details.g.dart';

class LayerDetailsState{
  final PointLayersData data;
  LayerDetailsState(this.data);
}


@riverpod
class LayersDetails extends _$LayersDetails {
  @override
  LayerDetailsState build(PointLayersData data) {
    return LayerDetailsState(data);
  }
}

