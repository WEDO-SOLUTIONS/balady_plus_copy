import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart' show Translation;

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, AppStyle, ContextConversion, UIHelper, WidgetConversion;
import '../../../shared_feature_exports.dart'
    show CustomElevatedButtonWidget, CustomElevatedStackIconButtonWidget, DrawIconBasedTypeWidget;

class ActionButtonComponent extends StatelessWidget {
  final VoidCallback onAction;
  final String actionBtnText;
  final Object? icon;
  // final IconData? materialIcon;
  final double iconSize;
  final VoidCallback? onClose;
  final String? closeBtnText;
  const ActionButtonComponent({
    super.key,
    required this.onAction,
    required this.actionBtnText,
    this.icon,
    // this.materialIcon,
    this.iconSize = 24.0,
    this.onClose,
    this.closeBtnText,
  });

  @override
  Widget build(BuildContext context) {
    return ActionButtonsComponent(
      btnOnActions: [onAction],
      btnTexts: [actionBtnText],
      btnIcons: [icon],
      btnTextsColors: const [null],
      iconSize: iconSize,
      closeBtnText: closeBtnText,
      onClose: onClose,
    );
  }
}

typedef ListOfButtonsActions = List<VoidCallback>;
typedef ListOfButtonsTexts = List<String>;
typedef ListOfButtonsIcons = List<Object?>;
typedef ListOfButtonsTextsColors = List<Color?>;

class ActionButtonsComponent extends StatelessWidget {
  final ListOfButtonsActions btnOnActions;
  final ListOfButtonsTexts btnTexts;
  final ListOfButtonsIcons? btnIcons;
  final ListOfButtonsTextsColors? btnTextsColors;
  final double iconSize;
  final VoidCallback? onClose;
  final String? closeBtnText;
  const ActionButtonsComponent({
    super.key,
    required this.btnOnActions,
    required this.btnTexts,
    this.btnIcons,
    this.btnTextsColors,
    this.iconSize = 24.0,
    this.closeBtnText,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppStyle.defaultPadding.copyWith(bottom: context.bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Action-Button Widget
          if (isActionsEqualsTexts)
            throw Exception("Buttons must have same length of texts and actions")
          else if (isIconsNotNullAndEqualsLength)
            throw Exception("Buttons icons must have same length")
          else if (isTextsColorsNotNullAndEqualsLength)
            throw Exception("Buttons text-colors must have same length")
          else
            for (int index = 0; index < length; index++)
              CustomElevatedStackIconButtonWidget(
                onPressed: btnOnActions[index],
                btnAlignment: AlignmentDirectional.centerStart,
                btnColor: AppColor.white,
                btnHeight: 75.0,
                btnPadding: btnPadding,
                btnMargin: const EdgeInsets.only(bottom: 2.0),
                text: btnTexts[index],
                textStyle: AppStyle.mainTextSecondaryStyle.copyWith(
                  color: btnTextsColors?[index],
                  fontWeight: AppFontWeight.regular.fontWeight,
                  fontSize: 16.0,
                ),
                icon: btnIcons?[index] != null
                    ? Padding(
                        padding: iconPadding,
                        child: DrawIconBasedTypeWidget(icon: btnIcons![index]!, iconSize: iconSize),
                      )
                    : const SizedBox(),
                iconAlignment: AlignmentDirectional.centerStart,
              ),
          // Close-Button widget
          CustomElevatedButtonWidget(
            onPressed: onClose ?? context.popRoute,
            btnColor: AppColor.gray,
            btnBorderColor: AppColor.white,
            btnRadius: 12.0,
            btnBorderWidth: 1.5,
            text: closeBtnText ?? "popUpCancelBottomSheetButton".tr(),
          ),
        ].addPadding(bottom: 12.0),
      ),
    );
  }

  bool get isActionsEqualsTexts => btnOnActions.length != btnTexts.length;
  bool get isIconsNotNullAndEqualsLength => btnIcons != null && btnIcons?.length != btnOnActions.length;
  bool get isTextsColorsNotNullAndEqualsLength =>
      btnTextsColors != null && btnTextsColors?.length != btnOnActions.length;

  int get length => btnTexts.length;

  EdgeInsetsGeometry get btnPadding => const EdgeInsetsDirectional.only(start: UIHelper.mediumPadding * 2.5);
  EdgeInsetsGeometry get iconPadding => const EdgeInsetsDirectional.only(start: UIHelper.mediumPadding);
}
