import 'dart:async';

import 'package:mapness/_features/lifestyle_layers/data/lifestyle_repository.dart';
import 'package:mapness/_features/lifestyle_layers/data/map_enums.dart';
import 'package:mapness/_features/lifestyle_layers/domain/map_requests_params.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/point_layers_data.dart';

part 'layers_details.g.dart';

@riverpod
class LayersDetails extends _$LayersDetails {
  @override
  Future<PointLayersData?> build(PointLayersData e) async {
    return await _showObjectDetails(e);
  }

  Future<PointLayersData?> _showObjectDetails(PointLayersData layerData) async {
    final controller = ref.watch(lifestyleRepositoryProvider.notifier);
    final env = await ref.read(dgisEnvironmentProvider.future);

    var layerType = layerData.layerType;
    var requestParams = MapRequestParams(
      layer: layerType,
      domain: env.url,
      proxy: env.proxy,
      objectId: int.tryParse(layerData.id) ?? 0,
      pointsDetails: true,
    );

    return switch (layerType) {
      GISMapLayers.Opportunities =>
        (await controller.getEsriPoints(params: requestParams))?.first,
      GISMapLayers.BSWhiteParcelS =>
        (await controller.getWhiteLands(requestParams))?.first,
      GISMapLayers.BSAimtithalBuildingsCertificateL =>
        (await controller.buildingComplianceCertificate(requestParams))?.first,
      _ => null,
    };
  }
}
