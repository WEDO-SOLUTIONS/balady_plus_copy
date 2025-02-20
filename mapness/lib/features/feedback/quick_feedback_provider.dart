import 'package:collection/collection.dart';
import 'package:mapness/entities/feedback/feedback_category.dart';
import 'package:mapness/entities/feedback/feedback_object_type.dart';
import 'package:mapness/entities/feedback/page_params/feedback_route_params.dart';
import 'package:mapness/features/feedback/feedback_categories.dart';
import 'package:mapness/features/feedback/poi_feedback.dart';
import 'package:mapness/pages/feedback/quick_feedback_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quick_feedback_provider.g.dart';

@riverpod
class QuickFeedback extends _$QuickFeedback {
  @override
  Future<List<FeedbackCategoryEntity>> build(final QuickFeedbackType type, final FeedbackBaseRouteParams params) async {
    final feedbackObjectType = await _feedbackToType(type, params);
    final categories = await ref.watch(feedbackCategoriesProvider(feedbackObjectType).future);

    if (categories.isEmpty) {
      return const [];
    }

    if (type == QuickFeedbackType.newCompany || type == QuickFeedbackType.addPhoto) {
      //TODO: Implement firebase remote config logic to store params
      final category = categories.firstWhereOrNull(
        (e) =>
            (type == QuickFeedbackType.newCompany && e.id == 'add_company') ||
            (type == QuickFeedbackType.addPhoto && e.id == 'add_photo'),
      );
      return category != null ? [category] : [];
    }

    return categories;
  }

  Future<FeedbackObjectType> _feedbackToType(QuickFeedbackType type, FeedbackBaseRouteParams params) async {
    final id = switch (params) {
      FeedbackObjectIdParams(objectId: final id) => id,
      _ => null,
    };

    if (id == null) {
      return FeedbackObjectType.building;
    }

    return switch (type) {
      QuickFeedbackType.newCompany || QuickFeedbackType.addPhoto => FeedbackObjectType.building,
      _ => await _getObjectTypeFromId(id),
    };
  }

  Future<FeedbackObjectType> _getObjectTypeFromId(int id) async {
    final poiData = await ref.read(poiFeedbackProvider(id).future);
    return FeedbackObjectType.fromMessage(poiData?.types.firstOrNull?.type);
  }
}
