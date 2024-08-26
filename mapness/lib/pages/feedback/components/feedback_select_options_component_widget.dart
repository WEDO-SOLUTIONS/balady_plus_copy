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

    if (poiData.isLoading || categories.isLoading) {
      return Center(child: Loading.large());
    } else if (poiData.hasError || categories.hasError) {
      return Center(child: Text(context.l10n.failedToLoadData));
    }

    final poiDataValue = poiData.value;
    final categoriesValue = categories.value;

    return FeedbackSelectOptionsWidget(
      poiDataValue: poiDataValue!,
      categoriesValue: categoriesValue!,
      onTap: (category, objectId) => _onTap(context, category, objectId),
    );
  }

  void _onTap(
      BuildContext context, FeedbackCategoryEntity category, int? objectId) {
    final objectId_ = objectId.toString();
    FeedbackRoute(objectId: objectId_, schemeId: category.id).push(context);
  }
}
