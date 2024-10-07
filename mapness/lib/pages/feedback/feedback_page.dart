// ignore_for_file: unused_local_variable, unused_import, avoid_print

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/feedback.dart';
import 'package:mapness/entities/feedback/feedback_object_type.dart';
import 'package:mapness/features/feedback/feedback_categories.dart';
import 'package:mapness/features/feedback/poi_feedback.dart';
import 'package:mapness/features/feedback/submit_feedback_payload.dart';
import 'package:mapness/pages/feedback/components/feedback_form_widget.dart';
import 'package:mapness/pages/feedback/feedback_failure_widget.dart';
import 'package:mapness/pages/feedback/feedback_loading_widget.dart';
import 'package:mapness/widgets/feedback/feedback_form_container.dart';

final _formKey = GlobalKey<FormBuilderState>();

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
    } else if (poiData.hasError || categories.hasError) {
      return const FeedbackFailureWidget();
    }

    final category = categories.value?.firstWhereOrNull((element) => element.id == widget.categoryId);

    if (category == null || category.fields.isEmpty) {
      return const FeedbackFailureWidget();
    }

    return FormBuilder(
      key: _formKey,
      onChanged: () => _isFormValidNotifier.value = _formKey.currentState?.isValid ?? false,

      /// limit rebuilds to form title with send
      child: ValueListenableBuilder(
        valueListenable: _isFormValidNotifier,
        builder: (context, isFormBalid, child) => FeedbackFormContainer(
          title: category.name,
          isSendEnabled: isFormBalid,
          onSend: () => _collectForm(objectId, category.id),
          child: child!,
        ),
        child: FeedbackFormWidget(fields: category.fields),
      ),
    );
  }

  void _collectForm(int objectId, String categoryId) {
    final formState = _formKey.currentState;
    if (formState == null) {
      return;
    }

    final isFormValid = formState.saveAndValidate();
    // if for any reason validation has not been triggered, than this will do it
    // and disable button until form valid. But actually step is redundant in current configuration.
    if (!isFormValid) {
      return;
    }
    final fields = formState.value.entries;
    print('>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    print(fields);
    // print(jsonEncode(formState.value));
    print('<<<<<<<<<<<<<<<<<<<<<<<<<<<');

    /// tweak to pass compex structure through gorouter.
    /// Id guarantee that old provider would be disposed if new form filled,
    /// state do not mix
    final payloadId = 'feedback_${DateTime.now().millisecondsSinceEpoch}';

    ref.read(submitFeedbackPayloadProvider(payloadId).notifier)
      // pass data
      ..collectForm(
        objectId: objectId,
        categoryId: categoryId,
        fields: fields,
      )
      // guarantee that provider would be alive after navigation.
      // probably for thousands of filled form within this time window
      // may be mem overflow, but esimate as impossible
      ..keepAliveForAWhile();

    FeedbackSentRoute(
      payloadId: payloadId,
      objectId: widget.poiId,
      categoryId: widget.categoryId,
    ).replace(context);
  }
}
