import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/profile/personal_data.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ProfileInfoPage extends ConsumerWidget {
  const ProfileInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(authProvider).value;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.read<ThemeController>().systemOverlayStyle,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Material(
          color: context.colors.backgroundSurface4,
          child: Padding(
            padding: const EdgeInsets.only(top: Spacing.$4x),
            child: Scaffold(
              appBar: BaladyTopBar(
                systemUiOverlayStyle: context.read<ThemeController>().systemOverlayStyle,
                title: context.l10n.profileInfo,
                onLeadingPressed: () => context.router.pop(),
                leading: Semantics(
                  label: context.l10n.a11yBack,
                  button: true,
                  child: ExcludeSemantics(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: Spacing.$4x),
                        Icon(
                          SystemIcons.arrowCornerLeftLarge,
                          color: context.colors.accentDefault,
                        ),
                        const SizedBox(width: Spacing.$4x),
                      ],
                    ),
                  ),
                ),
              ),
              body: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [if (userData != null) PersonalData(userInfo: userData)]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
