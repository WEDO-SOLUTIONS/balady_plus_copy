import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/feedback/feedback_balady_business.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class FeedbackBaladyBusiness extends ConsumerWidget {
  const FeedbackBaladyBusiness({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(feedbackBaladyBusinessProvider);

    return Column(
      children: [
        const SizedBox(height: Spacing.$4x),
        Text(
          context.l10n.addMoreFeaturesToYourBusiness,
          style: context.textStyleV3.bodyLargeSemiBold.copyWith(
            color: context.colorsV3.accentSecondaryOnContainer,
          ),
        ),
        const SizedBox(height: Spacing.$4x),
        SizedBox(
          width: double.infinity,
          child: BaladyAppButton(
            primaryLabel: context.l10n.signInToBaladyBusiness,
            buttonColorScheme: BaladyButtonColorScheme.accentSecondary,
            buttonType: BaladyButtonType.secondary,
            onTap: ref.read(feedbackBaladyBusinessProvider.notifier).openBaladyBusiness,
          ),
        ),
        const SizedBox(height: Spacing.$2x),
      ],
    );
  }
}
