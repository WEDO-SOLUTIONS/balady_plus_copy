import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppFontWeight, AppStyle, ContextConversion, UIHelper;
import '../../../shared_feature_exports.dart'
    show
        ActionButtonsComponent,
        CustomAutoSizeTextWidget,
        ListOfButtonsActions,
        ListOfButtonsIcons,
        ListOfButtonsTexts,
        ListOfButtonsTextsColors,
        MoreActionsWidget;

class TitleWithActionsComponent extends StatelessWidget {
  final EdgeInsets? padding;
  final String title;
  final Widget? action;
  final ListOfButtonsIcons btnIcons;
  final ListOfButtonsTexts btnTexts;
  final ListOfButtonsTextsColors btnTextsColors;
  final ListOfButtonsActions btnOnActions;
  const TitleWithActionsComponent({
    super.key,
    this.padding,
    required this.title,
    this.action,
    this.btnOnActions = const [],
    this.btnIcons = const [],
    this.btnTexts = const [],
    this.btnTextsColors = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? _padding,
      child: LayoutBuilder(
        builder: (_, constraints) => Row(
          children: [
            // Title widget
            SizedBox(
              width: constraints.maxWidth - 25.0, // remove more actions width
              child: CustomAutoSizeTextWidget(
                title,
                textStyle: textStyle,
                maxLines: 2,
                maxFontSize: 18.0,
                minFontSize: 12.0,
              ),
            ),
            if (disappearActions)
              const SizedBox()
            else if (action != null)
              action!
            else
              // More Actions
              MoreActionsWidget(
                action: ActionButtonsComponent(
                  btnIcons: btnIcons,
                  btnTexts: btnTexts,
                  btnTextsColors: btnTextsColors,
                  btnOnActions: [
                    for (var func in btnOnActions)
                      () {
                        // Close dialog firstly
                        context.popDialog();
                        // Perform function
                        func();
                      }
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool get disappearActions =>
      action == null && btnIcons.isEmpty && btnTexts.isEmpty && btnTextsColors.isEmpty && btnOnActions.isEmpty;

  EdgeInsetsGeometry get _padding => const EdgeInsets.symmetric(horizontal: UIHelper.smallPadding);
  TextStyle get textStyle => AppStyle.mainTextStyle.copyWith(
        fontWeight: AppFontWeight.medium.fontWeight,
        letterSpacing: 0.5,
        fontSize: 18.0,
      );
}
