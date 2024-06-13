import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/happiness_map/happines_map_bottom_sheet.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';

class HappinesOverlayContent extends ConsumerStatefulWidget {
  const HappinesOverlayContent({required this.isBottomSheetOpened, super.key});

  /// does bottom sheet opened or not initially. Does not affect on bottom sheet state afterwards
  final bool isBottomSheetOpened;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HapinessOverlayContentState();
}

class _HapinessOverlayContentState extends ConsumerState<HappinesOverlayContent> with TickerProviderStateMixin {
  final ValueNotifier<double> height = ValueNotifier(100);

  late final AnimationController confettiController;

  final ConfettiGeneratorConfig config = ConfettiGeneratorConfig.confetti();

  void playConfettiAnimation() =>
      confettiController.animateTo(1, duration: config.animationDuration, curve: config.animationCurve);

  @override
  void initState() {
    super.initState();
    confettiController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    height.dispose();
    confettiController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    ref.read(cameraPaddingProvider.notifier).resetPadding();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final cameraPaddingController = ref.watch(cameraPaddingProvider.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.biggest.height;
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  context.pop();
                },
              ),
            ),
            ValueListenableBuilder(
              valueListenable: height,
              builder: (context, height, child) => Positioned.fill(
                bottom: height,
                child: child!,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: SvgPicture.asset(
                    'assets/icons/svg/ic_pin.svg',
                    height: 48,
                    width: 38,
                    package: PackageConfig.packageName,
                  ),
                ),
              ),
            ),
            ConfettiAnimation(
              animationController: confettiController,
              config: ConfettiGeneratorConfig.confetti(),
            ),
            HappinessBottomSheet(
              isOpenedInitially: widget.isBottomSheetOpened,
              onHeightChange: (height) {
                final pixelSize = MediaQuery.of(context).devicePixelRatio;
                final navbarSize = 48 + MediaQuery.of(context).viewPadding.bottom;

                cameraPaddingController.setPadding(
                  CameraSetPaddingMessage(
                    leftPadding: 0,
                    topPadding: 0,
                    rightPadding: 0,
                    bottomPadding: (height * maxHeight * pixelSize - navbarSize * pixelSize).floor(),
                  ),
                );
                Future.delayed(
                  Duration.zero,
                  () => this.height.value = height * maxHeight,
                );
              },
              biggestHeight: maxHeight,
              onClose: () {
                // ref
                //     .read(mapControlsProvider.notifier)
                //     .update(MapControlsStateIdle());
                // widget.onClose();
                context.pop();
              },
              onFeedbackSent: () {},
            ),
          ],
        );
      },
    );
  }
}
