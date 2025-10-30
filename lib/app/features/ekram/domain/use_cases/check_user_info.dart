import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/user_info_response_model/user_info_response_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/model/add_trip_params.dart';
import '../../data/model/apply_deceased/apply_deceased_params.dart';
import '../entities/apply_deceased_response.dart';
import '../repositories/ekram_repository.dart';

import 'package:dartz/dartz.dart' show Either;

import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../entities/user_info_request_params.dart';

class CheckUserinfo extends UseCase<ResponseBodyModel<UserInfoResponseModel>,
    UserInfoRequestParams> {
  final EkramRepository repository;
  CheckUserinfo({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<UserInfoResponseModel>>> call(
      UserInfoRequestParams params) async {
    return await repository.checkUserinfo(params);
  }
}
