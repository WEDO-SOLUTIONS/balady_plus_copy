import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart' show Translation;

import '../../../../../core/services/services_exports.dart' show NavigationService;
import '../../../../../core/utils/utils_exports.dart' show AppColor, ContextConversion, WidgetConversion;
import '../../../shared_feature_exports.dart' show CustomElevatedButtonWidget, DraggableSheetComponent;

class CloseRequestBottomSheetComponent extends StatelessWidget {
  const CloseRequestBottomSheetComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableSheetComponent(
      physics: const NeverScrollableScrollPhysics(),
      height: 0.3,
      title: "popUpCloseRequest".tr(),
      body: Column(
        children: [
          for (int index = 0; index < length; index++)
            CustomElevatedButtonWidget(
              onPressed: callbacks[index],
              btnColor: colors[index],
              btnRadius: 12.0,
              text: texts[index].tr(),
            ),
        ].addPadding(bottom: 12.0),
      ),
    );
  }

  int get length => texts.length;
  List<String> get texts => ["closeButton", "cancelButton"];
  List<Color?> get colors => [AppColor.error, null];
  List<VoidCallback> get callbacks => [
    () {
      // Close dialog
      context.popDialog();
      // Close page
      context.popRoute();
    },
    () => context.popDialog(),
  ];

  BuildContext get context => NavigationService.navigatorKey.currentContext!;
}
