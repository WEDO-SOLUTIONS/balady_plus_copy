import 'package:balady_plus/etmam_app/core/utils/constants/app_color.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/widgets/bidding_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../app/features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../core/utils/enums/dynamic_forms.dart';
import '../../../../core/utils/extensions/decimal_text_input_formatter.dart';

class DynamicFormTextField extends StatefulWidget {
  final String label;
  final bool isRequired;
  final bool isReadOnly;
  final Function(String? text) onChanged;
  final List<String>? errors;
  final DynamicFormFieldDataType? type;
  final int? decimalPercentage;
  final int? maxLength;
  final String? errorText;
  final dynamic? initialValue;

  const DynamicFormTextField(
      {super.key,
      required this.label,
      required this.onChanged,
      this.isRequired = false,
      this.isReadOnly = false,
      this.type,
      this.decimalPercentage,
      this.maxLength,
      this.errorText,
      this.errors,
      this.initialValue});

  @override
  State<DynamicFormTextField> createState() => _DynamicFormTextFieldState();
}

class _DynamicFormTextFieldState extends State<DynamicFormTextField> {
  TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.initialValue != null)
      _controller.text = widget.initialValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFieldWidget(
          key: widget.key,
          focusNode: _focusNode,
          label: widget.label,
          hintText: widget.label,
          controller: _controller,
          onChanged: widget.onChanged,
          onValidate: (String? d) {},
          errorText: widget.errorText,
          spacerSize: 16,
          inputFormatters: [
            if (widget.decimalPercentage != null &&
                widget.decimalPercentage! > 0)
              DecimalTextInputFormatter(
                  decimalRange: widget.decimalPercentage!),
            if (widget.maxLength != null)
              new LengthLimitingTextInputFormatter(widget.maxLength),
            if (widget.type == DynamicFormFieldDataType.integer)
              FilteringTextInputFormatter.digitsOnly,
          ],
          keyboardType: getInputType(),
        ),
        BiddingErrorsWidget(
          errors: widget.errors,
        )
      ],
    ));
  }

  TextInputType getInputType() {
    switch (widget.type) {
      case DynamicFormFieldDataType.integer:
        return TextInputType.number;
      case DynamicFormFieldDataType.string:
        return TextInputType.text;
      case DynamicFormFieldDataType.decimal:
        return TextInputType.numberWithOptions(decimal: true);
      case DynamicFormFieldDataType.none:
        return TextInputType.text;
      default:
        return TextInputType.text;
    }
  }
}
