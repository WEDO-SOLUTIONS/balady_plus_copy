import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class LoadingThanksSheet extends StatelessWidget {
  final VoidCallback onComplete;
  final VoidCallback onClose;
  final bool isLoading;
  final bool showValuableOpinionMessage;
  final bool triggerOnComplete;

  const LoadingThanksSheet({
    required this.isLoading,
    required this.onComplete,
    required this.onClose,
    this.showValuableOpinionMessage = false,
    this.triggerOnComplete = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Material(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40, top: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 104,
                    child: FeedbackConfirmationIndicator(
                        isLoading: isLoading,
                        color: context.color.textAndIconsStatusAccent,
                        onComplete: () {
                          if (triggerOnComplete) {
                            onComplete();
                          }
                          if (!showValuableOpinionMessage) {
                            Future.delayed(const Duration(seconds: 3), onClose);
                          }
                        }),
                  ),
                  Text(
                    context.l10n.thanksForYourFeedback,
                    textAlign: TextAlign.center,
                    style: context.textStyle.heading1.copyWith(color: context.color.textAndIconsBasePrimary),
                  ),
                  if (showValuableOpinionMessage) ...[
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.yourOpinionIsVeryValuable,
                      textAlign: TextAlign.center,
                      style: context.textStyle.text.copyWith(color: context.color.textAndIconsBasePrimary),
                    ),
                    const SizedBox(height: 20),
                    AppButton(
                      buttonColorScheme: ButtonColorScheme.accent,
                      onTap: onClose,
                      primaryLabel: context.l10n.complete,
                      buttonState: isLoading ? ButtonState.disabled : ButtonState.normal,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      );
}
