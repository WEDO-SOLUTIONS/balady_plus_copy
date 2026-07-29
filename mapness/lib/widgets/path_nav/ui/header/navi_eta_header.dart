import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/core/widgets/dragger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/entities/path_nav/models/path_nav_eta.dart';
import 'package:mapness/entities/path_nav/models/path_nav_state.dart';
import 'package:mapness/features/path_nav/lib/extensions.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/features/share_eta/providers/eta_websocket_status_provider.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/features/share_eta/providers/websocket_type_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/parking_autoenabled_sheet_provider.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';
import 'package:mapness/widgets/path_nav/lib/utils.dart';
import 'package:mapness/widgets/path_nav/ui/end_trip_modal.dart';
import 'package:sheetify/sheetify.dart';
import 'package:urbi_utils/urbi_utils.dart';

part 'finished_state_title.dart';

part 'paused_state_title.dart';

part 'running_state_title.dart';

class EtaHeader extends HookConsumerWidget {
  final PathNavState state;

  final VoidCallback? onSearchPressed;
  final VoidCallback? onTapRoute;
  final VoidCallback onEndTripPressed;
  final VoidCallback onContinuePressed;
  final ToggleSheetController sheetController;
  final ValueListenable<bool> isSwitchingToFoot;

  const EtaHeader({
    required this.onEndTripPressed,
    required this.onContinuePressed,
    required this.sheetController,
    required this.state,
    required this.isSwitchingToFoot,
    this.onSearchPressed,
    this.onTapRoute,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eta = ref.watch(pathNavEtaProvider);
    final landscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    ref
      ..watch(etaWebsocketStatusProvider.select((_) => null))
      ..watch(websocketTypeProvider.select((_) => null))
      ..watch(shareEtaProvider.select((_) => null));

    final backgroundColor = state == PathNavState.paused
        ? context.colors.accentSecondaryDefault
        : context.colors.onMapSurfaceOnMap;

    /// Animating hide and close buttons based on the sheet interpolation.
    final animation = useAnimationController(initialValue: sheetController.isClosed ? 1.0 : 0.0);
    useEffect(() {
      final listener = () {
        animation.value = sheetController.interpolation;
      };
      sheetController.addListener(listener);
      return () => sheetController.removeListener(listener);
    }, [sheetController]);

    final isClosedButtonVisible = useState(!sheetController.isClosed);
    useEffect(() {
      final listener = () {
        isClosedButtonVisible.value = sheetController.interpolation < 0.5;
      };
      sheetController.addListener(listener);
      return () => sheetController.removeListener(listener);
    }, [sheetController]);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        onTap: () {
          if (state == PathNavState.paused) {
            onContinuePressed();
          } else if (state == PathNavState.running) {
            ref.read(parkingAutoenabledSheetProvider.notifier).showParkingAutoEnableSheet(value: false);
            sheetController.open(duration: Durations.long1 * 3);
          }
        },
        child: AnimatedSwitcher(
          duration: Durations.long1,
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: ColoredBox(
            key: ValueKey(state),
            color: backgroundColor,
            child: SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.only(top: Spacing.$1x, right: Spacing.$3x, left: Spacing.$3x),
                child: Column(
                  children: [
                    const Dragger(),
                    const SizedBox(height: Spacing.$1x),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: state != PathNavState.finished
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      children: [
                        if (state != PathNavState.paused)
                          ValueListenableBuilder<bool>(
                            valueListenable: isSwitchingToFoot,
                            builder: (context, isSwitching, child) {
                              if (isSwitching) {
                                return const SizedBox(
                                  height: 32,
                                  width: 32,
                                  child: Center(
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  ),
                                );
                              }
                              if (!landscape && onSearchPressed != null || state == PathNavState.finished) {
                                return _Button(icon: SystemIcons.search, onTap: onSearchPressed!);
                              }
                              return onTapRoute != null
                                  ? _Button(icon: GeneralIcons.routeStroke, onTap: onTapRoute!)
                                  : SizedBox(width: ButtonSize.small.height);
                            },
                          ),
                        Expanded(
                          child: switch (state) {
                            PathNavState.running => _RunningStateTitle(eta: eta),
                            PathNavState.finished => const _FinishedStateTitle(),
                            PathNavState.paused => _PausedStateTitle(eta: eta),
                          },
                        ),
                        if (state != PathNavState.paused)
                          if (state == PathNavState.finished)
                            _Button(
                              icon: SystemIcons.close,
                              onTap: () {
                                openEndTripSheet(context);
                              },
                            )
                          else
                            ListenableBuilder(
                              listenable: isClosedButtonVisible,
                              builder: (context, _) => Stack(
                                children: [
                                  IgnorePointer(
                                    ignoring: !isClosedButtonVisible.value,
                                    child: FadeTransition(
                                      key: const ValueKey('hide_button'),
                                      opacity: ReverseAnimation(animation),
                                      child: _Button(
                                        icon: SystemIcons.arrowCornerDownLarge,
                                        onTap: () {
                                          sheetController.close(duration: Durations.long1);
                                        },
                                      ),
                                    ),
                                  ),

                                  IgnorePointer(
                                    ignoring: isClosedButtonVisible.value,
                                    child: FadeTransition(
                                      key: const ValueKey('close_button'),
                                      opacity: animation,
                                      child: _Button(
                                        icon: SystemIcons.close,
                                        onTap: () {
                                          openEndTripSheet(context);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void openEndTripSheet(BuildContext context) => showModalBottomSheet(
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    isScrollControlled: true,
    context: context,
    builder: (_) => EndTripModal(onEndTripPressed: onEndTripPressed),
  );
}

class _Button extends StatelessWidget {
  final IconData? icon;
  final VoidCallback onTap;

  const _Button({required this.onTap, this.icon, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => AppButton(
    innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$1_5x),
    size: ButtonSize.small,
    primaryIcon: icon,
    buttonType: ButtonType.secondary,
    buttonColorScheme: ButtonColorScheme.neutral,
    onTap: onTap,
  );
}
