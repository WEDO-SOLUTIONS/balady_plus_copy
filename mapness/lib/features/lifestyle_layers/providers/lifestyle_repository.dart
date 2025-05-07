import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/features/lifestyle_layers/models/building_compliance_certificate.dart';
import 'package:mapness/features/lifestyle_layers/models/investment_sites.dart';
import 'package:mapness/features/lifestyle_layers/models/map_requests_params.dart';
import 'package:mapness/features/lifestyle_layers/models/white_lands.dart';
import 'package:mapness/features/lifestyle_layers/providers/data/lifestyle_datasource.dart';
import 'package:mapness/shared/providers/dgis_http_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lifestyle_repository.g.dart';

@riverpod
class LifestyleRepository extends _$LifestyleRepository {
  LifestyleDataSource? _dataSource;

  Future<List<InvestmentSites>> getEsriPoints({
    required MapRequestParams params,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dataSource?.getEsriPoints(params, cancelToken);

      final result = investmentSitesFromJson(response ?? []);
      return result;
    } catch (e) {
      return [];
    }
  }

  Future<List<BuildingComplianceCertificate>> buildingComplianceCertificate(
    MapRequestParams params,
    CancelToken? cancelToken,
  ) async {
    try {
      final response = await _dataSource?.getEsriPoints(params, cancelToken);

      return buildingComplianceCertificateFromJson(response ?? []);
    } catch (e) {
      debugPrint('$e');
      return [];
    }
  }

  Future<List<WhiteLands>> getWhiteLands(
    MapRequestParams params,
    CancelToken? cancelToken,
  ) async {
    try {
      final response = await _dataSource?.getEsriPoints(params, cancelToken);

      return whiteLandsFromJson(response ?? []);
    } catch (e) {
      debugPrint('$e');
      return [];
    }
  }

  @override
  Future<void> build() async {
    final dio = await ref.watch(dGisHttpService.future);

    _dataSource = LifestyleDataSource(dio);
  }
}
