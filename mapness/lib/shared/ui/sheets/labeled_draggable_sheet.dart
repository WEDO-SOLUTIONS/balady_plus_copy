import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';

class LabeledDraggableSheet extends StatelessWidget {
  const LabeledDraggableSheet({
    required this.onClose,
    required this.title,
    required this.child,
    super.key,
  });
  final VoidCallback onClose;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 26,
                height: 3,
                decoration: ShapeDecoration(
                  color: NonThemeColor.color52,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(23),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      softWrap: true,
                      style: context.textStyle.heading1.copyWith(
                        color: context.colors.foregroundDefault,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AppCloseButton(onPressed: onClose),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(child: child),
            ],
          ),
        ),
      );
}
