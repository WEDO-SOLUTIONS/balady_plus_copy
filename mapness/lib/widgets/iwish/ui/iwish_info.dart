import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';

class IwishInfo extends StatelessWidget {
  const IwishInfo({
    required this.iwish,
    required this.distance,
    required this.onClose,
    super.key,
  });
  final IwishEntity iwish;
  final String distance;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final black = context.colors.foregroundDefault;
    const grey = NonThemeColor.color38;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    iwish.title,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyle.heading1.copyWith(color: black),
                  ),
                  Text(
                    'JOY Park',
                    style: context.textStyle.footNote.copyWith(color: grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 3),
            AppCloseButton(onPressed: onClose),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                iwish.subtitle,
                style: context.textStyle.footNote.copyWith(color: black),
              ),
            ),
            const SizedBox(width: 12),
            // Text(
            //   distance,
            //   overflow: TextOverflow.ellipsis,
            //   style: context.textStyle!.footNote.copyWith(color: grey),
            // ),
          ],
        ),
      ],
    );
  }
}
