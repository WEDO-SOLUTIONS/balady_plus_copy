import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/feedback.dart';
import 'package:mapness/entities/feedback/feedback_category.dart';
import 'package:mapness/features/feedback/feedback_categories.dart';
import 'package:mapness/features/feedback/poi_feedback.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_select_options_widget.dart';

class FeedbackSelectOptionsComponentWidget extends ConsumerWidget {
  final int objectId;
  const FeedbackSelectOptionsComponentWidget({required this.objectId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poiData = ref.watch(poiFeedbackProvider(objectId));
    final categories = ref.watch(feedbackCategoriesProvider);

    return switch ((poiData, categories)) {
      (AsyncValue(value: final poiData), AsyncValue(value: final categories))
          when poiData != null && categories != null && categories.isNotEmpty =>
        FeedbackSelectOptionsWidget(
          poiDataValue: poiData,
          categoriesValue: categories,
          onTap: (category, objectId) => _onTap(context, category, objectId),
        ),
      (AsyncValue.loading, _) ||
      (_, AsyncValue.loading) =>
        Center(child: Loading.large()),
      _ => Center(child: Text(context.l10n.failedToLoadData)),
    };
  }

  void _onTap(
      BuildContext context, FeedbackCategoryEntity category, int? objectId) {
    final objectId_ = objectId.toString();
    FeedbackRoute(objectId: objectId_, schemeId: category.id).push(context);
  }
}
