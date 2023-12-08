import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:mapness/_features/lifestyle_layers/data/lifestyle_datasource.dart';
import 'package:mapness/_features/lifestyle_layers/data/lifestyle_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lifestyle_repository.g.dart';

@riverpod
class LifestyleRepository extends _$LifestyleRepository {
  final dataSource = LifestyleDataSource(
    LifestyleLayersService(
      dio: Dio(),
    ),
  );

  Future<void> test(VisibleRect? vr) async {

    if (vr != null) {
      var esriMarkers = await dataSource.getEsriMarkers('1', vr);
    }
  }

  @override
  void build() {}
}
