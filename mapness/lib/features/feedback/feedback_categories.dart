import 'package:dio/dio.dart';
import 'package:mapness/entities/feedback/dto/feedback_category_dto.dart';
import 'package:mapness/entities/feedback/feedback_category.dart';
import 'package:mapness/entities/feedback/feedback_object_type.dart';
import 'package:mapness/features/feedback/feedback_dio.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feedback_categories.g.dart';

/// Provider class for fetching feedback categories.
@riverpod
class FeedbackCategories extends _$FeedbackCategories {
  /// Fetches feedback categories for a given object type.
  ///
  /// @param objectType The type of object to fetch categories for.
  /// @return List of FeedbackCategoryEntity objects.
  @override
  Future<List<FeedbackCategoryEntity>> build(
    FeedbackObjectType objectType,
  ) async {
    final dio = await ref.watch(feedbackDioProvider.future);
    final dto = await _loadFromBackend(dio, objectType);
    return dto.map((e) => e.toDomain()).toList();
  }
}

/// Loads feedback categories from the backend
///
/// @param dio The Dio instance for making HTTP requests
/// @param objectType The type of object to fetch categories for
/// @return A list of FeedbackCategoryDto objects
Future<List<FeedbackCategoryDto>> _loadFromBackend(
  Dio dio,
  FeedbackObjectType objectType,
) async {
  try {
    final response = await dio.get('/discrepancy/${objectType.name}/categories');
    return FeedbackCategoryDto.parseList(response.data);
  } catch (e, stackTrace) {
    logger.log('Failed to load feedback categories ${e.toString()}, ${stackTrace.toString()}');
  }
  return [];
}
