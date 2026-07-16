import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/entities/feedback/fields_entity/feedback_text_type_entity.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/utils/text_utils/phone_number_formatter.dart';
import 'package:mapness/widgets/feedback/feedback_input.dart';

class FeedbackInput extends HookWidget {
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

    final controller = useTextEditingController();
    final focusNode = useFocusNode();

    return FormBuilderField<String>(
      name: field.id,
      validator: FormBuilderValidators.compose([
        switch (field.type) {
          FeedbackTextType.email => FormBuilderValidators.email(checkNullOrEmpty: false),
          FeedbackTextType.phone => PhoneNumberFormatter.validateSaudiMobile,
          FeedbackTextType.url => FormBuilderValidators.url(checkNullOrEmpty: false),
          _ => (_) => null,
        },
      ]),
      builder: (fieldState) {
        final isAddress = field.id == 'address';
        final textFieldWidget = FeedbackTextInput(
          labelText: field.label,
          hintText: field.hint,
          controller: controller,
          focusNode: focusNode,
          errorText: fieldState.hasError ? context.l10n.feedbackTextFieldWrongFormat : null,
          allowedInputPattern: allowedInputPattern,
          isRequired: field.isRequired,
          maxLength: isAddress ? null : field.maxLength,
          keyboardType: keyboardType,
          maxLines: isAddress
              ? null
              : field.type == FeedbackTextType.multilineText
              ? 5
              : 1,
          onChanged: (value) {
            final trimmedStart = value.replaceFirst(RegExp(r'^\s+'), '');

            if (trimmedStart != value) {
              controller.value = TextEditingValue(
                text: trimmedStart,
                selection: TextSelection.collapsed(
                  offset: trimmedStart.length,
                ),
              );
            }

            fieldState.didChange(trimmedStart);
          },
          type: field.type,
        );
        return Column(
          children: [
            if (field.id == 'address')
              GestureDetector(
                onTap: () => _selectAddress(context, controller, fieldState),
                child: AbsorbPointer(
                  child: textFieldWidget,
                ),
              ),
            if (field.id != 'address') textFieldWidget,
            if (field.setOnMap)
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: Spacing.$3x),
                  child: AppButton(
                    buttonType: ButtonType.secondary,
                    buttonColorScheme: ButtonColorScheme.accent,
                    primaryLabel: context.l10n.setOnTheMap,
                    primaryIcon: GeneralIcons.pin,
                    onTap: () => _selectRoute(context, controller, fieldState),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _selectRoute(
    BuildContext context,
    TextEditingController controller,
    FormFieldState field,
  ) async {
    final result = await context.router.push(const RoutingMapSelectRoute());

    if (result == null || result is! RoutePoint) {
      return;
    }

    final location = result.label ?? 'lat:${result.latitude}, lon:${result.longitude}';
    controller.text = location;
    field.didChange(location);
  }

  Future<void> _selectAddress(
    BuildContext context,
    TextEditingController controller,
    FormFieldState field,
  ) async {
    final result = await context.router.push(const FeedbackAddressSuggester());

    if (result == null || result is! RoutePoint) {
      return;
    }

    final location = result.label ?? 'lat:${result.latitude}, lon:${result.longitude}';
    controller.text = location;
    field.didChange(location);
  }
}
