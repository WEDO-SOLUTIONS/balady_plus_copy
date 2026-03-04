import 'dart:io';

import 'package:dartz/dartz.dart' show Either, Right, Left;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart' as w;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase, NoParams;
import '../../../../core/utils/constants/remote_config.dart';
import '../../data/models/get_permission_params_model.dart';
import '../../data/models/permission_response_model.dart';
import '../../entry_point_exports.dart';

class GetEkramPermission extends UseCase<PermissionResponseModel, GetPermissionParamsModel> {
  final EntryPointRepository repository;

  GetEkramPermission({required this.repository});
  @override
  Future<Either<Failure, PermissionResponseModel>> call(GetPermissionParamsModel params) async {
    return await repository.getEkramRules(params);
  }
}
