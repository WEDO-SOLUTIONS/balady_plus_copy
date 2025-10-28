import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/path_card_wrapper.dart';

/// This widget is used to show a failure message in the path card
/// It will show a message and a button to refresh the path
class PathCardFailure extends StatelessWidget {
  final VoidCallback refresh;
  final String text;
  final String? labelButton;

  const PathCardFailure.noInternet({
    required this.refresh,
    required this.text,
    this.labelButton,
    super.key,
  });

  const PathCardFailure.routeNotFound({
    required this.refresh,
    required this.text,
    this.labelButton,
    super.key,
  });

  const PathCardFailure.nearestMetroTooFar({
    required this.refresh,
    required this.text,
    this.labelButton,
    super.key,
  });

  const PathCardFailure.walkingDistance({
    required this.refresh,
    required this.text,
    this.labelButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: PathCardWrapper(
          child: Column(
            children: [
              Text(
                text,
                style: context.textStyles.bodySmallMedium,
                textAlign: TextAlign.center,
              ),
              Spacing.$3x.heightBox,
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  buttonColorScheme: ButtonColorScheme.accentSecondary,
                  buttonType: ButtonType.secondary,
                  onTap: refresh,
                  primaryLabel: labelButton ?? AppLocalizations.of(context).reload,
                ),
              ),
            ],
          ),
        ),
      );
}
