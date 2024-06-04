import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/profile/personal_data.dart';

class ProfileInfoPage extends ConsumerWidget {
  const ProfileInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(authProvider).valueOrNull;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Directionality(
          textDirection: Directionality.of(context),
          child: Material(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: Spacing.verticalBaseToTopModal),
              child: Scaffold(
                appBar: BaladyTopBar.iconAndText(
                  title: context.l10n.profileInfo,
                  colorEnabled: context.color.textAndIconsStatusAccent,
                  leading: ActionModel(
                    text: context.l10n.back,
                    onPressed: () => context.pop(),
                    icon: context.isLTR ? SystemIcons.arrowCornerRightSmall : SystemIcons.arrowCornerLeftSmall,
                  ),
                ),
                body: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          if (userData != null) PersonalData(userInfo: userData),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
