import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/widgets/smooth_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';
import 'package:sliver_tools/sliver_tools.dart';

enum FeedbackSheetState {
  success,
  failure,
  loading,
}

const switchDuration = Durations.extralong4;

final confettiShapes = [
  (startPosition, velocity, scale, gradient, x, y, z) =>
      DiamondShape(startPosition, velocity, scale, gradient, x, y, z),
  (startPosition, velocity, scale, gradient, x, y, z) =>
      TrapezoidShape(startPosition, velocity, scale, gradient, x, y, z),
  (startPosition, velocity, scale, gradient, x, y, z) =>
      FlagRectangularShape(startPosition, velocity, scale, gradient, x, y, z),
  (startPosition, velocity, scale, gradient, x, y, z) =>
      SmoothParallelogramShape(startPosition, velocity, scale, gradient, x, y, z),
  (startPosition, velocity, scale, gradient, x, y, z) => ArcShape(startPosition, velocity, scale, gradient, x, y, z),
];

class FeedbackSheetWidget extends HookWidget {
  final FeedbackSheetState state;
  final VoidCallback onRetry;

  const FeedbackSheetWidget({
    required this.onRetry,
    required this.state,
    super.key,
  });

  void popNavigation(BuildContext context, AnimationController confettiController) => context.router.popUntil((route) =>
      route.settings.name == PoiCardWidgetRoute.name ||
      route.settings.name == SearchRoute.name ||
      route.settings.name == BottomMenuRoute.name);

  @override
  Widget build(BuildContext context) {
    final confettiController = useAnimationController();
    final sheetController = useStatelessBottomsheetController(
      onClose: (_) => popNavigation(context, confettiController),
    );

    final config = useMemoized(
      () => ConfettiGeneratorConfig.confetti(
        animationDuration: const Duration(seconds: 3),
        commonShapeAppearance: 0,
        velocityMinY: -1.0,
        velocityMaxY: 0.4,
        confettiShapes: confettiShapes,
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            RepaintBoundary(child: ConfettiAnimation(animationController: confettiController, config: config)),
            SafeArea(
              child: StatelessBottomSheet(
                backgroundColor: context.colorsV2.backgroundSurface1,
                scrollController: sheetController,
                header: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: Spacing.$4x),
                    child: AppButton(
                        buttonColorScheme: ButtonColorScheme.tertiary,
                        primaryIcon: SystemIcons.close,
                        onTap: () {
                          sheetController.close();
                        }),
                  ),
                ),
                sliverBeforeContent: SliverAnimatedSwitcher(
                  duration: Durations.medium4,
                  child: state == FeedbackSheetState.failure
                      ? SliverToBoxAdapter(
                          child: BaseErrorWidget(
                            onRetry: onRetry,
                            buttonColorScheme: ButtonColorScheme.primary,
                            errorLabel: context.l10n.appFeedbackConnectionIssueV2,
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              SizedBox(
                                width: 200,
                                height: 116,
                                child: FeedbackConfirmationIndicator(
                                  isLoading: state == FeedbackSheetState.loading,
                                  color: context.color.textAndIconsStatusAccent,
                                  onComplete: () {
                                    if (state == FeedbackSheetState.success) {
                                      confettiController
                                          .animateTo(
                                        1,
                                        duration: config.animationDuration,
                                        curve: config.animationCurve,
                                      )
                                          .whenCompleteOrCancel(() {
                                        confettiController.value = 0;
                                      });
                                    }
                                  },
                                ),
                              ),
                              _FeedbackTitle(state: state),
                              const SizedBox(height: AppSizes.$4xs),
                              _FeedbackButton(
                                state: state,
                                onTap: sheetController.close,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackTitle extends StatelessWidget {
  final FeedbackSheetState state;

  const _FeedbackTitle({required this.state});

  @override
  Widget build(BuildContext context) => AnimatedCrossFade(
        duration: switchDuration,
        crossFadeState: state == FeedbackSheetState.success ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        firstChild: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxs),
            child: Text(
              context.l10n.feedbackSuccessTitle,
              style: context.textStyleV3.h3SemiBold,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        secondChild: LayoutBuilder(
          builder: (context, constraints) {
            final textPainter = TextPainter(
                text: TextSpan(
                  text: context.l10n.feedbackSuccessTitle,
                  style: context.textStyleV3.h3SemiBold,
                ),
                textDirection: Directionality.of(context))
              ..layout(maxWidth: constraints.maxWidth - AppSizes.xxs * 2);
            final height = textPainter.height;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxs),
              child: ShimmerEffectWidget(height: height),
            );
          },
        ),
      );
}

class _FeedbackButton extends StatelessWidget {
  final FeedbackSheetState state;
  final VoidCallback onTap;

  const _FeedbackButton({required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) => AnimatedCrossFade(
        duration: switchDuration,
        crossFadeState: state == FeedbackSheetState.success ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        firstChild: Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.$3x),
          child: SizedBox(
            width: double.infinity,
            child: AppButton(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.$4x,
                vertical: Spacing.$4x,
              ),
              buttonColorScheme: ButtonColorScheme.primary,
              primaryLabel: context.l10n.complete,
              onTap: onTap,
            ),
          ),
        ),
        secondChild: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.$4x,
            vertical: Spacing.$3x + Spacing.$4x,
          ),
          child: ClipPath(
            clipper: ShapeBorderClipper(shape: smoothBorder(ButtonSize.medium.radius)),
            child: ShimmerEffectWidget(
              height: ButtonSize.medium.height,
              width: double.infinity,
            ),
          ),
        ),
      );
}
