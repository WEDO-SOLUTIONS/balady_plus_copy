import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../texts/custom_text_field_widget.dart';

class TextWithCheckBtn extends StatefulWidget {
  final String title;
  final String? textHint;
  final String? currentValue;
  final String? hint;
  final Function onTextChanged;
  final bool isValidate;
  final double bottomViewInsets;
  final Function verify;
  final Function validate;
  final TextEditingController? controller;
  final String? errorText;
  final Color? backgroundColor;
  final int? maxLength;
  final bool enabled;
  final TextInputType? textInputType;
  final double? topPadding;
  final bool showToolTip;
  final String? toolTipMessage;

  const TextWithCheckBtn({
    super.key,
    required this.title,
    this.hint,
    this.controller,
    this.textHint,
    this.currentValue,
    required this.onTextChanged,
    required this.isValidate,
    this.bottomViewInsets = 0,
    required this.verify,
    this.errorText,
    this.backgroundColor,
    this.maxLength,
    required this.validate,
    this.enabled = true,
    this.textInputType,
    this.topPadding,
    this.showToolTip = false,
    this.toolTipMessage,
  });
  @override
  _TextWithCheckBtnState createState() => _TextWithCheckBtnState();
}

class _TextWithCheckBtnState extends State<TextWithCheckBtn> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller?.text = widget.currentValue ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: <Widget>[
        CustomTextFieldWidget(
          label: widget.title,
          controller: widget.controller,
          fillColor: widget.backgroundColor,
          focusNode: _focusNode,
          hintText: widget.hint ?? "",
          errorText: widget.errorText,
          keyboardType: widget.textInputType ?? const TextInputType.numberWithOptions(signed: false),
          maxLength: widget.maxLength,
          onValidate: (String? t) => widget.validate(t),
          enabled: widget.enabled,
          onChanged: (value) => {widget.onTextChanged(value)},
          showToolTip: widget.showToolTip,
          toolTipMessage: widget.toolTipMessage,
        ),
        Padding(
          padding: EdgeInsetsDirectional.only(
            bottom: 0.0,
            end: 8,
            top: widget.maxLength == null
                ? widget.topPadding != null
                      ? widget.topPadding!
                      : 40
                : 0,
          ),
          child: SizedBox(
            width: 100,
            child: ElevatedButtonWidget.verify(
              text: widget.isValidate ? ("done_check").tr() : ("check").tr(),
              onPressed: () {
                if (widget.isValidate == false) {
                  widget.verify();
                  FocusScope.of(context).unfocus();
                }
              },
            ),
          ),

          // InkWell(
          //   onTap: widget.isValidate
          //       ? null
          //       : () {
          //           widget.verify();
          //           FocusScope.of(context).unfocus();
          //         },
          //   child: SizedBox(
          //     width: 100,
          //     height: 50,
          //     child: Align(
          //       alignment: AlignmentDirectional.centerEnd,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.end,
          //         children: [
          //           if (widget.isValidate)
          //             Padding(
          //               padding: const EdgeInsets.symmetric(horizontal: 4),
          //               child: Image.asset(
          //                 "assets/images/verified@3x.webp",
          //                 height: 12,
          //                 width: 12,
          //               ),
          //             ),
          //           CustomTextWidget(
          //             widget.isValidate ? ("done_check").tr() : ("check").tr(),
          //             fontColor:
          //                 widget.isValidate ? Colors.black : const Color(0xff389492),
          //             fontSize: 14,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ),
      ],
    );
  }
}
