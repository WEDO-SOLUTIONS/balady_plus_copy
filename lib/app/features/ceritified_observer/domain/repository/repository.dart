import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../entity/MunicipalityLookUp.dart';
import '../entity/city_entity.dart';
import '../entity/observer_status_entity.dart';
import '../entity/register_observer_request.dart';

abstract class CertifiedObserverRepository {
  Future<Either<Failure, ObserverStatusEntity>> getObserverStatus(
      String identityNumber);

  Future<Either<Failure, ResponseBodyModel<List<MunicipalityLookUp>>>>
      getMuncipalityList();

  Future<Either<Failure, ResponseBodyModel<bool>>> checkMuncipalityAcceptance(
      String id);

  Future<Either<Failure, ResponseBodyModel<List<CityEntity>>>> getCityList(
      String municipalityId);

  Future<Either<Failure, List<DistrictsEntity>>> getDistrictByCityIdList(
      String cityId);

  Future<Either<Failure, bool>> registrationObserver(
      RegisterObserverRequest request);



  ////////////////// For Freelancer Certificate //////////////////



  Future<Either<Failure, Map<String, dynamic>>> createNewFreelancerCertificate();


  Future<Either<Failure, Map<String, dynamic>>> getFreelancerCertificateStatus();


  Future<Either<Failure, Map<String, dynamic>>> updateFreelancerCertificate(
      String certificateNumber);

}
