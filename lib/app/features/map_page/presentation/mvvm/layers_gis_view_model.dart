import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/features/map_page/data/repositories/layers_repositories.dart';
import 'package:balady_plus/app/features/map_page/presentation/mvvm/map_view_model.dart';

import '../../data/model/layers.dart';
import 'package:flutter/foundation.dart';

class LayersGisViewModel extends BaseViewModel {
  final LayersRepositories layersRepositories;
  final MapViewModel mapViewModel;

  // final selectedLayers = ValueNotifier<Layers?>(null);

  final layers = ValueNotifier<List<Layers>?>(null);
  final layerSelected = ValueNotifier<Layers?>(null);

  // List<SubLayers>? subLayers;

  LayersGisViewModel({
    required this.mapViewModel,
    required this.layersRepositories,
  }) {
    getMinLayers();
  }

  Future<void> getMinLayers() async {
    try {
      layers.value = await layersRepositories.getMinLayers();
      /* if (layers.value != null) {
        layerSelected.value = layers.value!.first;
        mapViewModel.layerSelected.value = layers.value!.first;
      }*/
      // if (layers != null) {
      //   selectedLayers.value = layers![1];
      //   await getSubLayers(selectedLayers.value!.id);
      // }
      layers.notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void selectLayers(Layers layers) {
    layerSelected.value = layers;
    layerSelected.notifyListeners();
  }

// Future<void> getSubLayers(int layersId) async {
//   try {
//     EasyLoading.show();
//     subLayers = await layersRepositories.getSubLayers(layersId);
//     notifyListeners();
//     EasyLoading.dismiss();
//   } catch (e) {
//     EasyLoading.dismiss();
//     print(e);
//   }
// }
}
