import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart' show Translation;

import '../../../../core/utils/utils_exports.dart' show AppColor, AppStyle, ContextConversion, UIHelper;
import '../../shared_feature_exports.dart' show AbstractionWidget, CustomElevatedButtonWidget;

class _TwoElevatedFooterButtons extends StatelessWidget {
  final VoidCallback onFirstButton;
  final String firstButtonText;
  final VoidCallback onSecondButton;
  final String secondButtonText;
  const _TwoElevatedFooterButtons({
    required this.onFirstButton,
    required this.firstButtonText,
    required this.onSecondButton,
    required this.secondButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        UIHelper.mediumPadding,
        UIHelper.smallPadding,
        UIHelper.mediumPadding,
        context.bottomPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // First button
          for (int index = 0; index < length; index++)
            Expanded(
              child: CustomElevatedButtonWidget(
                onPressed: callbacks[index],
                text: texts[index],
                textStyle: textStyles[index],
                btnColor: textColors[index],
                btnMargin: index == 0
                    ? EdgeInsetsDirectional.only(end: 14.0 / length)
                    : EdgeInsetsDirectional.only(start: 14.0 / length),
              ),
            ),
        ],
      ),
    );
  }

  int get length => texts.length;
  List<String> get texts => [firstButtonText, secondButtonText];
  List<VoidCallback> get callbacks => [onFirstButton, onSecondButton];
  List<TextStyle?> get textStyles => [AppStyle.elevatedButtonStyle, null];
  List<Color?> get textColors => [AppColor.blue, null];
}

class TwoFooterButtons extends AbstractionWidget {
  TwoFooterButtons.addCancel({super.key, required VoidCallback onAdd, required VoidCallback onCancel})
    : super(
        _TwoElevatedFooterButtons(
          onFirstButton: onCancel,
          firstButtonText: "cancelButton".tr(),
          onSecondButton: onAdd,
          secondButtonText: "addButton".tr(),
        ),
      );

  TwoFooterButtons.submitBack({super.key, required VoidCallback onSubmit, required VoidCallback onBack})
    : super(
        _TwoElevatedFooterButtons(
          onFirstButton: onBack,
          firstButtonText: "backButton".tr(),
          onSecondButton: onSubmit,
          secondButtonText: "submitButton".tr(),
        ),
      );

  TwoFooterButtons.submitCancel({super.key, required VoidCallback onSubmit, required VoidCallback onCancel})
    : super(
        _TwoElevatedFooterButtons(
          onFirstButton: onCancel,
          firstButtonText: "cancelButton".tr(),
          onSecondButton: onSubmit,
          secondButtonText: "submitButton".tr(),
        ),
      );

  TwoFooterButtons.saveCancel({super.key, required VoidCallback onSave, required VoidCallback onCancel})
    : super(
        _TwoElevatedFooterButtons(
          onFirstButton: onCancel,
          firstButtonText: "cancelButton".tr(),
          onSecondButton: onSave,
          secondButtonText: "saveButton".tr(),
        ),
      );
}
