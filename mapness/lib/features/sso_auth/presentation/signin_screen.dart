import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/ui/balady_logo/balady_logo.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

@RoutePage()
class SigninPage extends ConsumerWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        backgroundColor: const Color.fromRGBO(48, 205, 194, 1),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: Spacing.$10x,
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.$4x,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacing.$10x.widthBox,
                      const BaladyLogo(),
                      _buildcloseButton(context, ref),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.signInToUnlock,
                      textAlign: TextAlign.center,
                      style: context.textStyleV3.bodyLargeRegular.copyWith(color: AppColor.authSubtitleColorV2),
                    ),
                    Spacing.$4x.heightBox,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints.expand(height: Spacing.$12x),
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
                            await context.router.maybePop();
                          },
                          label: context.l10n.signIn,
                          textColor: AppColor.authSubtitleColorV2,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      );

  Widget _buildcloseButton(BuildContext context, WidgetRef ref) => Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(RadiusBorder.xl),
        child: InkWell(
          borderRadius: BorderRadius.circular(RadiusBorder.xl),
          onTap: () {
            Metrics.logEventAdvanced(
              MetricsConstants.loginKeys.close,
              group: MetricsConstants.loginTag,
              action: MetricAction.tap.toString(),
            );

            context.router.maybePop();
          },
          child: Container(
            height: Spacing.$10x,
            width: Spacing.$10x,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(RadiusBorder.m),
              color: context.color.textAndIconsBasePrimary.withOpacity(0.05),
            ),
            padding: const EdgeInsets.all(Spacing.$2x),
            child: SvgPicture.asset(
              'assets/icons/svg/ic_search_close.svg',
              semanticsLabel: 'MinApps Screen',
              package: PackageConfig.packageName,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      );
}
