import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';

class NaviFindInFav extends ConsumerWidget {
  const NaviFindInFav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ContentWrapper(
    color: context.colors.backgroundSurface1,
    children: [
      ContentRow(
        onTap: () => ref
            .read(authMethodsProvider.notifier)
            .authAndOpen(
              context,
              callback: () => context.router.push(const NaviFavoritesRoute()),
            ),
        leading: Icon(
          SystemIcons.bookmark,
          color: context.colors.accentDefault,
        ),
        trailing: ContentRowTextTrailingOptions(
          icon: SystemIcons.arrowCornerRightSmall,
          iconColor: context.colors.foregroundMuted,
        ),
        text: ContentRowTextOptions(title: context.l10n.findInFav),
      ),
    ],
  );
}
