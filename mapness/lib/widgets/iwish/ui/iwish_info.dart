import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';

import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/widgets/iwish/ui/iwish_state_label.dart';

class IwishInfo extends StatelessWidget {
  final IwishEntity iwish;
  final String distance;
  final VoidCallback onClose;

  const IwishInfo({
    super.key,
    required this.iwish,
    required this.distance,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    const black = Color(0xff1d2a36);
    const grey = Color(0x7F1E2A36);

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
                  Row(
                    children: [
                      IwishStateLabel(state: iwish.state),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          iwish.title,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()!
                              .headingS
                              .copyWith(color: black),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'JOY Park',
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .textS
                        .copyWith(color: grey),
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
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .textS
                    .copyWith(color: black),
              ),
            ),
            const SizedBox(width: 12),
            // Text(
            //   distance,
            //   overflow: TextOverflow.ellipsis,
            //   style: Theme.of(context).extension<ThemeTextStyles>()!.textS.copyWith(color: grey),
            // ),
          ],
        ),
      ],
    );
  }
}
