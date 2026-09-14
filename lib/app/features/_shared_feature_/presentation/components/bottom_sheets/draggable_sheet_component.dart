import 'package:flutter/material.dart';

import '../../../../../core/services/services_exports.dart' show NavigationService;
import '../../../../../core/utils/utils_exports.dart' show AppColor, AppStyle, ContextConversion, UIHelper;
import '../../../../home_page/home_exports.dart' show CircleIcon;
import '../../../shared_feature_exports.dart' show CustomTextWidget, DrawLineWidget, GlowingScrollWidget;

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
              const DrawLineWidget(
                lineWidth: 70.0,
                lineHeight: 6.0,
                lineColor: AppColor.blackModern200Light,
                radius: 46.0,
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: CustomTextWidget(
                      title,
                      maxLines: 10,
                      textAlign: TextAlign.start,
                      textStyle: AppStyle.createComplianceRiyadhTitle,
                    ),
                  ),
                  InkWell(
                    onTap: context.popDialog,
                    child: CircleIcon(
                      icon: Icons.close,
                      iconColor: AppColor.primary600Light,
                      backgroundColor: AppColor.geyser.withValues(alpha: 0.4),
                      iconSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              // Body
              Expanded(
                child: GlowingScrollWidget(
                  child: SingleChildScrollView(
                    physics: physics,
                    padding: EdgeInsets.zero,
                    controller: controller,
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: body,
                  ),
                ),
              ),
            ],
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
