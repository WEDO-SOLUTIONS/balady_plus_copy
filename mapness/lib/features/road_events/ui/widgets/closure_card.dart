import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';

class ClosureCard extends StatelessWidget {
  final String title;
  final String description;

  final String? workDuration;

  const ClosureCard(
      {required this.title,
      required this.description,
      super.key,
      this.workDuration});

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.color.surface_base_primary,
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
                            style: Theme.of(context)
                                .extension<ThemeTextStyles>()!
                                .headingS
                                .copyWith(
                                  color: context.color.text_and_icons_base_primary,
                                ),
                          ),
                          Text(
                            description,
                            style: Theme.of(context)
                                .extension<ThemeTextStyles>()!
                                .textS
                                .copyWith(
                                  color:
                                      context.color.text_and_icons_base_primary.withOpacity(0.64),
                                ),
                          ),
                        ],
                      ),
                    ),
                    CustomCloseButton(
                      onClose: () => context.pop(),
                    ),
                  ],
                ),
                if (workDuration != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      workDuration!,
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()!
                          .textXS
                          .copyWith(
                            color: context.color.text_and_icons_base_primary.withOpacity(0.64),
                          ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
