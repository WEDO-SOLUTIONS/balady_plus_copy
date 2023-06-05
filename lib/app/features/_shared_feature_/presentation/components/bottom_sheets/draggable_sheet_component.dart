import 'package:flutter/material.dart';

import '../../../../../core/services/services_exports.dart'
    show NavigationService;
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, ContextConversion, UIHelper, WidgetConversion;
import '../../../shared_feature_exports.dart'
    show CustomTextWidget, DrawLineWidget, GlowingScrollWidget;

class DraggableSheetComponent extends StatelessWidget {
  final ScrollPhysics? physics;
  final double? height;
  final String title;
  final AlignmentGeometry titleAlignment;
  final Widget body;
  final Widget? bottomNavigationBar;
  const DraggableSheetComponent({
    super.key,
    this.physics,
    this.height,
    required this.title,
    this.titleAlignment = AlignmentDirectional.centerStart,
    required this.body,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: height ?? 0.6,
      minChildSize: height ?? 0.6,
      maxChildSize: 0.94,
      expand: false,
      builder: (_, controller) => Scaffold(
        body: Padding(
          padding: padding,
          child: Column(
            children: [
              // Line widget
              const DrawLineWidget(
                lineWidth: 70.0,
                lineHeight: 6.0,
                lineColor: AppColor.gray,
                radius: 46.0,
              ),
              // Title widget
              Container(
                width: double.infinity,
                alignment: titleAlignment,
                child: CustomTextWidget(
                  title,
                  textAlign: TextAlign.center,
                  textStyle: AppStyle.mainTextSecondaryStyle.copyWith(
                    fontSize: 24.0,
                    color: AppColor.black,
                  ),
                ),
              ),
              // Body
              Expanded(
                child: GlowingScrollWidget(
                  child: SingleChildScrollView(
                    physics: physics,
                    padding: EdgeInsets.zero,
                    controller: controller,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: body,
                  ),
                ),
              ),
            ].addPadding(bottom: 24.0),
          ),
        ),
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }

  EdgeInsetsGeometry get padding => EdgeInsets.only(
        right: UIHelper.mediumPadding,
        left: UIHelper.mediumPadding,
        top: UIHelper.smallPadding,
        bottom: context.bottomPadding,
      );
  BuildContext get context => NavigationService.navigatorKey.currentContext!;
}
