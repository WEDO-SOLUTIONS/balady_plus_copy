import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';

import '../entity/MunicipalityLookUp.dart';
import '../entity/city_entity.dart';
import '../entity/observer_status_entity.dart';
import '../repository/repository.dart';

class GetCityList
    extends UseCase<ResponseBodyModel<List<CityEntity>>, String?> {
  final CertifiedObserverRepository repository;

  GetCityList({required this.repository});

  @override
  Future<Either<Failure, ResponseBodyModel<List<CityEntity>>>> call(
      String? parm) async {
    return await repository.getCityList(parm!);
  }
}

class GetDistrictList extends UseCase<List<DistrictsEntity>, String> {
  final CertifiedObserverRepository repository;

  GetDistrictList({required this.repository});

  @override
  Future<Either<Failure, List<DistrictsEntity>>> call(String params) async {
    return await repository.getDistrictByCityIdList(params);
  }
}
