import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/_features/lifestyle_layers/data/lifestyle_datasource.dart';
import 'package:mapness/_features/lifestyle_layers/data/lifestyle_service.dart';
import 'package:mapness/_features/lifestyle_layers/domain/building_compliance_certificate.dart';
import 'package:mapness/_features/lifestyle_layers/domain/investment_sites.dart';
import 'package:mapness/_features/lifestyle_layers/domain/map_requests_params.dart';
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

  Future<List<InvestmentSites>?> getEsriPoints(
      {required MapRequestParams params}) async {
    try {
      var response = await dataSource.getEsriPoints(params);
      var result = investmentSitesFromJson(response as List<dynamic>);
      return result;
    } catch (e) {
      return null;
    }
  }

  Future<List<BuildingComplianceCertificate>?> buildingComplianceCertificate(
      MapRequestParams params) async {
    try {
      final response = await dataSource.getEsriPoints(params);
      return buildingComplianceCertificateFromJson(response ?? []);
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  }

  Future<List<WhiteLands>?> getWhiteLands(MapRequestParams params) async {
    try {
      var response = await dataSource.getEsriPoints(params);
      return whiteLandsFromJson(response ?? []);
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  }

  @override
  void build() {}
}
