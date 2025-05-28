import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/entities/path_nav/models/path_nav_state.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/features/path_nav/lib/enums.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/navigator_auto_enable_parking.dart';
import 'package:mapness/shared/providers/map/parking_autoenabled_sheet_provider.dart';

class ParkingBanner extends ConsumerStatefulWidget {
  final ValueNotifier<PathNavState> navigationState;
  final bool isHomeOrWork;
  final RouteSearchOptionsMessage navigatorType;
  final StatelessBottomSheetController? bottomSheetController;

  const ParkingBanner({
    required this.navigationState,
    required this.navigatorType,
    this.bottomSheetController,
    this.isHomeOrWork = false,
    super.key,
  });

  @override
  ConsumerState<ParkingBanner> createState() => _ParkingBannerState();
}

class _ParkingBannerState extends ConsumerState<ParkingBanner> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 15),
  );

  @override
  void initState() {
    super.initState();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eta = ref.watch(pathNavEtaProvider);
    final distance = double.tryParse(eta?.distanceEta ?? '--');
    final autoEnableParking = ref.watch(navigatorAutoEnableParkingProvider);
    final layers = ref.watch(layersControlsProvider);

    const boxShadow = [
      BoxShadow(
        offset: Offset(0, 2),
        blurRadius: 10,
        color: Color(0x0D000000),
      )
    ];

    const borderSizeL = BorderRadius.all(Radius.circular(RadiusBorder.l));
    const borderSizeS = BorderRadius.all(Radius.circular(RadiusBorder.s));

    if (widget.navigationState.value == PathNavState.finished || layers.selectedType == LayerType.parkingLots) {
      return const SizedBox.shrink();
    }

    if (autoEnableParking != null || widget.isHomeOrWork) {
      return const SizedBox.shrink();
    }

    if (_animationController.isCompleted ||
        eta == null ||
        widget.bottomSheetController?.isClosed == false ||
        eta.distanceEtaUnits == DistanceUnits.km) {
      return const SizedBox.shrink();
    }

    // We check that our banner is not displayed for pedestrians and should be shown after 15 seconds,
    // when there are 500 m left to the point.
    if (distance != null && distance > 500 || RouteSearchOptionsMessage.pedestrian == widget.navigatorType) {
      return const SizedBox.shrink();
    }

    if (!_animationController.isAnimating && !_animationController.isCompleted) {
      _animationController.forward();
    }

    final isRtl = ref.watch(uiDirectionProvider) == TextDirection.rtl;

    return GestureDetector(
      onTap: () => ref.read(navigatorAutoEnableParkingProvider.notifier).toggleAutoEnableParking(value: true),
      child: Directionality(
        textDirection: ref.watch(uiDirectionProvider),
        child: Material(
          type: MaterialType.transparency,
          color: Colors.transparent,
          child: Container(
            height: 56,
            margin: const EdgeInsets.only(
              bottom: Spacing.$3x,
            ),
            decoration: const BoxDecoration(boxShadow: boxShadow),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.staticColor.surfaceStatusAccent,
                    borderRadius: borderSizeL,
                  ),
                  padding: const EdgeInsets.all(Spacing.$2x),
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final animationValue = _animationController.value;
                    // Calculating the animation value for corner radius rounding of the container.
                    // The "easeInOut" curve is applied to create a smooth transition effect.
                    // If the animation value (animationValue) exceeds 0.95, a transformation is applied,
                    // which increases the corner radius. Otherwise, the corners remain unchanged.
                    final cornerAnimationValue = Curves.easeInOut.transform(
                        // If the animationValue is greater than 0.95, the formula is applied to increase the corner radius.
                        // The expression (animationValue - 0.95) is transformed into a positive value and multiplied by 20 to scale it.
                        // This allows the corner radius to gradually increase during the last 5% of the animation.
                        // If animationValue is less than 0.95, the corner radius remains unchanged (value 0).
                        (animationValue > 0.95 ? (animationValue - 0.95) * 20 : 0).clamp(0.0, 1.0).toDouble());

                    return FractionallySizedBox(
                      widthFactor: animationValue,
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.colorsV3.accentActive,
                          borderRadius: BorderRadius.only(
                            topLeft: isRtl
                                ? Radius.circular(cornerAnimationValue * RadiusBorder.l)
                                : const Radius.circular(RadiusBorder.l),
                            bottomLeft: isRtl
                                ? Radius.circular(cornerAnimationValue * RadiusBorder.l)
                                : const Radius.circular(RadiusBorder.l),
                            topRight: isRtl
                                ? const Radius.circular(RadiusBorder.l)
                                : Radius.circular(cornerAnimationValue * RadiusBorder.l),
                            bottomRight: isRtl
                                ? const Radius.circular(RadiusBorder.l)
                                : Radius.circular(cornerAnimationValue * RadiusBorder.l),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(Spacing.$2x),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: context.colorsV3.backgroundSurface1,
                          borderRadius: borderSizeS,
                        ),
                        padding: const EdgeInsets.all(Spacing.$2x),
                        child: EventsOnTheRoute.parking.icon(color: context.staticColor.surfaceStatusAccent),
                      ),
                      Spacing.$3x.widthBox,
                      Expanded(
                        child: Text(
                          context.l10n.showParkingSuggestions,
                          style:
                              context.textStyleV3.bodyLargeMedium.copyWith(color: context.colorsV3.backgroundSurface1),
                        ),
                      ),
                      AppButton(
                        size: ButtonSize.small,
                        buttonColorScheme: ButtonColorScheme.primary,
                        primaryIcon: SystemIcons.close,
                        iconColor: context.colorsV2.staticWhite,
                        color: Colors.transparent,
                        onTap: () {
                          _animationController.value = 1.0;
                          widget.bottomSheetController?.close();
                          ref.read(parkingAutoenabledSheetProvider.notifier).showParkingAutoEnableSheet(value: true);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
