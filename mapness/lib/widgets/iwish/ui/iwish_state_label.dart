import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';

import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class IwishStateLabel extends StatelessWidget {
  const IwishStateLabel({required this.state, super.key});
  final IwishState state;

  @override
  Widget build(BuildContext context) => Container(
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
          style: Theme.of(context).extension<ThemeTextStyles>()!.footNoteBold.copyWith(
                color: switch (state) {
                  IwishState.unknown => Colors.grey,
                  IwishState.planned => NonThemeColor.color20,
                  IwishState.completed => NonThemeColor.color3,
                },
              ),
        ),
      );
}
