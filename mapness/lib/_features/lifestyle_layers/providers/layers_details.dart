import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mapness/_features/lifestyle_layers/data/lifestyle_repository.dart';
import 'package:mapness/_features/lifestyle_layers/data/map_enums.dart';
import 'package:mapness/_features/lifestyle_layers/domain/map_requests_params.dart';
import 'package:mapness/_features/lifestyle_layers/domain/point_layers_data.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'layers_details.g.dart';

@riverpod
class LayersDetails extends _$LayersDetails {
  @override
  Future<PointLayersData?> build(PointLayersData e) async =>
      await _showObjectDetails(e);

  Future<PointLayersData?> _showObjectDetails(PointLayersData layerData) async {
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

    return switch (layerType) {
      GISMapLayers.Opportunities => (await controller.getEsriPoints(
              params: requestParams, cancelToken: CancelToken()))
          ?.first,
      GISMapLayers.BSWhiteParcelS =>
        (await controller.getWhiteLands(requestParams, CancelToken()))?.first,
      GISMapLayers.BSAimtithalBuildingsCertificateL => (await controller
              .buildingComplianceCertificate(requestParams, CancelToken()))
          ?.first,
      _ => null,
    };
  }
}
