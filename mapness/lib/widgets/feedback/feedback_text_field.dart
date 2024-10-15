import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/entities/feedback/fields_entity/feedback_text_type_entity.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/utils/text_utils/phone_number_formatter.dart';
import 'package:mapness/widgets/feedback/feedback_input.dart';

class FeedbackInput extends StatelessWidget {
  final FeedbackTextEntity field;

  const FeedbackInput({
    required this.field,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final keyboardType = switch (field.type) {
      FeedbackTextType.multilineText => TextInputType.multiline,
      FeedbackTextType.phone => TextInputType.phone,
      FeedbackTextType.url => TextInputType.url,
      FeedbackTextType.text => TextInputType.text,
      FeedbackTextType.email => TextInputType.emailAddress,
    };
    final allowedInputPattern = switch (field.type) {
      FeedbackTextType.email => RegExp(r'[a-zA-Z0-9\._+\-@]'),
      FeedbackTextType.url => RegExp(r'[a-zA-Z0-9./:?_\-]'),
      _ => null,
    };

    final isRequired = field.isRequired;

    return FormBuilderField<String>(
      name: field.id,
      validator: FormBuilderValidators.compose([
        switch (field.type) {
          FeedbackTextType.email => FormBuilderValidators.email(checkNullOrEmpty: isRequired),
          FeedbackTextType.phone => FormBuilderValidators.compose([
              FormBuilderValidators.phoneNumber(checkNullOrEmpty: isRequired),
              FormBuilderValidators.minLength(
                PhoneNumberFormatter.arabicPhoneNumberMinLength,
                checkNullOrEmpty: isRequired,
              ),
            ]),
          FeedbackTextType.url => FormBuilderValidators.url(checkNullOrEmpty: isRequired),
          _ when isRequired => FormBuilderValidators.required(),
          _ => (_) => null,
        },
      ]),
      builder: (fieldState) => FeedbackTextInput(
        labelText: field.label,
        hintText: field.hint,
        onValidate: (_) => fieldState.isValid ? null : context.l10n.feedbackTextFieldWrongFormat,
        allowedInputPattern: allowedInputPattern,
        isRequired: field.isRequired,
        maxLength: field.maxLength,
        keyboardType: keyboardType,
        maxLines: field.type == FeedbackTextType.multilineText ? 5 : 1,
        onChanged: fieldState.didChange,
        type: field.type,
      ),
    );
  }
}
