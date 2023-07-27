import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor;
import '../../../shared_feature_exports.dart'
    show DrawLineWidget, GlowingScrollWidget;

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
          color: AppColor.paleGrey,
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.topLeft,
            colors: [
              AppColor.secondary50Light,
              Color(0xffF5F8FA),
            ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.cornerRadius ?? 36),
            topRight: Radius.circular(widget.cornerRadius ?? 36),
          ),
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
            builder: (_, controller) => Column(
              children: [
                InkWell(
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
                  child: const DrawLineWidget(
                    lineWidth: 32,
                    lineHeight: 4,
                    lineColor: AppColor.white,
                    radius: 46.0,
                    verticalMargin: 8,
                  ),
                ),
                Expanded(
                  child: GlowingScrollWidget(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      controller: controller,
                      child: Column(
                        children: widget.children,
                      ),
                    ),
                  ),
                ),
              ],
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
