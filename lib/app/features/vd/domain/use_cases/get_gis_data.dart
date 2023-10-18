import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show VDRepository, GISParams, GISResponse;
import 'package:balady_plus/app/core/errors/errors_exports.dart' show Failure;
import 'package:balady_plus/app/core/services/services_exports.dart'
    show UseCase;

import 'package:dartz/dartz.dart' show Either;

class GetGISData extends UseCase<GISResponse, GISParams> {
  final VDRepository repository;

  GetGISData({required this.repository});
  @override
  Future<Either<Failure, GISResponse>> call(GISParams params) async {
    return await repository.getGISData(params: params);
  }
}
