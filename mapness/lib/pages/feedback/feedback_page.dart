import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/feedback.dart';
import 'package:mapness/entities/feedback/feedback_object_type.dart';
import 'package:mapness/features/feedback/feedback_categories.dart';
import 'package:mapness/features/feedback/poi_feedback.dart';
import 'package:mapness/pages/feedback/components/feedback_form_widget.dart';
import 'package:mapness/pages/feedback/feedback_failure_widget.dart';
import 'package:mapness/pages/feedback/feedback_loading_widget.dart';
import 'package:mapness/widgets/feedback/feedback_form_container.dart';

class FeedbackPage extends ConsumerStatefulWidget {
  final String categoryId;
  final String poiId;

  const FeedbackPage({
    required this.poiId,
    required this.categoryId,
    super.key,
  });

  @override
  ConsumerState<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends ConsumerState<FeedbackPage> {
  final _isFormValidNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final objectId = int.tryParse(widget.poiId);
    if (objectId == null) {
      return const FeedbackFailureWidget();
    }
    final poiData = ref.watch(poiFeedbackProvider(objectId));
    final objectType = poiData.valueOrNull?.types[0]?.type;
    final categories = ref.watch(
      feedbackCategoriesProvider(FeedbackObjectType.fromMessage(objectType)),
    );

    if (poiData.isLoading || categories.isLoading) {
      return const FeedbackLoadingWidget();
      // return const Center(child: Text('Loading'));
    } else if (poiData.hasError || categories.hasError) {
      return const FeedbackFailureWidget();
      // return const Center(child: Text('Error no data'));
    }

    final category = categories.value?.firstWhereOrNull((element) => element.id == widget.categoryId);

    if (category == null || category.fields.isEmpty) {
      return const FeedbackFailureWidget();
    }

    return ValueListenableBuilder(
      valueListenable: _isFormValidNotifier,
      builder: (context, isFormValid, child) => FeedbackFormContainer(
        title: category.name,
        isSendEnabled: isFormValid,
        child: child!,
        onSend: () => FeedbackSentRoute(
          objectId: widget.poiId,
          categoryId: widget.categoryId,
        ).replace(context),
      ),
      child: FeedbackFormWidget(
        fields: category.fields,
        isFormValidNotifier: _isFormValidNotifier,
      ),
    );
  }
}
