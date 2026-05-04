import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/profile/log_out_sheet.dart';

@RoutePage()
class ProfileLogoutSheetPage extends StatelessWidget {
  const ProfileLogoutSheetPage({super.key});

  @override
  Widget build(BuildContext context) => LogoutSheet(
    title: context.l10n.signOut,
    description: context.l10n.signOutDescription,
    buttonText: context.l10n.signOutSwipe,
    onLogout: () => context.router.pop(true),
  );
}
