import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/model/add_trip_params.dart';
import '../../data/model/apply_deceased/apply_deceased_params.dart';
import '../entities/apply_deceased_response.dart';
import '../repositories/ekram_repository.dart';

import 'package:dartz/dartz.dart' show Either;

import '../entities/book_cemetry_params.dart';

class BookCemetry extends UseCase<ResponseBodyModel<ApplyDeceasedResponse>,
    BookCemetryParamas> {
  final EkramRepository repository;

  BookCemetry({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<ApplyDeceasedResponse>>> call(
      BookCemetryParamas params) async {
    return await repository.bookCemetry(params);
  }
}
