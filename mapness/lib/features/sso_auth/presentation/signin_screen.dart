import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class SigninScreen extends ConsumerWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xff499959),
                    const Color(0xff07726D),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned(
            child: SvgPicture.asset(
              'assets/images_svg/balady_logo.svg',
              height: 40,
              package: 'mapness',
            ),
            top: 55,
            left: 0,
            right: 0,
          ),
          Positioned(
            child: _buildcloseButton(context, ref),
            top: 55,
            right: 16,
          ),
          Positioned.fill(
              child: Center(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(context.l10n.signInToUnlock,
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .textM
                      .apply(color: Colors.white)),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints.expand(height: 48),
                  child: LabeledElevatedButton(
                    onPressed: () async {
                      await ref.read(authProvider.notifier).doAuth();
                      if (!context.mounted) return;
                      context.pop();
                    },
                    label: context.l10n.signIn,
                    textColor: const Color(0xff4CA5B4),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ))),
        ],
      ),
    );
  }

  Widget _buildcloseButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.pop(),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              color: const Color(0xff1E2A36).withOpacity(0.05),
            ),
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              "assets/icons/svg/ic_search_close.svg",
              semanticsLabel: 'MinApps Screen',
              package: "mapness",
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
