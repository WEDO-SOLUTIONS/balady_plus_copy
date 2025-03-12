import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../entity/MunicipalityLookUp.dart';
import '../entity/city_entity.dart';
import '../entity/observer_status_entity.dart';


abstract class CertifiedObserverRepository {
  Future<Either<Failure, ResponseBodyModel<ObserverStatusEntity>>> getObserverStatus(String identityNumber);

  Future<Either<Failure, ResponseBodyModel<List<MunicipalityLookUp>>>> getMuncipalityList();
  Future<Either<Failure, ResponseBodyModel<bool>>> checkMuncipalityAcceptance(String id);
  Future<Either<Failure, ResponseBodyModel<List<CityEntity>>>> getCityList(String municipalityId);
}
