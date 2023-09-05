import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../texts/custom_text_field_widget.dart';
import '../texts/custom_text_widget.dart';

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
  final TextEditingController controller;
  final String? errorText;
  final Color? backgroundColor;

  TextWithCheckBtn(
      {required this.title,
      this.hint,
      required this.controller,
      this.textHint,
      this.currentValue,
      required this.onTextChanged,
      required this.isValidate,
      this.bottomViewInsets = 0,
      required this.verify,
      this.errorText,
      this.backgroundColor,
      required this.validate});
  @override
  _TextWithCheckBtnState createState() => _TextWithCheckBtnState();
}

class _TextWithCheckBtnState extends State<TextWithCheckBtn> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.text = widget.currentValue ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        CustomTextFieldWidget(
          label: widget.title,
          controller: widget.controller,
          fillColor: widget.backgroundColor,
          focusNode: _focusNode,
          hintText: widget.hint ?? "",
          errorText: widget.errorText,
          keyboardType: TextInputType.numberWithOptions(signed: false),
          maxLength: 10,
          onValidate: (String? t) => widget.validate(t),
          onChanged: (value) => {widget.onTextChanged(value)},
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 0.0, left: 8),
          child: InkWell(
            onTap: widget.isValidate
                ? null
                : () {
                    widget.verify();
                    FocusScope.of(context).unfocus();
                  },
            child: Container(
              width: 100,
              height: 50,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.isValidate)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Image.asset(
                          "assets/images/verified@3x.png",
                          height: 12,
                          width: 12,
                        ),
                      ),
                    CustomTextWidget(
                      widget.isValidate ? ("done_check").tr() : ("check").tr(),
                      fontColor:
                          widget.isValidate ? Colors.black : Color(0xff389492),
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
