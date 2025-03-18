import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

import 'package:mapness/shared/ui/buttons/app_close_button.dart';

class ClosureCard extends StatelessWidget {
  const ClosureCard({
    required this.title,
    required this.description,
    super.key,
    this.workDuration,
  });

  final String title;
  final String description;

  final String? workDuration;

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textStyleV3;
    final color = context.colorsV3;

    return SafeArea(
      top: false,
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.backgroundSurface1,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: textStyle.h4SemiBold.copyWith(
                              color: color.foregroundDefault,
                            ),
                          ),
                          Text(
                            description,
                            style: textStyle.bodyLargeRegular.copyWith(
                              color: color.extra01Default.withOpacity(0.64),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomCloseButton(
                      onClose: () => context.router.popForced(),
                    ),
                  ],
                ),
                if (workDuration != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      workDuration!,
                      style: textStyle.bodySmallRegular.copyWith(
                        color: color.foregroundSoft.withOpacity(0.64),
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
}
