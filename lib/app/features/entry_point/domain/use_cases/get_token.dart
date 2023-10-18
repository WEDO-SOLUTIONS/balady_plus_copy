import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase, NoParams;
import '../../entry_point_exports.dart';

import 'package:flutter_appauth/flutter_appauth.dart';

class GetToken extends UseCase<AuthorizationTokenResponse, NoParams> {
  final EntryPointRepository repository;

  GetToken({required this.repository});
  @override
  Future<Either<Failure, AuthorizationTokenResponse>> call(
      NoParams params) async {
    return await repository.authorize();
  }
}
