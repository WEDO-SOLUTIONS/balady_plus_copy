import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mapness/features/lifestyle_layers/models/map_enums.dart';
import 'package:mapness/features/lifestyle_layers/models/map_requests_params.dart';
import 'package:mapness/features/lifestyle_layers/models/point_layers_data.dart';
import 'package:mapness/features/lifestyle_layers/providers/lifestyle_repository.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'layers_details.g.dart';

@riverpod
class LayersDetails extends _$LayersDetails {
  @override
  Future<PointLayersData?> build(PointLayersData layerData) async {
    final controller = ref.watch(lifestyleRepositoryProvider.notifier);
    final env = await ref.read(dgisEnvironmentProvider.future);

    final layerType = layerData.layerType;
    final requestParams = MapRequestParams(
      layer: layerType,
      domain: env.url,
      proxy: env.proxy,
      objectId: int.tryParse(layerData.id) ?? 0,
      pointsDetails: true,
    );

    final cancelToken = CancelToken();

    ref.onDispose(() {
      cancelToken.cancel();
    });

    return switch (layerType) {
      GISMapLayers.opportunities => (await controller.getEsriPoints(
          params: requestParams,
          cancelToken: cancelToken,
        ))
            .firstOrNull,
      GISMapLayers.bsWhiteParcelS => (await controller.getWhiteLands(
          requestParams,
          cancelToken,
        ))
            .firstOrNull,
      GISMapLayers.bsAimtithalBuildingsCertificateL => (await controller.buildingComplianceCertificate(
          requestParams,
          cancelToken,
        ))
            .firstOrNull,
      _ => null,
    };
  }
}
