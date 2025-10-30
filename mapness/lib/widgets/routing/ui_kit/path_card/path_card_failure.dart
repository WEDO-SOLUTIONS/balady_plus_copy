import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

import 'package:mapness/widgets/routing/ui_kit/path_card/path_card_wrapper.dart';

/// This widget is used to show a failure message in the path card
/// It will show a message and a button to refresh the path
class PathCardFailure extends StatelessWidget {
  final VoidCallback refresh;
  final String text;
  const PathCardFailure({
    required this.refresh,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: PathCardWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                text,
                style: context.textStyle.footNote,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              AppButton(
                buttonColorScheme: ButtonColorScheme.accent,
                onTap: refresh,
                primaryLabel: AppLocalizations.of(context).reload,
              ),
            ],
          ),
        ),
      );
}
