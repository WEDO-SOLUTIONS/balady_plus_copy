import 'package:dio/dio.dart';
import 'package:mapness/_features/lifestyle_layers/data/lifestyle_datasource.dart';
import 'package:mapness/_features/lifestyle_layers/data/lifestyle_service.dart';
import 'package:mapness/_features/lifestyle_layers/domain/building_compliance_certificate.dart';
import 'package:mapness/_features/lifestyle_layers/domain/esri_feature.dart';
import 'package:mapness/_features/lifestyle_layers/domain/map_requests_params.dart';
import 'package:mapness/_features/lifestyle_layers/domain/point_layers_data.dart';
import 'package:mapness/_features/lifestyle_layers/domain/white_lands.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lifestyle_repository.g.dart';

@riverpod
class LifestyleRepository extends _$LifestyleRepository {
  final dataSource = LifestyleDataSource(
    LifestyleLayersService(
      dio: Dio(),
    ),
  );

  Future<List<PointLayersData>?> getPointsInLayers(
      MapRequestParams params) async {
    var esriMarkers = await dataSource.getPointsInLayers(
      params: params,
    );

    return esriMarkers;
  }

  Future<List<EsriPointFeature>?> getEsriPoints(MapRequestParams params) async {
    var esriMarkers = await dataSource.getEsriPoints(params);

    var list = <EsriPointFeature>[];

    var markerList = esriMarkers as List<dynamic>;
    for (var element in markerList) {
      await Future<void>.delayed(Duration.zero);
      list.add(EsriPointFeature.fromJson(element, '${params.layer.layerId}'));
    }

    return list;
  }

  Future<List<BuildingComplianceCertificate>?> buildingComplianceCertificate(
      MapRequestParams params) async {
    var response = await dataSource.getEsriPoints(params);
    return buildingComplianceCertificateFromJson(response ?? []);
  }

  Future<List<WhiteLands>?> getWhiteLands(MapRequestParams params) async {
    var response = await dataSource.getEsriPoints(params);
    try{
    // var landsFencedFromJson2 = landsFencedFromJson(response ?? []);
    var landsFencedFromJson2 = whiteLandsFromJson(response ?? []);
    return landsFencedFromJson2;
    }catch(e){
      print(e);
    }
  }

  @override
  void build() {}
}
