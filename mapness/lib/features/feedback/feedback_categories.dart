import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mapness/entities/feedback/dto/feedback_category_dto.dart';
import 'package:mapness/entities/feedback/feedback_category.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/dgis_http_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feedback_categories.g.dart';

@riverpod
Future<Dio> _getDio(AutoDisposeFutureProviderRef ref) async {
  final baseDio = await ref.watch(dGisHttpService.future);
  final env = await ref.watch(dgisEnvironmentProvider.future);
  return Dio(baseDio.options.copyWith(baseUrl: env.feedbackApi));
}

@riverpod
class FeedbackCategories extends _$FeedbackCategories {
  @override
  Future<List<FeedbackCategoryEntity>> build() async {
    final dio = await ref.watch(_getDioProvider.future);
    dio.interceptors.add(LogInterceptor(responseBody: true));

    final dto = await _loadFromBackend(dio, FeedbackObjectType.building);
    // final dto = await _loadMock();
    // await postFeedback();
    return dto.map((e) => e.toDomain()).toList();
  }

  Future<void> postFeedback() async {
    final dio = await ref.read(_getDioProvider.future);
    final response = await dio.post('/api/1.0/discrepancy', data: {
      'category': 'company_name',
      'fields': [
        {'id': 'owner', 'old_value': false, 'value': true}
      ],
      'latitude': 0,
      'longitude': 0,
      'object_id': 'string',
      'object_type': 'string',
      'user_email': 'string'
    });
    log(response.data.toString());
  }
}

enum FeedbackObjectType {
  building,
  branch,
  street,
}

Future<List<FeedbackCategoryDto>> _loadFromBackend(
  Dio dio,
  FeedbackObjectType objectType,
) async {
  try {
    final response = await dio.get('/api/1.0/discrepancy/${objectType.name}/categories');
    return FeedbackCategoryDto.parseList(response.data);
  } catch (e) {
    log(e.toString());
  }
  return [];
}
