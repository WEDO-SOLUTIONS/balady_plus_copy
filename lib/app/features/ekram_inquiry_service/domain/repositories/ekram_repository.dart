import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/find_cemetry_response_model.dart';
import '../../data/models/find_grave_response_model.dart';
import '../../data/models/orgnization_charity_list.dart';
import '../../data/models/send_otp_response.dart';
import '../../data/models/verify_otp_response.dart';
import '../entities/find_cemetry_request.dart';
import '../entities/find_grave_request.dart';
import '../entities/send_otp_params.dart';
import '../entities/verify_otp_params.dart';

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

  Future<Either<Failure, SendOTPResponseModel>> sendOTPForPrint(
      {required SendOTPParams params});
  Future<Either<Failure, VerifyOTPResponseModel>> verifyOTPForPrint(
      {required VerifyOTPParams params});
}
