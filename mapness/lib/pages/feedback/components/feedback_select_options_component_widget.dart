import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/feedback.dart';
import 'package:mapness/entities/feedback/feedback_category.dart';
import 'package:mapness/entities/feedback/feedback_object_type.dart';
import 'package:mapness/features/feedback/feedback_categories.dart';
import 'package:mapness/features/feedback/poi_feedback.dart';
import 'package:mapness/pages/feedback/feedback_failure_widget.dart';
// import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_select_options_widget.dart';

class FeedbackSelectOptionsComponentWidget extends ConsumerWidget {
  final int objectId;
  const FeedbackSelectOptionsComponentWidget({
    required this.objectId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poiData = ref.watch(poiFeedbackProvider(objectId));
    final objectType = poiData.valueOrNull?.types[0]?.type;
    final provider = feedbackCategoriesProvider(FeedbackObjectType.fromMessage(objectType));
    final categories = ref.watch(provider);

    return switch ((poiData, categories)) {
      (AsyncValue(value: final poiData), AsyncValue(value: final categories))
          when poiData != null && categories != null && categories.isNotEmpty =>
        FeedbackSelectOptionsWidget(
          poiDataValue: poiData,
          categoriesValue: categories,
          onTap: (category, objectId) => _onTap(context, category, objectId),
        ),
      (AsyncLoading(), _) || (_, AsyncLoading()) => Center(child: Loading.large()),
      (_, AsyncData(isLoading: final isLoading)) when isLoading == true => Center(child: Loading.large()),
      _ => FeedbackFailureWidget(
          isFullscreen: false,
          onRetry: () {
            ref.invalidate(feedbackCategoriesProvider(FeedbackObjectType.fromMessage(objectType)));
          },
        ),
    };
  }

  void _onTap(
    BuildContext context,
    FeedbackCategoryEntity category,
    int? objectId,
  ) {
    final objectId_ = objectId.toString();
    FeedbackRoute(objectId: objectId_, categoryId: category.id).push(context);
  }
}
