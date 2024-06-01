import 'package:balady_uikit/balady_uikit.dart' as uiKit;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/happines_control.dart';
import 'package:mapness/_features/landing/widgets/indoor_control.dart';
import 'package:mapness/_features/landing/widgets/layers_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/_features/weather/widgets/weather_control.dart';
import 'package:mapness/app/routes/kiblah.dart';
import 'package:mapness/app/routes/weather.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/app_features.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';

class PoiCardMapControls extends ConsumerStatefulWidget {
  const PoiCardMapControls({
    required this.biggestHeight,
    required this.bottomSheetSize,
    super.key,
  });
  final double biggestHeight;
  final ValueNotifier<double> bottomSheetSize;

  static const horizontalPadding = uiKit.NumericBase.$3x;
  static const topPadding = uiKit.NumericBase.$3x;
  static const bottomPadding = uiKit.NumericBase.$4x;

  @override
  ConsumerState<PoiCardMapControls> createState() => _PoiCardMapControlsState();
}

class _PoiCardMapControlsState extends ConsumerState<PoiCardMapControls> {
  late double bottomExtent;
  bool hideControls = false;

  @override
  void initState() {
    super.initState();
    bottomExtent = footerHeight + headerHeight;
    widget.bottomSheetSize.addListener(_scrollListener);
  }

  void _scrollListener() {
    // final cameraController = ref.read(cameraPositionProvider.notifier);
    // final pixelSize = MediaQuery.of(context).devicePixelRatio;

    Future.delayed(Duration.zero, () {
      final double screenHeight = MediaQuery.of(context).size.height;

      final size = widget.bottomSheetSize.value;
      final extendSize = screenHeight - size;

      final currentSize = 1 - (extendSize / screenHeight);

      final double padding = currentSize * screenHeight;

      // Hide controls when the bottom sheet is expanded
      final locationBottomSheet = currentSize > 0.75;

      setState(() {
        hideControls = locationBottomSheet;
        if (currentSize > 0.2 && currentSize < 0.4) {
          // for a new feature you need to change and replace the magic number, now these numbers are taken by taking into account all the indents, the height of the bottom nav bar
          bottomExtent = footerHeight + headerHeight + padding - 74 - 80;
        } else {
          bottomExtent = footerHeight + headerHeight - 40;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
        ignoring: hideControls,
        child: AnimatedOpacity(
          opacity: hideControls ? 0 : 1,
          duration: const Duration(milliseconds: 250),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: PoiCardMapControls.horizontalPadding,
                        top: PoiCardMapControls.topPadding,
                        right: PoiCardMapControls.horizontalPadding,
                        bottom: PoiCardMapControls.bottomPadding,
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WeatherControl(
                                onTap: () => const WeatherRoute().push(context),
                              ),
                              const SizedBox(height: 8),
                              const HappinesControl(),
                              const Spacer(),
                              const IndoorControl(),
                              const Spacer(),
                              MapButton(
                                child: SvgPicture.asset(
                                  'assets/icons/svg/ic_controls_qibla.svg',
                                  semanticsLabel: 'MinApps Screen',
                                  package: 'mapness',
                                ),
                                onTap: () {
                                  Metrics.logEventAdvanced(MetricsConstants.exploreKeys.qibla,
                                      action: MetricAction.tap.name, group: MetricsConstants.exploreTag);
                                  const KiblahRoute().pushReplacement(context);
                                },
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const LayersControl(),
                              const SizedBox(
                                height: 8,
                              ),
                              Consumer(
                                builder: (context, ref, _) {
                                  final navi = ref.watch(appFeaturesProvider);
                                  return Visibility(
                                    visible: navi.naviEnabled,
                                    replacement: const SizedBox.square(
                                      dimension: 28,
                                    ),
                                    child: const TrafficControl(),
                                  );
                                },
                              ),
                              const Spacer(),
                              const ZoomControl(),
                              const Spacer(),
                              const CompassControl(),
                              const SizedBox(
                                height: 8,
                              ),
                              const FollowControl(
                                //TODO(scroollocker): Double check this
                                onlyFollowDirection: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: bottomExtent,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
