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

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.$4x,
      ).copyWith(
        top: userData.hasValue ? 0 : Spacing.$6x,
        bottom: userData.hasValue ? Spacing.$4x : Spacing.$8x,
      ),
      child: userData.maybeWhen(
        orElse: () => UnauthorizedProfile(
          onConnect: ref.read(authProvider.notifier).doAuth,
        ),
        data: (userData) => userData != null
            ? AuthorizedWidget(userData: userData)
            : UnauthorizedProfile(
                onConnect: ref.read(authProvider.notifier).doAuth,
              ),
      ),
    );
  }
}
