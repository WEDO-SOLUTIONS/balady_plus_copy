import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/invite_card.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// S-07 part (a): "share my own invite" — R-25 to R-28. Per BRD Appendix
/// E.2, link and QR share one entry screen; a scan section is added here in
/// a later slice rather than as a separate route — see
/// `friends_on_map/AGENTS.md`.
@RoutePage()
class AddFriendPage extends ConsumerWidget {
  const AddFriendPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Directionality(
    textDirection: ref.watch(uiDirectionProvider),
    child: Material(
      color: context.colors.backgroundSurface4,
      child: Scaffold(
        appBar: BaladyTopBar.iconAndText(
          title: context.l10n.addFriendTitle,
          colorEnabled: context.colors.accentDefault,
          leading: ActionModel(onPressed: () => context.router.pop(), icon: SystemIcons.arrowCornerLeftLarge),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.$4x),
            child: Column(
              children: [
                Text(
                  context.l10n.addFriendShareNote,
                  textAlign: TextAlign.center,
                  style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundMuted),
                ),
                const SizedBox(height: Spacing.$4x),
                const InviteCard(),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
