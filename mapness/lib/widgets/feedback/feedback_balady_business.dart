import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/feedback/feedback_balady_business.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class FeedbackBaladyBusiness extends ConsumerWidget {
  const FeedbackBaladyBusiness({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(feedbackBaladyBusinessProvider);

    return Padding(
      padding: const EdgeInsets.only(top: Spacing.$4x),
      child: Material(
        color: context.colors.backgroundSurface1,
        borderRadius: BorderRadius.circular(RadiusBorder.xl),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.$4x),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.signInToBaladyBusiness,
                style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
              ),
              Spacing.$1x.heightBox,
              Text(
                context.l10n.addMoreFeaturesToYourBusiness,
                style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
              ),
              const SizedBox(height: Spacing.$3x),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  primaryLabel: context.l10n.signIn,
                  buttonColorScheme: ButtonColorScheme.accent,
                  buttonType: ButtonType.secondary,
                  onTap: ref.read(feedbackBaladyBusinessProvider.notifier).openBaladyBusiness,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
