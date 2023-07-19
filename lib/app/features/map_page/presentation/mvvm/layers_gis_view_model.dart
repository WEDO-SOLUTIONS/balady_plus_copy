import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:dio/dio.dart';

import '../../../../core/services/global/web_service.dart';
import '../../data/model/layers.dart';

class LayersGisViewModel extends BaseViewModel {
  final WebService webService;

  List<Layers>? layers;

  LayersGisViewModel({required this.webService}) {
    performSearch();
  }

  Future<void> performSearch() async {
    try {
      final layersType = await webService.dio.get(
        'https://apiservicesstg.balady.gov.sa/gis-urbi-services/layers',
        options: Options(
          headers: {
            'verifyingKEY': 'P/uN+9S3wHuzQDlY7JM+nb58vesqLzrJ8VTBMvzsIaI=',
          },
        ),
      );
      if (layersType.data != null) {
        layers = layersFromJson(layersType.data['data']['result']['layers']);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
