import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/request_permits_model/permit.dart';
import '../../data/models/request_permits_model/request_permits_model.dart';

abstract class RequestApprovalSequenceRepository {
  Future<Either<Failure, List<Permit>?>> getRequestPermits(
    int requestNumber,
  );
  Future<Either<Failure, bool>> saveSelectedRequestPermits(
    int requestNumber,
  );
  Future<Either<Failure, bool>> saveShopInfo(
    int requestNumber,
  );
}
