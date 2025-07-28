import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mapness/features/statistic/model/statistics_request.dart';

class BssRepository {
  final Dio dio;

  BssRepository({required this.dio});

  @Deprecated('Use BssService from shared/providers/analytic/bss_repository.dart')
  Future<void> sendStatistics(BssPayloadMap request) async {
    await dio.post(
      '/bss/3',
      data: jsonEncode(request),
    );
  }
}
