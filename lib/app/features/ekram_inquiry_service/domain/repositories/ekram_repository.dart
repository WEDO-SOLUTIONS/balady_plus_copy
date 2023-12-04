import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/find_cemetry_response_model.dart';
import '../../data/models/find_grave_response_model.dart';
import '../../data/models/orgnization_charity_list.dart';
import '../entities/find_cemetry_request.dart';
import '../entities/find_grave_request.dart';

abstract class EkramServicesRepository {
  Future<Either<Failure, FindCemetryResponse>> findCemetries(
      {required FindCemetryRequest params});

  Future<Either<Failure, FindGraveResponse>> findGraveLocations(
      {required FindGraveRequest params});

  Future<Either<Failure, List<LookUpItem>>> getCities();

  Future<Either<Failure, List<LookUpItem>>> getDistrcits({required int params});

  Future<Either<Failure, EkramCharityOrgnizationResponse>>
      getCharityOrgnizations({required int params});

  Future<Either<Failure, List<LookUpItem>>> getEkramIdentityTypes();
}
