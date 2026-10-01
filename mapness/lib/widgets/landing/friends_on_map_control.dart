import 'package:balady_uikit/balady_uikit.dart' hide MapButton;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

/// R-47: map-corner entry into Friends on Map. Opens the same
/// [FriendsOnMapRoute] as Profile → Friends on Map — that page already
/// switches on activation status, so a not-yet-activated user lands on the
/// disclosure flow from here too.
class FriendsOnMapControl extends ConsumerWidget {
  const FriendsOnMapControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MapButton(
    semanticsLabel: context.l10n.friendsOnMapTitle,
    onTap: () => ref.read(appRouterProvider).push(const FriendsOnMapRoute()),
    child: Icon(GeneralIcons.user, size: 24, color: context.colors.accentDefault),
  );
}
