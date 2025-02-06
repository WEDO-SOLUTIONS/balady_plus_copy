import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class AddPlaceItem extends StatelessWidget {
  const AddPlaceItem({Key? key}) : super(key: key);

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.l10n.searchDidntFind,
          style: context.textStyleV3.bodyLargeSemiBold,
        ),
        const SizedBox(height: Spacing.$1x),
        Text(
          context.l10n.searchAddAnObjectOrCompanyToTheMap,
          style: context.textStyleV3.bodySmallRegular,
        ),
        const SizedBox(height: Spacing.$3x),
        uikit.AppButton(
          buttonColorScheme: uikit.ButtonColorScheme.secondary,
          primaryIcon: uikit.GeneralIcons.plusCircle,
          // for the first iteration all buttons have same label. Will be changed later
          primaryLabel: context.l10n.searchAddCompany,
          onTap: () {
            // TODO(Demezy): add company route push when ready
          },
        ),
      ],
    );
  }
}
