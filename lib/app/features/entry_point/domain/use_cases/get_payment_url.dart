import 'dart:io';

import 'package:dartz/dartz.dart' show Either, Right, Left;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart' as w;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase, NoParams;

import '../../entry_point_exports.dart';

class GetPaymentUrl extends UseCase<String, PaymentRequest> {
  final EntryPointRepository repository;

  GetPaymentUrl({required this.repository});
  @override
  Future<Either<Failure, String>> call(PaymentRequest params) async {
    return await repository.getPaymentURL(params);
  }
}
