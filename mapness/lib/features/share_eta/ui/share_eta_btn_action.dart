import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_share_control_sheet.dart';

enum ShareEtaBtnActionType { loading, active, stoped }

class ShareEtaBtnAction extends StatelessWidget {
  final ShareEtaBtnActionType type;
  const ShareEtaBtnAction({required this.type, super.key});

  void _showEtaControlSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => const EtaShareControlSheet(),
    );
  }

  @override
  Widget build(BuildContext context) => switch (type) {
        ShareEtaBtnActionType.loading => Loading.small(),
        ShareEtaBtnActionType.active => GestureDetector(
            onTap: () => _showEtaControlSheet(context),
            child: SystemIcons.ellipsis.icon(color: context.colors.foregroundSoft),
          ),
        ShareEtaBtnActionType.stoped => Icon(
            SystemIcons.share,
            color: context.colors.foregroundMuted,
          ),
      };
}
