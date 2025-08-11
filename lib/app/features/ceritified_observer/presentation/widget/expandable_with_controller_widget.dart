import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ExpandableWithControllerWidget extends StatelessWidget {
  final String title;

  /// The widget to show when expanded
  final Widget expanded;

  /// If the controller is not specified, it will be retrieved from the context
  final ExpandableController controller;

  const ExpandableWithControllerWidget({
    super.key,
    required this.title,
    required this.expanded,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    Widget collapsed = Row(
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: CustomTextWidget(
            title,
            textStyle: AppStyle.cardTitleTextStle,
            maxLines: 2,
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: AppColor.primary300Light,
            shape: BoxShape.circle,
          ),
          child: ValueListenableBuilder(
            valueListenable: controller,
            builder: (BuildContext context, bool value, Widget? child) {
              return Icon(
                value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: AppColor.white,
              );
            },
          ),
        ),
      ],
    );
    return InkWell(
      onTap: () {
        controller.toggle();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AppColor.white,
        ),
        child: ExpandablePanel(
          controller: controller,
          collapsed: collapsed,
          expanded: Column(
            children: [
              collapsed,
              expanded,
            ],
          ),
        ),
      ),
    );
  }
}
