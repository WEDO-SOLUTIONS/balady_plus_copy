import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/madinah_emirate_approval_status.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../repositories/ekram_repository.dart';


class GetMadinahEmirateApprovalStatus extends UseCase<ResponseBodyModel<MadinahEmirateApprovalStatusResponseModel>,  List<dynamic>> {
  final EkramRepository repository;

  GetMadinahEmirateApprovalStatus({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<MadinahEmirateApprovalStatusResponseModel>>> call(
      List<dynamic> params) async {
    return await repository.madinahEmirateApprovalStatus(params[0],params[1],params[2]);
  }
}
