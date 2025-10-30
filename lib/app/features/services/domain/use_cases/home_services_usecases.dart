import 'package:balady_plus/app/features/services/domain/entities/services_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;
import '../../services_exports.dart' show ServicesRepository;

class HomeServicesUseCases extends UseCase<HomeServices, NoParams> {
  final ServicesRepository repository;

  HomeServicesUseCases(this.repository);

  @override
  Future<Either<Failure, HomeServices>> call(NoParams params) async {
    return await repository.getAllServices();
  }
}

