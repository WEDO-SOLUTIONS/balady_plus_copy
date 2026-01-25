import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/entities/feedback/page_params/feedback_route_params.dart';
import 'package:mapness/features/feedback/quick_feedback_provider.dart';
import 'package:mapness/pages/feedback/components/feedback_select_options_component_widget.dart';
import 'package:mapness/pages/feedback/feedback_failure_widget.dart';
import 'package:mapness/pages/feedback/feedback_page.dart';

enum QuickFeedbackType { newCompany, editCompany, addPhoto, other }

@RoutePage()
class QuickFeedbackPage extends StatelessWidget {
  /// This params used if you want to open the page with [push] functionality
  final QuickFeedbackType type;
  final FeedbackBaseRouteParams params;

  /// Optional parameters used for open with deeplink like [com.balady://QuickFeedbackRoute?type=addPhoto&id=1]
  final int? objectId;
  final String? feedbackType;

  const QuickFeedbackPage({
    this.type = QuickFeedbackType.newCompany,
    @QueryParam('type') this.feedbackType,
    @QueryParam('id') this.objectId,
    this.params = const FeedbackNoParams(),
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.colors.backgroundSurface4,
        body: _QuickFeedbackScreen(
          type: feedbackType != null
              ? QuickFeedbackType.values.firstWhereOrNull((e) => e.name == feedbackType) ?? type
              : type,
          params: objectId != null ? FeedbackObjectIdParams(objectId!) : params,
        ),
      );
}

class _QuickFeedbackScreen extends ConsumerWidget {
  final QuickFeedbackType type;
  final FeedbackBaseRouteParams params;

  const _QuickFeedbackScreen({required this.type, required this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = quickFeedbackProvider(type, params);

    final categories = ref.watch(provider);

    if (categories.hasError) {
      return FeedbackFailureWidget(
        onRetry: () {
          ref.invalidate(provider);
        },
      );
    }

    if (categories.isLoading || categories.hasValue == false) {
      return Center(
        child: Loading.large(),
      );
    }

    if (categories.hasValue && (categories.value?.isEmpty ?? true)) {
      return FeedbackFailureWidget(
        onRetry: () {
          ref.invalidate(provider);
        },
      );
    }

    switch (type) {
      case QuickFeedbackType.newCompany:
        final category = categories.value?.firstOrNull;
        if (category == null) {
          return FeedbackFailureWidget(
            onRetry: () {
              ref.invalidate(provider);
            },
          );
        }
        return FeedbackPage(
          category: category,
        );
      case QuickFeedbackType.addPhoto:
        final category = categories.value?.firstOrNull;
        if (category == null || params is! FeedbackObjectIdParams) {
          return FeedbackFailureWidget(
            onRetry: () {
              ref.invalidate(provider);
            },
          );
        }

        final objectId = (params as FeedbackObjectIdParams).objectId;

        return FeedbackPage(
          category: category,
          objectId: objectId,
        );
      case QuickFeedbackType.editCompany:
      case QuickFeedbackType.other:
        if (params is! FeedbackObjectIdParams) {
          return FeedbackFailureWidget(
            onRetry: () {
              ref.invalidate(provider);
            },
          );
        }
        final objectId = (params as FeedbackObjectIdParams).objectId;

        return FeedbackSelectOptionsComponentWidget(objectId: objectId);
    }
  }
}
