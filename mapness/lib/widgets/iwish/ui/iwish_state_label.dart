import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';

import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class IwishStateLabel extends StatelessWidget {
  final IwishState state;

  const IwishStateLabel({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        // color:
      ),
      child: Text(
        switch (state) {
          IwishState.unknown => context.l10n.unknown,
          IwishState.planned => context.l10n.planned,
          IwishState.completed => context.l10n.completed,
        },
        style: Theme.of(context).extension<ThemeTextStyles>()!.accentS.copyWith(
                color: switch (state) {
              IwishState.unknown => Colors.grey,
              IwishState.planned => const Color(0xFFFFB814),
              IwishState.completed => const Color(0xFF52B374),
            }),
      ),
    );
  }
}
