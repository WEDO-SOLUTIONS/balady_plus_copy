import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, CommonProperties, IconPath, WeathherConditions;
import '../../../../home_page/home_exports.dart';
import '../../../shared_feature_exports.dart'
    show CustomTextFieldWidget, DrawIconBasedTypeWidget, DrawLineWidget, GlowingScrollWidget;

class DraggableSheetCard extends StatefulWidget {
  final double minSize;
  final double maxSize;
  final double? cornerRadius;
  final List<Widget> children;

  const DraggableSheetCard({
    super.key,
    required this.minSize,
    required this.maxSize,
    this.cornerRadius,
    required this.children,
  });

  @override
  State<DraggableSheetCard> createState() => _DraggableSheetCardState();
}

class _DraggableSheetCardState extends State<DraggableSheetCard> {
  final draggableScrollableController = DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.cornerRadius ?? 36),
            topRight: Radius.circular(widget.cornerRadius ?? 36),
          ),
          color: AppColor.white,
          boxShadow: [
            BoxShadow(
              color: AppColor.blackModern900Light.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.cornerRadius ?? 36),
            topRight: Radius.circular(widget.cornerRadius ?? 36),
          ),
          child: DraggableScrollableSheet(
            controller: draggableScrollableController,
            initialChildSize: widget.minSize,
            minChildSize: widget.minSize,
            maxChildSize: widget.maxSize,
            expand: false,
            builder: (_, controller) => InkWell(
              onTap: () {
                if (draggableScrollableController.size <= widget.minSize) {
                  draggableScrollableController.animateTo(
                    widget.maxSize,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutBack,
                  );
                } else {
                  draggableScrollableController.animateTo(
                    widget.minSize,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutBack,
                  );
                  controller.jumpTo(0);
                }
              },
              child: GlowingScrollWidget(
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.zero,
                  controller: controller,
                  child: Column(
                    children: widget.children,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    draggableScrollableController.dispose();
    super.dispose();
  }
}

