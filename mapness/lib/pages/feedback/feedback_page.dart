import 'package:auto_route/auto_route.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/entities/feedback/feedback_category.dart';
import 'package:mapness/entities/feedback/fields_entity/feedback_text_type_entity.dart';
import 'package:mapness/features/feedback/submit_feedback_payload.dart';
import 'package:mapness/pages/feedback/components/feedback_form_widget.dart';
import 'package:mapness/shared/lib/file_upload.dart';
import 'package:mapness/shared/utils/text_utils/phone_number_formatter.dart';
import 'package:mapness/widgets/feedback/feedback_form_container.dart';

@RoutePage()
class FeedbackPage extends ConsumerStatefulWidget {
  final int? objectId;
  final FeedbackCategoryEntity category;

  const FeedbackPage({required this.category, this.objectId, super.key});

  @override
  ConsumerState<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends ConsumerState<FeedbackPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _isFormValidNotifier = ValueNotifier<bool>(false);
  static const _websiteUrl = 'website_url';

  final Map<FeedbackTextType, String? Function(String?)> validators = {
    FeedbackTextType.email: FormBuilderValidators.email(checkNullOrEmpty: false),
    FeedbackTextType.phone: PhoneNumberFormatter.validateSaudiMobile,
    FeedbackTextType.url: FormBuilderValidators.url(checkNullOrEmpty: false),
  };

  @override
  void dispose() {
    _isFormValidNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;

    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      onChanged: () => _checkRequiredFields(category.fields),

      /// limit rebuilds to form title with send
      child: ValueListenableBuilder(
        valueListenable: _isFormValidNotifier,
        builder: (context, isFormValid, child) => FeedbackFormContainer(
          title: category.name,
          isSendEnabled: isFormValid,
          onSend: () => _collectForm(objectId: widget.objectId, categoryId: category.id),
          child: child!,
        ),
        child: FeedbackFormWidget(fields: category.fields, objectId: widget.objectId),
      ),
    );
  }

  void _collectForm({required String categoryId, int? objectId}) {
    if (widget.objectId != null) {
      context.router.pop();
    }
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
    final fields = formState.value.entries
        .map((entry) => MapEntry(entry.key, formState.getTransformedValue(entry.key, fromSaved: true)))
        .toList();

    final hasPhotos = widget.category.fields.whereType<FeedbackImageInputEntity>().any((imageField) {
      final value = formState.getTransformedValue(imageField.id, fromSaved: true);
      return value is List<String> && value.isNotEmpty;
    });

    /// tweak to pass compex structure through gorouter.
    /// Id guarantee that old provider would be disposed if new form filled,
    /// state do not mix
    final payloadId = 'feedback_${DateTime.now().millisecondsSinceEpoch}';

    ref.read(submitFeedbackPayloadProvider(payloadId).notifier)
      // pass data
      ..collectForm(objectId: objectId, categoryId: categoryId, fields: fields, hasPhotos: hasPhotos)
      // guarantee that provider would be alive after navigation.
      // probably for thousands of filled form within this time window
      // may be mem overflow, but esimate as impossible
      ..keepAliveForAWhile();

    /// If the feedback was sent from POI page, we replace the current route
    /// with the FeedbackSentPage to avoid poping back from the POI page and deleting the marker.
    if (context.router.stack.any((r) => r.name?.toLowerCase() == 'poi')) {
      context.router.replace(FeedbackSentRoute(payloadId: payloadId));
      return;
    }

    context.router.pushAndPopUntil(
      FeedbackSentRoute(payloadId: payloadId),
      predicate: (route) =>
          route.settings.name == BottomMenuRoute.name ||
          route.settings.name == PathNavRoute.name ||
          route.settings.name == SearchRoute.name,
    );
  }

  void _checkRequiredFields(List<FeedbackBaseEntity> fields) {
    final formFields = _formKey.currentState?.fields;

    if (formFields == null) {
      _isFormValidNotifier.value = false;
      return;
    }

    final allFieldsValid = fields.every((field) {
      final value = formFields[field.id]?.value;

      // check image inputs
      if (field is FeedbackImageInputEntity) {
        final images = value is IList<FileUpload> ? value.toList() : <FileUpload>[];
        final allUploaded = images.every((img) => img is FileUploadSuccess);
        return field.isRequired ? images.isNotEmpty && allUploaded : images.isEmpty || allUploaded;
      }

      final String displayValue = switch (value) {
        null => '',
        final List<String> v when v.isEmpty => '',
        final List<String> v => v.join(', '),
        _ => value.toString(),
      };

      final fieldType = _checkFieldType(field);
      final validator = validators[fieldType];

      if (value is List<String>) {
        return !value.any((element) => element.isEmpty || validator?.call(element) != null);
      }
      final error = validator?.call(displayValue);

      return field.isRequired ? displayValue.isNotEmpty && error == null : displayValue.isEmpty || error == null;
    });
    _isFormValidNotifier.value = allFieldsValid;
  }

  FeedbackTextType? _checkFieldType(FeedbackBaseEntity field) {
    if (field.id == FeedbackTextType.email.name) {
      return FeedbackTextType.email;
    } else if (field.id == FeedbackTextType.phone.name) {
      return FeedbackTextType.phone;
    } else if (field.id == _websiteUrl) {
      return FeedbackTextType.url;
    }

    return null;
  }
}
