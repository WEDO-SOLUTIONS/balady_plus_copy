import 'dart:developer';

import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:mapness/entities/feedback/dto/feedback_category_dto.dart';
import 'package:mapness/entities/feedback/feedback_category.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/dgis_http_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feedback_categories.g.dart';

enum FeedbackObjectType {
  building,
  branch,
  street,
}

@riverpod
Future<Dio> _getDio(AutoDisposeFutureProviderRef ref) async {
  final baseDio = await ref.watch(dGisHttpService.future);
  final env = await ref.watch(dgisEnvironmentProvider.future);
  return Dio(baseDio.options.copyWith(baseUrl: env.feedbackApi));
}

@riverpod
class FeedbackCategories extends _$FeedbackCategories {
  @override
  Future<List<FeedbackCategoryEntity>> build(
    ObjectTypeMessage? objectType,
  ) async {
    final dio = await ref.watch(_getDioProvider.future);

    final dto = await _loadFromBackend(dio, _feedbackTypeFromMessage(objectType));
    return dto.map((e) => e.toDomain()).toList();
  }

  Future<void> postFeedback(
    FeedbackCategoryEntity category,
  ) async {
    final dio = await ref.read(_getDioProvider.future);
    // TODO(Demezy): fix this
    final response = await dio.post('/api/1.0/discrepancy', data: {
      'category': category.name,
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

FeedbackObjectType _feedbackTypeFromMessage(ObjectTypeMessage? message) => switch (message) {
      ObjectTypeMessage.branch => FeedbackObjectType.branch,
      ObjectTypeMessage.street => FeedbackObjectType.street,
      ObjectTypeMessage.building => FeedbackObjectType.building,

      /// default for others
      _ => FeedbackObjectType.building,
    };
