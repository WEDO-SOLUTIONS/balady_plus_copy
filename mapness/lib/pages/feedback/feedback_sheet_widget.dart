import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';
import 'package:sheetify/sheetify.dart';

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

class FeedbackSheetWidget extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final confettiController = useAnimationController();
    final sheetController = useToggleSheetController(
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

    useEffect(() {
      if (state == FeedbackSheetState.success) {
        confettiController
            .animateTo(
          1,
          duration: config.animationDuration,
          curve: config.animationCurve,
        )
            .whenCompleteOrCancel(() {
          if (context.mounted) {
            confettiController.reset();
          }
        });
      }
      return null;
    }, [state]);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            ToggleSheet(
              scrollController: sheetController,
              backgroundColor: context.colors.backgroundSurface1,
              safeAreaColor: context.colors.backgroundSurface1,
              dragger: const SheetDragger(),
              header: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: Spacing.$4x),
                  child: AppButton.close(onTap: () {
                    sheetController.close();
                  }),
                ),
              ),
              content: [
                AnimatedSwitcher(
                  duration: switchDuration,
                  child: switch (state) {
                    FeedbackSheetState.failure => BaseErrorWidget(
                        onRetry: onRetry,
                        errorLabel: context.l10n.appFeedbackConnectionIssueV2,
                        paddingForImage: const EdgeInsets.symmetric(vertical: AppSizes.$3xs),
                      ),
                    FeedbackSheetState.success => Column(
                        key: const Key('feedback_success'),
                        children: [
                          Center(
                            child: SizedBox(
                              width: 180.0,
                              child: SvgPicture.asset(
                                ref.watch(activeCityEventProvider)?.illustrationNotifications ??
                                    Assets.imagesSvg.illustrationNotifications.keyName,
                                matchTextDirection: true,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSizes.$4xs),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxs + Spacing.$4x),
                              child: Text(
                                context.l10n.feedbackSuccessTitle,
                                style: context.textStyles.h3SemiBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSizes.$4xs),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: Spacing.$3x),
                            child: SizedBox(
                              width: double.infinity,
                              child: AppButton(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.$4x,
                                  vertical: Spacing.$4x,
                                ),
                                buttonColorScheme: ButtonColorScheme.accent,
                                primaryLabel: context.l10n.done,
                                onTap: sheetController.close,
                              ),
                            ),
                          ),
                        ],
                      ),
                    FeedbackSheetState.loading => Column(
                        key: const Key('feedback_loading'),
                        children: [
                          const SizedBox(height: AppSizes.$4xs),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final textPainter = TextPainter(
                                  text: TextSpan(
                                    text: context.l10n.feedbackSuccessTitle,
                                    style: context.textStyles.h3SemiBold,
                                  ),
                                  textDirection: Directionality.of(context))
                                ..layout(maxWidth: constraints.maxWidth - AppSizes.xxs * 2);
                              final height = textPainter.height;
                              return SizedBox(height: height);
                            },
                          ),
                          const Center(
                            child: SizedBox(
                                width: 139,
                                height: 139,
                                child: Center(
                                  child: Loading(
                                    size: LoaderSize.large,
                                  ),
                                )),
                          ),
                          const SizedBox(height: AppSizes.$4xs),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: Spacing.$3x + Spacing.$4x,
                            ),
                            child: SizedBox(
                              height: ButtonSize.medium.height,
                              width: double.infinity,
                            ),
                          ),
                        ],
                      ),
                  },
                ),
              ],
            ),
            RepaintBoundary(child: ConfettiAnimation(animationController: confettiController, config: config)),
          ],
        ),
      ),
    );
  }
}
