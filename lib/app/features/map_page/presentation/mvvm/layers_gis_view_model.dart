import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../core/services/global/web_service.dart';
import '../../data/model/layers.dart';
import 'package:flutter/foundation.dart';

class LayersGisViewModel extends BaseViewModel {
  final WebService webService;

  final selectedLayers = ValueNotifier<Layers?>(null);

  List<Layers>? layers;

  List<SubLayers>? subLayers;



  LayersGisViewModel({required this.webService}) {
    getMinLayers();
  }

  Future<void> getMinLayers() async {
    try {
      final layersType = await webService.dio.get(
        'https://apiservicesstg.balady.gov.sa/gis-urbi-services/layers',
        options: Options(
          headers: {
            'verifyingKEY': 'P/uN+9S3wHuzQDlY7JM+nb58vesqLzrJ8VTBMvzsIaI=',
          },
        ),
      );
      notifyListeners();
      if (layersType.data != null) {
        layers = layersFromJson(layersType.data['data']['result']['layers']);
        selectedLayers.value = layers![1];
        await getSubLayers(selectedLayers.value!.id);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getSubLayers(int layersId) async {
    try {
      EasyLoading.show();
      final layersType = await webService.dio.get(
        'https://apiservicesstg.balady.gov.sa/gis-urbi-services/layers/$layersId',
        options: Options(
          headers: {
            'verifyingKEY': 'P/uN+9S3wHuzQDlY7JM+nb58vesqLzrJ8VTBMvzsIaI=',
          },
        ),
      );
      if (layersType.data != null) {
        subLayers = subLayersFromJson(layersType.data['data']['result']
            ['drawingInfo']['renderer']['uniqueValueInfos']);
      }
      notifyListeners();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();

      print(e);
    }
  }
}
