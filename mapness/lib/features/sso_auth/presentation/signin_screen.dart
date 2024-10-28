import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class SigninScreen extends ConsumerWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        body: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      NonThemeColor.color12,
                      NonThemeColor.color13,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 55,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                'assets/images_svg/balady_logo.svg',
                height: 40,
                package: PackageConfig.packageName,
              ),
            ),
            Positioned(
              top: 55,
              right: 16,
              child: _buildcloseButton(context, ref),
            ),
            Positioned.fill(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.signInToUnlock,
                      textAlign: TextAlign.center,
                      style: context.textStyle.text.apply(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints.expand(height: 48),
                        child: LabeledElevatedButton(
                          onPressed: () async {
                            Metrics.logEventAdvanced(
                              MetricsConstants.loginKeys.signIn,
                              group: MetricsConstants.loginTag,
                              action: MetricAction.tap.toString(),
                            );

                            await ref.read(authProvider.notifier).doAuth();
                            if (!context.mounted) {
                              return;
                            }
                            context.pop();
                          },
                          label: context.l10n.signIn,
                          textColor: context.color.strokeAccent,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildcloseButton(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Metrics.logEventAdvanced(
                MetricsConstants.loginKeys.close,
                group: MetricsConstants.loginTag,
                action: MetricAction.tap.toString(),
              );

              context.pop();
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                color: context.color.textAndIconsBasePrimary.withOpacity(0.05),
              ),
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset('assets/icons/svg/ic_search_close.svg',
                  semanticsLabel: 'MinApps Screen',
                  package: PackageConfig.packageName,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  )),
            ),
          ),
        ),
      );
}
