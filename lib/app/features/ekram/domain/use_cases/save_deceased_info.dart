import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/request_details_response_model/request_details_response_model.dart';
import 'package:balady_plus/app/features/ekram/data/model/save_deceased_info_params/save_deceased_info_params.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/deceased_transport_requests/verify_deceased_params.dart';
import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../repositories/ekram_repository.dart';

class SaveDeceased extends UseCase<RequestDetailsResponseModel, List<dynamic>> {
  final EkramRepository repository;
  SaveDeceased({required this.repository});
  @override
  Future<Either<Failure, RequestDetailsResponseModel>> call(
      List<dynamic> parms) async {
    return await repository.saveDeceasedInfo(parms[0], parms[1]);
  }
}
