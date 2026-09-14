import 'package:dartz/dartz.dart' show Either;
import 'package:flutter_appauth/flutter_appauth.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../../entry_point_exports.dart';

class RefreshToken extends UseCase<TokenResponse, String> {
  final EntryPointRepository repository;

  RefreshToken({required this.repository});
  @override
  Future<Either<Failure, TokenResponse>> call(String params) async {
    return await repository.refreshToken(params);
  }
}
