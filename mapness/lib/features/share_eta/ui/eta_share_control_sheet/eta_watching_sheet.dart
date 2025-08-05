import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_share_sheet.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class EtaWatchingSheet extends StatelessWidget {
  final VoidCallback onStopWatchingPressed;

  const EtaWatchingSheet({required this.onStopWatchingPressed, super.key});

  @override
  Widget build(BuildContext context) => EtaShareSheet(
        title: context.l10n.sharingIsLive,
        contentBuilder: (context) => [
          ContentRow(
            onTap: onStopWatchingPressed,
            options: ContentRowOptions(
              title: context.l10n.stopWatching,
              titleStyle: context.textStyles.bodyLargeRegular.copyWith(
                color: context.colors.foregroundDefault,
              ),
              leadingIcon: Icon(
                GeneralIcons.clearCircle,
                color: context.colors.foregroundSoft,
              ),
            ),
          )
        ],
      );
}
