import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/widgets/profile/authorized_widget.dart';
import 'package:mapness/widgets/profile/unathorized_profile.dart';

class ProfileHeader extends HookConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(authProvider);
    final onConnect = ref.read(authProvider.notifier).doAuth;

    final topPadding = userData.value != null ? 0.0 : Spacing.$6x;
    final bottomPadding = userData.value != null ? Spacing.$4x : Spacing.$8x;
    return Padding(
      padding: EdgeInsets.only(
        left: Spacing.$4x,
        right: Spacing.$4x,
        top: topPadding,
        bottom: bottomPadding,
      ),
      child: userData.maybeWhen(
        orElse: () => UnauthorizedProfile(onConnect: onConnect),
        data: (userData) {
          if (userData == null) {
            return UnauthorizedProfile(onConnect: onConnect);
          }
          return AuthorizedWidget(userData: userData);
        },
      ),
    );
  }
}
