import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/feedback/feedback_category.dart';
import 'package:mapness/entities/feedback/feedback_object_type.dart';
import 'package:mapness/features/feedback/feedback_categories.dart';
import 'package:mapness/features/feedback/poi_feedback.dart';
import 'package:mapness/pages/feedback/feedback_failure_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_form_container.dart';
import 'package:mapness/widgets/feedback/feedback_select_options_widget.dart';

part 'feedback_select_options_form_container.dart';

class FeedbackSelectOptionsComponentWidget extends ConsumerWidget {
  final int objectId;

  const FeedbackSelectOptionsComponentWidget({
    required this.objectId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poiData = ref.watch(poiFeedbackProvider(objectId));
    final objectType = poiData.value?.types.firstOrNull?.type;
    final provider = feedbackCategoriesProvider(FeedbackObjectType.fromMessage(objectType));
    final categories = ref.watch(provider);

    final loader = FeedbackSelectOptionsFormContainer(
      child: Center(
        child: Loading.large(),
      ),
    );
    final hasData = poiData.hasValue && categories.hasValue && categories.value!.isNotEmpty;

    if (hasData) {
      return FeedbackSelectOptionsFormContainer(
        child: FeedbackSelectOptionsWidget(
          poiDataValue: poiData.value!,
          categoriesValue: categories.value!,
          onTap: (category, objectId) => _onTap(context, category, objectId),
        ),
      );
    }

    return switch ((poiData, categories)) {
      (AsyncValue(value: final poiData), AsyncValue(value: final categories))
          when poiData != null && categories != null && categories.isNotEmpty =>
        FeedbackSelectOptionsFormContainer(
          child: FeedbackSelectOptionsWidget(
            poiDataValue: poiData,
            categoriesValue: categories,
            onTap: (category, objectId) => _onTap(context, category, objectId),
          ),
        ),
      (AsyncLoading(), _) || (_, AsyncLoading()) => loader,
      (_, AsyncData(isLoading: final isLoading)) when isLoading => loader,
      (AsyncData(isLoading: final isLoading), _) when isLoading => loader,
      _ => FeedbackFailureWidget(
          onRetry: () {
            ref.invalidate(provider);
          },
        ),
    };
  }

  void _onTap(
    BuildContext context,
    FeedbackCategoryEntity category,
    int? objectId,
  ) {
    context.router.push(
      FeedbackRoute(
        category: category,
        objectId: objectId,
      ),
    );
  }
}
